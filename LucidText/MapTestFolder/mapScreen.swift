//
//  mapScreen.swift
//  integrateMap
//
//  Created by Vin Somasundaram on 4/13/20. Additions made by Conner Lewis on 4/15/20
//  Copyright © 2020 Vin Somasundaram. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Network
import Foundation


/*
protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}
*/import SystemConfiguration

public class Reachability {

    class func isConnectedToNetwork() -> Bool {

        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }

        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }

        /* Only Working for WIFI
        let isReachable = flags == .reachable
        let needsConnection = flags == .connectionRequired

        return isReachable && !needsConnection
        */

        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)

        return ret

    }
}

class mapScreen: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var tableView: UITableView!
    //let pinview = MKAnnotationView()
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 10000
    var matchingItems: [MKMapItem] = []
    var selectedPin:MKPlacemark? = nil
    var LatMax = CLLocationDegrees(-90)
    var LatMin =  CLLocationDegrees(90)
    var LonMax =  CLLocationDegrees(-180)
    var LonMin =  CLLocationDegrees(180)
    var n: Int = 0
    var cur: Int = 0

    var pickerData: [String] = [String]()
    
    let monitor = NWPathMonitor()
    //let queue = DispatchQueue(label: "Monitor")
    
    @IBOutlet weak var picker: UIPickerView!
    @IBAction func displayLoc(_ sender: Any) {
        clearpins()

        makeAPIcall()
        
        LatMax = CLLocationDegrees(-90)
        LatMin =  CLLocationDegrees(90)
        LonMax =  CLLocationDegrees(-180)
        LonMin =  CLLocationDegrees(180)

    }
    override func viewDidLoad() {
        let image:UIImage = UIImage(named: "lucidHeader")!
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        self.navigationItem.titleView = imageView
        mapView.showsUserLocation = true
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "appLightBlue")
            //UIColor.systemTeal
        /*monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("We're connected!")
            } else {
                print("No connection.")
                //Error Message
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Network Connection Error", message: "Please reload the app with the internet active.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            }

        }
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
*/
        checkLocationServices()
        self.picker.delegate = self
        self.picker.dataSource = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        pickerData = ["Language Schools", "Tutoring", "Library", "Museum"]
    
    }
    
    func setUpLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setUpLocationManager()
            checkLocationAuthorization()
        }
        else {
            
            //boolin 2
        }
    }
    
    func clearpins() {
        for ann in self.mapView.annotations {
            self.mapView.removeAnnotation(ann)
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case.authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            //Do map stuff
            break
        case.denied:
            print("denied")
            //show alert
            break
        case.notDetermined:
            print("this case")
            locationManager.requestWhenInUseAuthorization()
        case.restricted:
            print("restricted")
            //show alert
            break
        case.authorizedAlways:
            print("always")
            break
        @unknown default:
            print("default")
            break
        }
    }
    
    func makeAPIcall() {
        if !(Reachability.isConnectedToNetwork()){
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Network Connection Error", message: "Please reload the app with the internet active.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
            return
        }
        var selection = pickerData[cur]
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = selection
       // print(request.naturalLanguageQuery)
        if let location = locationManager.location?.coordinate {
            request.region = MKCoordinateRegion(center: location, latitudinalMeters: regionInMeters*4, longitudinalMeters: regionInMeters*4)
        }
        else {
            request.region = mapView.region
        }
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                //print("2")
                let alert1 = UIAlertController(title: "Locations Not Found", message: "It would appear there are no locations of this type nearby.", preferredStyle: .alert)

                  alert1.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

                  UIApplication.shared.keyWindow?.rootViewController?.present(alert1, animated: true, completion: nil)
                return
            }
            self.matchingItems = response.mapItems
            
            while self.n < self.matchingItems.count {
                let selectedItem = self.matchingItems[self.n].placemark
                self.dropPinZoomIn(placemark: selectedItem)
             //     print(selectedItem.title)
                self.n += 1
                  //fillCells()
              }
              
            self.tableView.reloadData()
              
            self.n=0
        }
  
    }
    
    func parseAddress(selectedItem:MKPlacemark) -> String {
        // put a space between "4" and "Melrose Place"
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
        // put a comma between street and city/state
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        // put a space between "Washington" and "DC"
        let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            // street number
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            // street name
            selectedItem.thoroughfare ?? "",
            comma,
            // city
            selectedItem.locality ?? "",
            secondSpace,
            // state
            selectedItem.administrativeArea ?? ""
        )
        return addressLine
    }
    
    func dropPinZoomIn(placemark:MKPlacemark){
 
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        //self.mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        annotation.subtitle = parseAddress(selectedItem: placemark)
        mapView.addAnnotation(annotation)
        

        
        
        if let location = locationManager.location?.coordinate {
  

            
            if placemark.coordinate.longitude > LonMax  {
                LonMax = placemark.coordinate.longitude
            }
            if placemark.coordinate.longitude < LonMin {
                LonMin = placemark.coordinate.longitude
            }
            if placemark.coordinate.latitude > LatMax {
                LatMax = placemark.coordinate.latitude
            }
            if placemark.coordinate.latitude < LatMin {
                LatMin = placemark.coordinate.latitude
            }
            if location.longitude > LonMax  {
                LonMax = location.longitude
            }
            if location.longitude < LonMin {
                LonMin = location.longitude
            }
            if location.latitude > LatMax {
                LatMax = location.latitude
            }
            if location.latitude < LatMin {
                LatMin = location.latitude
            }

            let latSpan = LatMax - LatMin
            let longSpan = LonMax - LonMin

            let span = MKCoordinateSpan(latitudeDelta: latSpan, longitudeDelta: longSpan)
            var locationCenter = findCenter(coords: matchingItems)
            //locationCenter.latitude = (LatMax + LatMin) / 2
            //locationCenter.longitude = (LonMax + LonMin) / 2
            let region1 = MKCoordinateRegion(center: locationCenter, span: span)
            mapView.setRegion(region1, animated: true)
        }
        //getDirections()
    }
    
    func findCenter(coords:[MKMapItem]) -> CLLocationCoordinate2D {
          if (coords.count == 1) {
            return coords[0].placemark.coordinate;
          }

          var x = 0.0;
          var y = 0.0;
          var z = 0.0;

          for coord in coords {
            let latitude = coord.placemark.coordinate.latitude * Double.pi / 180;
            let longitude = coord.placemark.coordinate.longitude * Double.pi / 180;

            x += cos(latitude) * cos(longitude);
            y += cos(latitude) * sin(longitude);
            z += sin(latitude);
          }

          let total = coords.count;

        x = x / Double(total);
        y = y / Double(total);
        z = z / Double(total);

          let centralLongitude = atan2(y, x);
          let centralSquareRoot = sqrt(x * x + y * y);
          let centralLatitude = atan2(z, centralSquareRoot);

        var center = CLLocationCoordinate2D()
        center.latitude = centralLatitude * 180 / Double.pi
        center.longitude = centralLongitude * 180 / Double.pi

          return center
        }
    
    
    @objc func getDirections(){
        guard let selectedPin = selectedPin else { return }
        let mapItem = MKMapItem(placemark: selectedPin)
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        mapItem.openInMaps(launchOptions: launchOptions)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
         return pickerData[row]
     }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
        cur = row
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let selectedItem = matchingItems[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: "resCell", for: indexPath) as! resultCell
        cell.contentView.isUserInteractionEnabled = true

        cell.Main?.text = selectedItem.placemark.name!
        if selectedItem.url != nil {
            cell.givenURL = selectedItem.url
        } else {
            cell.givenURL = URL(string: "NA")
        }
        //cell.URL.text = matchingItems[indexPath.row].placemark.ur
        //print("There!")
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
       return "Search Results"
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
}

extension mapScreen: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{

        guard !(annotation is MKUserLocation) else { return nil }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        }
        pinView?.pinTintColor = UIColor.orange
        pinView?.canShowCallout = true

        let smallSquare = CGSize(width: 30, height: 30)
        let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
        button.setBackgroundImage(UIImage(named: "car"), for: [])

        button.addTarget(self, action: #selector(mapScreen.getDirections), for: .touchUpInside)
        pinView?.leftCalloutAccessoryView = button

         return pinView
    }
}

extension mapScreen: CLLocationManagerDelegate {
      
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
    
}


class resultCell: UITableViewCell {
    
    
    @IBOutlet weak var Main: UILabel?
    var givenURL: URL!
    private var showingAlert = false
    
    @IBAction func URL(_ sender: Any) {
        if givenURL.absoluteString != "NA" {
            UIApplication.shared.open(givenURL)
        } else {
            self.showingAlert = true
            let alert = UIAlertController(title: "Website Unavailable", message: "It would appear this business has not listed a website.", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)

            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}





