//
//  passTextViewController.swift
//  LucidText
//
//  Created by Thomas Tilton on 4/13/20.
//  Copyright © 2020 Thomas Tilton. All rights reserved.
//

import UIKit


class passTextViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    
    //outlets
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet weak var addButton: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "LucidText"
        setUpLabel()
        setUpTextView()
        print(sectionsArray[1])
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: view.frame.width, height: 300)
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(passTextViewCell.self, forCellWithReuseIdentifier: "passTextCell")
        collectionView.backgroundColor = UIColor.black
        
       // collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "passTextCell")

        NotificationCenter.default.addObserver(self, selector: #selector(self.rotated), name: UIDevice.orientationDidChangeNotification, object: nil)

        /* BEGGGINGING
        let widthTest = view.frame.width - 20
        //let widthTest = view.safeAreaLayoutGuide.widthAnchor.
        //view.safeAreaLayoutGuide.heightAnchor
        
        // let heightTest = cell.frame.height
         let heightTest2 = view.frame.height * 0.12
        let newHeightZero = self.view.frame.origin.y + (self.navigationController?.navigationBar.frame.height ?? 0)
            //view.safeAreaInsets.top
        print(self.view.frame.origin.y)
        headerLabel.frame = CGRect(x: 10, y: newHeightZero, width: widthTest - 10, height: heightTest2)
        print(newHeightZero)
        // let heightTest = cell.frame.height
         let heightTest3 = view.frame.height * 0.4
        let newHeightOne = heightTest2 + 20
         textView.frame = CGRect(x: 10, y: newHeightOne, width: widthTest-10, height: heightTest3)
        print(newHeightOne)
 
         let heightTest4 = view.frame.height * 0.4
         let newHeightTwo = newHeightOne + heightTest3
         collectionView.frame = CGRect(x: 0, y: 0, width: widthTest-10, height: heightTest4)
        ENDDDDD*/
        
        /*
         let heightTest5 = view.frame.height * 0.1
         let newHeightThree = newHeightTwo + 10
         addButton.frame = CGRect(x: 10, y: newHeightThree, width: widthTest-10, height: heightTest5)
        */
         
        // Do any additional setup after loading the view.
    }
    
    @objc func rotated() {
        self.viewDidLoad()
    }
    
    func setUpLabel() {
        headerLabel.textAlignment = .center
        //headerLabel.aligm
        headerLabel.text = "Finished processing text."
        headerLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        

    }
    
    func setUpTextView() {
        textView.sizeToFit()
        //cell.textView.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        textView.textColor = cellTextColor
        textView.layer.cornerRadius = cornerRadiusVar
        textView.layer.borderWidth = cellBorderWidth
        textView.layer.borderColor = cellBorderColor
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("GOTCHCAA")
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "passTextCell", for: indexPath) as? passTextViewCell else {
                            fatalError("Unable to dequeue CellOne")
                        }
           //print(indexPath.row)
           //print(sectionsArray[)
           cell.textLabel.text = "little"
                //headingLabels[0]
            cell.textView.text = "This is a definition"
            print("helloooooo")
            cell.textLabel.numberOfLines = 0
            cell.textLabel.lineBreakMode = .byTruncatingTail
            cell.textLabel.font = UIFont.boldSystemFont(ofSize: 25.0)
            cell.textLabel.minimumScaleFactor = 0.5
            cell.textLabel.sizeToFit()
            cell.textLabel.textColor = cellTextColor
            let widthTest = cell.frame.width - 20
           // let heightTest = cell.frame.height
            let heightTest2 = cell.frame.height * 0.25
            cell.textLabel.frame = CGRect(x: 10, y: 5, width: widthTest-10, height: heightTest2)
            
            cell.textView.sizeToFit()
            cell.textView.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            cell.textView.textColor = cellTextColor
            cell.textView.isEditable = false
            let widthTestTwo = cell.frame.width - 20
            let heightTestTwo = cell.frame.height * 0.6
            cell.textView.frame = CGRect(x: 10, y: 5 + heightTest2, width: widthTestTwo-10, height: heightTestTwo)

            cell.layer.cornerRadius = cornerRadiusVar
            cell.layer.borderWidth = cellBorderWidth
            cell.layer.borderColor = cellBorderColor
            cell.layer.backgroundColor = cellBackgroundColor
            
        
           //NEED TO ADD INDEXO OATH SECTION
            return cell
    }

    /*
     override func numberOfSections(in collectionView: UICollectionView) -> Int {
         // #warning Incomplete implementation, return the number of sections
         return 1
     }


     override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         // #warning Incomplete implementation, return the number of items
         return sectionsArray[section].count
     }

     override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         
         if (indexPath.row == 0 && indexPath.section == 0) {
             guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: passTextCell, for: indexPath) as? passTextViewCell else {
                 fatalError("Unable to dequeue CellOne")
             }

             cell.textLabel.text = "Input Text"
                 //headingLabels[0]
             cell.textView.text = sectionsArray[0][0]
             
             cell.textLabel.numberOfLines = 0
             cell.textLabel.lineBreakMode = .byTruncatingTail
             cell.textLabel.font = UIFont.boldSystemFont(ofSize: 25.0)
             cell.textLabel.minimumScaleFactor = 0.5
             cell.textLabel.sizeToFit()
             cell.textLabel.textColor = cellTextColor
             let widthTest = cell.frame.width - 20
            // let heightTest = cell.frame.height
             let heightTest2 = cell.frame.height * 0.15
             cell.textLabel.frame = CGRect(x: 10, y: 5, width: widthTest-10, height: heightTest2)
             
             //try highlighting
             let range = (sectionsArray[0][0] as NSString).range(of: "little")
             let attribute = NSMutableAttributedString.init(string: sectionsArray[0][0] )
             attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red , range: range)
             
             
             cell.textView.sizeToFit()
             cell.textView.font = UIFont.systemFont(ofSize: 14, weight: .regular)
             cell.textView.textColor = cellTextColor
             cell.textView.isEditable = false
             let widthTestTwo = cell.frame.width - 20
             let heightTestTwo = cell.frame.height * 0.8
             cell.textView.frame = CGRect(x: 15, y: 5 + heightTest2, width: widthTestTwo-10, height: heightTestTwo)
             cell.textView.attributedText = attribute
            // cell.textView.layer.cornerRadius = cornerRadiusVar
            // cell.textView.layer.borderWidth = cellBorderWidth
            // cell.textView.layer.borderColor = cellBorderColor
             
             cell.layer.cornerRadius = cornerRadiusVar
             cell.layer.borderWidth = cellBorderWidth
             cell.layer.borderColor = cellBorderColor
             cell.layer.backgroundColor = cellBackgroundColor
             
         
            //NEED TO ADD INDEXO OATH SECTION
             return cell
         } else {
             guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifierText, for: indexPath) as? textCell else {
                     fatalError("Unable to dequeue CellOne")
                 }

                cell.textLabel.text = sectionsArray[1][indexPath.row]
                     //headingLabels[0]
                 cell.textView.text = "This is a definition"
                 
                 cell.textLabel.numberOfLines = 0
                 cell.textLabel.lineBreakMode = .byTruncatingTail
                 cell.textLabel.font = UIFont.boldSystemFont(ofSize: 25.0)
                 cell.textLabel.minimumScaleFactor = 0.5
                 cell.textLabel.sizeToFit()
                 cell.textLabel.textColor = cellTextColor
                 let widthTest = cell.frame.width - 20
                // let heightTest = cell.frame.height
                 let heightTest2 = cell.frame.height * 0.25
                 cell.textLabel.frame = CGRect(x: 10, y: 5, width: widthTest-10, height: heightTest2)
                 
                 cell.textView.sizeToFit()
                 cell.textView.font = UIFont.systemFont(ofSize: 14, weight: .regular)
                 cell.textView.textColor = cellTextColor
                 cell.textView.isEditable = false
                 let widthTestTwo = cell.frame.width - 20
                 let heightTestTwo = cell.frame.height * 0.6
                 cell.textView.frame = CGRect(x: 10, y: 5 + heightTest2, width: widthTestTwo-10, height: heightTestTwo)

                 cell.layer.cornerRadius = cornerRadiusVar
                 cell.layer.borderWidth = cellBorderWidth
                 cell.layer.borderColor = cellBorderColor
                 cell.layer.backgroundColor = cellBackgroundColor
                 
             
                //NEED TO ADD INDEXO OATH SECTION
                 return cell
         }
     
         // Configure the cell
         
    
     }
     
*/
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
