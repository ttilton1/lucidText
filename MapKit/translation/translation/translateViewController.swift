//
//  translateViewController.swift
//  translation
//
//  Created by Vin Somasundaram on 3/31/20.
//  Copyright © 2020 Vin Somasundaram. All rights reserved.
//

import UIKit

class translateViewController: UIViewController {

    @IBOutlet weak var engText: UITextField!
    @IBOutlet weak var resultText: UILabel!
    
    struct totalTranslate: Codable {
        var data: indivTrans
        
        init() {
            data = indivTrans()
        }
    }
    struct indivTrans: Codable {
        var translations: [specificText]
        
        init() {
            translations = []
        }
    }
    struct specificText: Codable {
        var translatedText: String
        
        init() {
            translatedText = ""
        }
    }
    
    var theTranslation = totalTranslate()
        
    
    override func viewDidLoad() {
        //getAllData()
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    func getAllData(inputText: String) {
        let headers = [
            "x-rapidapi-host": "google-translate1.p.rapidapi.com",
            "x-rapidapi-key": "5dc106ab99msh21857717c72d514p1ddd64jsn0c09f27c12d8",
            "content-type": "application/x-www-form-urlencoded"
        ]
        
        let textTotal = "&q=" + inputText
        let postData = NSMutableData(data: "source=en".data(using: String.Encoding.utf8)!)
        postData.append(textTotal.data(using: String.Encoding.utf8)!)
        postData.append("&target=es".data(using: String.Encoding.utf8)!)
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://google-translate1.p.rapidapi.com/language/translate/v2")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data

        let session = URLSession.shared
        /*
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            }
        */
        let dataTask = session.dataTask(with: request as URLRequest) {data, response, error in guard error == nil else {
                DispatchQueue.main.async {
                    let alert1 = UIAlertController(title: "No Wifi", message: "You are not connected to Wifi", preferredStyle: .alert)
                    
                    alert1.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    
                    self.present(alert1, animated: true)
                    
                }
            
                print ("error: \(error!)")
                return

            }
            
            guard let jsonData = data else {
                print("No data")
                return
            }
            
            print("Got the data from network")
            
            // 4. DECODE THE RESULTING JSON
            //
            let decoder = JSONDecoder()
            
            do {
                // decode the JSON into our array of todoItem's
                
                let attempter = try decoder.decode(totalTranslate.self, from: jsonData)
                print(attempter)
                
                DispatchQueue.main.async {
                    self.theTranslation = attempter
                }
                
            }
            catch {
                print("JSON Decode error")
            }
            
            
            
        }
        
        dataTask.resume()
    }
    
    
    
    @IBAction func searchPressed(_ sender: Any) {
        getAllData(inputText: engText.text!)
    }
    
    @IBAction func displayText(_ sender: Any) {
        resultText.text = theTranslation.data.translations[0].translatedText
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
