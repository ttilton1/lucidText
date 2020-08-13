//
//  ProcessedTextViewController.swift
//  LucidText
//
//  Created by Thomas Tilton on 4/13/20.
//  Copyright © 2020 Thomas Tilton. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifierTextTwo = "textTwoCell"
private let reuseIdentifierHardWords = "HardWordsCell"
//var textToProcess = "Mary had a little lamb.Mary had a little lamb.Mary had a little lamb.Mary had a little lamb.Mary had a little lamb.Mary had a little lamb.Mary had a little lamb.Mary had a little lamb.Mary had a little lamb.Mary had a little lamb.Mary had a little lamb.Mary had a little lamb.Mary had a little lamb.Mary had a little lamb.Mary had a little lamb.Mary had a little lamb.Mary had a little lamb.Mary had a little lamb."
var defWords: [String] = ["little","lamb"]
//var sectionsArray: [[String]] = [[textToProcess], defWords]

//setup
private let sectionInsets = UIEdgeInsets(top: 20.0,
left: 20.0, //was 20
    bottom: 5.0, //was 50
right: 20.0)

private let inBetweenSpacing: CGFloat = 5

private let cellHeightText: CGFloat = 250
private let cellHeightWords: CGFloat = 120
private let headerHeight: CGFloat = 50

private let itemsPerRow: CGFloat = 1

//Header
private let procHeadings = ["Processing is complete.", "Challenging Words", "Click below to add words to your dictionary."]
private let cellId = "cellId"
private let cellButtonId = "cellButtonId"

var newDefs: [String] = ["Mary had a little lamb.Mary had a little lamb.Mary had a little lamb.Mary had a little lamb.Mary had a little lamb.Mary had a little lamb.Mary had a little lamb.Mary had a little lamb.Mary had a little lamb.Mary had a little lamb.Mary had a little lamb.Mary had a little", "Def2", "Def3"]
var hardWords: [String] = ["Hardword1", "HardWord2", "HardWord3"]
var container: NSPersistentContainer!

class ProcessedTextTwoViewController: UICollectionViewController, UITextViewDelegate {
    
    var synList = [String: String]()
    //Translator
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
        
   // var container: NSPersistentContainer!
    var titleLabel = "Input Text"
    var incomingWordStructs = [newWord]()
    var incomingWords = Set<String>() //
    var incomingText = String()
   // var sectionsArray: [[String]] = [[self.textToProcess], self.defWords]
    var attributedQuote = NSAttributedString()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewDidLoad()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //_____CoreData START____________
        container = NSPersistentContainer(name: "LucidText")
        
        container.loadPersistentStores { storeDescription, error in
            container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            if let error = error {
                print("Unresolved error \(error)")
            }
        }
        
        //_____END COREDATA___________
        let image:UIImage = UIImage(named: "lucidHeader")!
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        self.navigationItem.titleView = imageView
        //self.navigationItem.titleView.ali
       // var sectionsArray: [[String]] = [[textToProcess], defWords]
        //self.navigationItem.backBarButtonItem?.title = "Back"
        self.navigationItem.title = "Lucid Text"
        self.tabBarItem.title = "Enter Text"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
     //   self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifierProcessedText)
        
     //   self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifierHardWords)
        collectionView?.register(CategoryCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView.backgroundColor = backgroundColor
        self.collectionView?.reloadData()

        NotificationCenter.default.addObserver(self.collectionView!,
                                               selector: #selector(UICollectionView.reloadData),
                                               name: UIContentSizeCategory.didChangeNotification,
                                               object: nil)

        // Do any additional setup after loading the view.
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        guard
            let previousTraitCollection = previousTraitCollection,
            self.traitCollection.verticalSizeClass != previousTraitCollection.verticalSizeClass ||
            self.traitCollection.horizontalSizeClass != previousTraitCollection.horizontalSizeClass
        else {
            return
        }
       
        self.collectionView?.collectionViewLayout.invalidateLayout()
        self.collectionView?.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if (indexPath.section == 0) {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifierTextTwo, for: indexPath) as? textTwoCell else {
                fatalError("Unable to dequeue CellOne")
            }

            cell.textLabel.text = titleLabel
                //headingLabels[0]
           // cell.textView.text = sectionsArray[0][0]
            
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

            /*
            let range = (sectionsArray[0][0] as NSString).range(of: "little")
            let attribute = NSMutableAttributedString.init(string: sectionsArray[0][0] )
            attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red , range: range)
            cell.textView.attributedText = attribute
             */
            
            //cell.textView.sizeToFit()
            cell.textView.delegate = self
            cell.textView.font = UIFont.systemFont(ofSize: 20, weight: .regular)
            cell.textView.textColor = cellTextColor
            cell.textView.isEditable = false
            let widthTestTwo = cell.frame.width - 20
            let heightTestTwo = cell.frame.height * 0.8
            cell.textView.text = incomingText
           // cell.textView.attributedText.
            let font = UIFont.systemFont(ofSize: 18)
        //    let attributes = [NSAttributedString.Key.font: font]
          //  let attributedQuote1 = NSAttributedString(string: incomingText)
            //attributedQuote1.att
           // cell.textView.attributedText = attributedQuote
           // generateAttributedString(with: "hey", targetString: incomingText) { (GoodString) in
          //      cell.textView.attributedText = GoodString
        //    }
           // generateAttributedString(with: "egyptian", targetString: incomingWords
            cell.textView.frame = CGRect(x: 15, y: 5 + heightTest2, width: widthTestTwo-10, height: heightTestTwo)
            
           // cell.textView.layer.cornerRadius = cornerRadiusVar
           // cell.textView.layer.borderWidth = cellBorderWidth
           // cell.textView.layer.borderColor = cellBorderColor
            
            cell.layer.cornerRadius = cornerRadiusVar
            cell.layer.borderWidth = cellBorderWidth
            cell.layer.borderColor = cellBorderColor
            cell.layer.backgroundColor = cellBackgroundColor
            
        
           //NEED TO ADD INDEXO OATH SECTION
            return cell
        } else if (indexPath.section == 1) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CategoryCell
            cell.incomingWordStruct = incomingWordStructs
            
            return cell
               //NEED TO ADD INDEXO OATH SECTION
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellButtonId, for: indexPath) as! buttonCell
            cell.addButton.setTitle("Add Words to Dictionary", for: .normal)
            cell.addButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
            ColorFrames.styleFilledButton(cell.addButton)
            cell.addButton.showsTouchWhenHighlighted = true
            cell.addButton.isHidden = false
            cell.addButton.isEnabled = true
             let widthTestTwo = cell.frame.width - 10
            let heightTestTwo = cell.frame.height * 0.5
            cell.addButton.layer.frame = CGRect(x: 10, y: 0, width: widthTestTwo-10, height: heightTestTwo)
            cell.addButton.addTarget(self, action: #selector(self.saveToDictionary), for: .touchUpInside)
            //cell.addButton.action
            cell.isUserInteractionEnabled = true
            return cell
        }
    
        // Configure the cell
        
   
    }
    
    func generateAttributedString(with searchTerm: String, targetString: String, completion: @escaping (_ syns: NSAttributedString?) -> ()){

        let attributedString = NSMutableAttributedString(string: targetString)
        let countWords = incomingWords.count
        var counter = 0
        for part in incomingWords{
            do {
                  let regex = try NSRegularExpression(pattern: part.trimmingCharacters(in: .whitespacesAndNewlines).folding(options: .diacriticInsensitive, locale: .current), options: .caseInsensitive)
                  let range = NSRange(location: 0, length: targetString.utf16.count)
                  for match in regex.matches(in: targetString.folding(options: .diacriticInsensitive, locale: .current), options: .withTransparentBounds, range: range) {
                    attributedString.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor.yellow, range: match.range)

                    //  attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold), range: match.range)
                      //NSAttributedString.Key.foregroundColor, value: UIColor.red , range: range

                  }
                    if counter == countWords{
                        completion(attributedString)
                    }else{
                        counter = counter + 1
                    }
                } catch {
                    NSLog("Error creating regular expresion: \(error)")
                    if counter == countWords{
                        completion(attributedString)
                    }else{
                        counter = counter + 1
                    }
                   
                }
        }
  
       // return attributedStrin
    }
    

    
    @objc func saveToDictionary(sender: UIButton) {
        print("Tap Tap")
        if !(Reachability.isConnectedToNetwork()){
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Network Connection Error", message: "Please reload the app with the internet active.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
            return
        }
        UIView.animate(withDuration: 0.2, animations: {
            sender.alpha = 0.5
        }) { (finished) in
          //  sender.isHidden = finished
            
         // sender.setTitle("Added Words", for: .normal)
        }
        UIView.animate(withDuration: 0.1, animations: {
            sender.alpha = 1
        }) { (finished) in
          //  sender.isHidden = finished
            //ender.setTitle("Added Words", for: .normal)
            //sender. = UIFont.systemFont(ofSize: 18, weight: .regular)
            sender.setTitleColor(.white, for: .normal)
        }
        
       // sender.isHidden = true
       // sender.motionEffects = UIMotionEffect.
        sender.isEnabled = false
        if incomingWordStructs.count == 0 {
            self.removeSpinner()
            return
        }
        self.showSpinner(onView: self.view)
        beginSave(inputStructArray: incomingWordStructs) { (note) in
            
            self.saveContext()
            /*
            trackerName = ("\(!trackerBool)")
            NotificationCenter.default.post(name: Notification.Name(rawValue: trackerName), object: self)
            */
            print(note!)
            self.removeSpinner()
            DispatchQueue.main.async {
                sender.setTitle("Added Words", for: .normal)
            }
        }
        
        //Be sure to subtract old names before adding
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                  viewForSupplementaryElementOfKind kind: String,
                                  at indexPath: IndexPath) -> UICollectionReusableView {
       // 1
       switch kind {
       // 2
       case UICollectionView.elementKindSectionHeader:
         // 3
         guard
           let headerView = collectionView.dequeueReusableSupplementaryView(
             ofKind: kind,
             withReuseIdentifier: "headerTwoVC",
             for: indexPath) as? headTwoView
           else {
             fatalError("Invalid view type")
         }
        
         headerView.label.text = procHeadings[indexPath.section]
         if (indexPath.section == 0 || indexPath.section == 2 ){
            headerView.label.font = UIFont.boldSystemFont(ofSize: 15.0)
         } else{
            headerView.label.font = UIFont.boldSystemFont(ofSize: 22.0)
         }
         
         headerView.backgroundColor = backgroundColor
         return headerView
     
       default:
         // 4
         assert(false, "Invalid element type")
       }
     }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: headerHeight)
        
    }
/*
    //put this in "AddWords" button in ProcessTextTwoViewController
    let wordDataPoint = SavedWord(context: self.container.viewContext)
    wordDataPoint.name = newWordStruct.name
    wordDataPoint.definition = newWordStruct.definition
    wordDataPoint.synonyms = newWordStruct.synonyms
    wordDataPoint.spanish = newWordStruct.spanish
    wordDataPoint.arabic = newWordStruct.arabic
    wordDataPoint.hindi = newWordStruct.hindi
    wordDataPoint.portuguese = newWordStruct.portuguese
    wordDataPoint.bengali = newWordStruct.bengali
    wordDataPoint.mandarin = newWordStruct.mandarin
     self.saveContext()
     
     incomingWordsStruct
     */
}
extension ProcessedTextTwoViewController {
    
    func getAllData(inputText: String, completion: @escaping (_ translationDict: [String: String]?) -> ()) {
        //NEW FUNCTION FOR TRANSLATIONS
        
            struct Root: Codable {
                      let outputs: [Out]
                  }
                  
                  struct Out: Codable {
                      let output: Output
                  }
                  
                  struct Output: Codable {
                      let matches: [Match]
                     // let sDictSearch: Bool
                  }
                  
                  struct Match: Codable{
                      let auto_complete: Bool
                      let model_name: String
                      let source: Source
                      let targets: [Target]
                  }
                  
                  struct Source: Codable {
                      let inflection: String
                      let info: String
                      let lemma: String
                      let phonetic: String
                      let pos: String
                      let term: String
                  }
                  
                  struct Target: Codable {
                      let lemma: String
                      let synonym: String
                  }
                  
                  let headers = [
                      "x-rapidapi-host": "systran-systran-platform-for-language-processing-v1.p.rapidapi.com",
                      "x-rapidapi-key": "2a6a7cb51cmshf5c498e9aa3a847p1187ffjsnb381fee134ff"
                  ]
            //Variable to hold returned string of translations
            var retTranslations: [String: String] = ["es": "",
                                                        "zh-Hans": "",
                                                        "hi": "",
                                                        "bn": "",
                                                        "pt": "",
                                                        "ar": "",]
            //variable to hold array of string translations
          
                  //let languages: [String] = ["es", ]
                  let transCount = retTranslations.count - 1
                  var counter = 0
                  for (key,value) in retTranslations {
                      print(key)
                    
                    let request = NSMutableURLRequest(url: NSURL(string: "https://systran-systran-platform-for-language-processing-v1.p.rapidapi.com/resources/dictionary/lookup?source=en&target=\(key)&input=\(inputText)")! as URL,
                        cachePolicy: .useProtocolCachePolicy,
                        timeoutInterval: 10.0)
                    
                    request.httpMethod = "GET"
                    request.allHTTPHeaderFields = headers

                    let session = URLSession.shared
        /*
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            }
        */
          let dataTask = session.dataTask(with: request as URLRequest) {data, response, error in guard error == nil else {
                                    DispatchQueue.main.async {
                                     self.removeSpinner()
                                        return
                                    }
                                    print ("error: \(error!)")
                                    return
                                    
                                }
              guard let jsonData = data else {
                               retTranslations[key] = "No data found"
                                  print("No data")
                               if(counter == transCount){
                                 completion(retTranslations)
                              }else{
                         counter = counter + 1
                      }
                return
            }
     
            // 4. DECODE THE RESULTING JSON
           do {
               let root = try JSONDecoder().decode(Root.self, from: jsonData)
                      //      print(root)
                            let outputs = root.outputs
                            for outputVar in outputs {
                                let outVar = outputVar.output
                                for match in outVar.matches {
                                       for target in match.targets {
                                       //for lemma in target.lemma {
                                        //print(target.lemma)
                                          retTranslations[key]?.append("\(target.lemma) ")
                                         //print("DECODE")
                                      }                  //break
                                  }                   //break
                            }
                    if (retTranslations[key]!.isEmpty){
                        retTranslations[key]?.append("No synonyms found")
                    }
                    if(counter == transCount){
                         print("Last round of for loop in setTranslations")
                         completion(retTranslations)
                      
                     }else{
                         counter = counter + 1
                     }
                }
                catch {
                    retTranslations[key]="Translation not found."
                    if(counter == transCount){
                         completion(retTranslations)
                      //print(translations[key])
                     }else{
                         counter = counter + 1
                     }
                }
            }
            dataTask.resume()
               // print("hello1111111")
            }//for loop
            //print("return")
            return
    }
    
    func beginSave(inputStructArray: [newWord], completion: @escaping (_ doneString: String?) -> ()) {
       // let newWordStruct = inputStructArray[0]
        let structCount = inputStructArray.count - 1
        var counterStruct = 0

        for newWordStruct in inputStructArray{
            if oldNames.contains(newWordStruct.name){
                print("recognized:\(newWordStruct.name)")
                if (structCount == counterStruct){
                    completion("Saved")
                }else{
                    counterStruct = counterStruct + 1
                    continue
                }
            } else {
                oldNames.insert(newWordStruct.name)
                getAllData(inputText: newWordStruct.name) { (transDict) in
                    guard let newTrans = transDict else {
                        return
                    }
                    print("Translations:\(newTrans)")
                 //   var newStruct = newWord(name1: newWordStruct.name, definition1: newWordStruct.definition)
                //    newWordStruct.spanish = newTrans["es"]
                    let wordDataPoint2 = SavedWord(context: container.viewContext)
                    let newStruct = newWord(name1: newWordStruct.name, definition1: newWordStruct.definition, syn1: self.synList[newWordStruct.name]!, sp1: newTrans["es"]!, hi1: newTrans["hi"]!, ar1: newTrans["ar"]!, ma1: newTrans["zh-Hans"]!, be1: newTrans["bn"]!, pt1: newTrans["pt"]!)
                    wordDataPoint2.name = newStruct.name
                    wordDataPoint2.definition = newStruct.definition
                    wordDataPoint2.synonyms = newStruct.synonyms
                    wordDataPoint2.spanish = newStruct.spanish
                    wordDataPoint2.arabic = newStruct.arabic
                    wordDataPoint2.hindi = newStruct.hindi
                    wordDataPoint2.portuguese = newStruct.portuguese
                    wordDataPoint2.bengali = newStruct.bengali
                    wordDataPoint2.mandarin = newStruct.mandarin
                    if (structCount == counterStruct){
                        completion("Saved")
                    }else{
                        counterStruct = counterStruct + 1
                    }
                }

            }

        }
        
    }
    
    func saveContext() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                print("An error occurred while saving: \(error)")
            }
        }
    }
}

extension ProcessedTextTwoViewController : UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate {
  
 
    //1
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
    let availableWidth = view.frame.width - paddingSpace
    let widthPerItem = availableWidth / itemsPerRow
    if indexPath.section == 0{
        return CGSize(width: widthPerItem, height: cellHeightText)
    }
    return CGSize(width: widthPerItem, height: cellHeightWords)
  }
  
  //3
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
    return sectionInsets
  }
  
  // 4
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return inBetweenSpacing
  }
}

