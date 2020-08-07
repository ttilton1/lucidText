//
//  HomeViewController.swift
//  LucidText
//
//  Created by Thomas Tilton on 4/12/20.
//  Copyright © 2020 Thomas Tilton. All rights reserved.
//

import UIKit
import CoreData

 //<-separate one for each class
var newWords = [newWord]() //<-put this avove as well
//var oldWords = [SavedWord]() //<-put this above homeviewcontroller class
var oldNames = Set<String>()
var newHardWordsCheck = Set<String>() //will do intersection with oldNames

class HomeViewController: UIViewController, UITextViewDelegate {
   private let concurrentPhotoQueue =
   DispatchQueue(
     label: "com.raywenderlich.GooglyPuff.photoQueue",
     attributes: .concurrent)
    //var container: NSPersistentContainer!
    //Colors
    let selectedSegmentTintColor: UIColor = UIColor(named: "appTan") ?? .systemYellow
    let segmentBackgroundTintColor: UIColor = UIColor(named: "appDarkBlue") ?? .black
    
    //Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var processButton: UIButton!
    @IBOutlet weak var sliderThing: UISegmentedControl!
    
    var synonymDict = [String:String]()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewDidLoad()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //***Done Button***
        self.addDoneButtonOnKeyboard()
        //**don
        synonymDict.removeAll()
        container = NSPersistentContainer(name: "LucidText")
        container.loadPersistentStores { storeDescription, error in
            container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            if let error = error {
                print("Unresolved error \(error)")
            }
        }
        loadSavedData()

        
        let image:UIImage = UIImage(named: "lucidHeader")!
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        self.navigationItem.titleView = imageView
        //self.navigationItem.title = "Lucid Text"
        self.tabBarItem.title = "Enter Text"
        view.backgroundColor = backgroundColor
         titleLabel.text = "Welcome to Lucid Text"
         titleLabel.numberOfLines = 0
         titleLabel.lineBreakMode = .byTruncatingTail
         titleLabel.minimumScaleFactor = 0.5
        titleLabel.sizeToFit()
        titleLabel.font = .systemFont(ofSize: 25, weight: .semibold)
        titleLabel.textAlignment = .center
         titleLabel.textColor = cellTextColor
        //TextLabel
         textLabel.text = "Paste your text below. Words that go past the box's capacity will still be processed."
         textLabel.numberOfLines = 0
         textLabel.lineBreakMode = .byTruncatingTail
         textLabel.minimumScaleFactor = 0.5
         textLabel.sizeToFit()
        textLabel.font = .systemFont(ofSize: 16, weight: .regular)
        textLabel.textAlignment = .center
         textLabel.textColor = cellTextColor
        // levelLabel.text = "Welcome to Lucid Text"
         levelLabel.text = "Select your learning level:"
         levelLabel.numberOfLines = 0
         levelLabel.lineBreakMode = .byTruncatingTail
         levelLabel.minimumScaleFactor = 0.5
         levelLabel.sizeToFit()
        titleLabel.textAlignment = .center
         levelLabel.textColor = cellTextColor
        //textview
        textView.sizeToFit()
        //cell.textView.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        textView.textColor = cellTextColor
        textView.layer.cornerRadius = cornerRadiusVar
        textView.layer.borderWidth = cellBorderWidth
        textView.layer.borderColor = cellBorderColor
        //Segment Adjust
        sliderThing.removeAllSegments()
        sliderThing.insertSegment(withTitle: "Beginner", at: 0, animated: true)
        sliderThing.insertSegment(withTitle: "Intermediate", at: 1, animated: true)
        sliderThing.insertSegment(withTitle: "Advanced", at: 2, animated: true)
        sliderThing.selectedSegmentTintColor = selectedSegmentTintColor
        sliderThing.tintColor = segmentBackgroundTintColor
       
        
        ColorFrames.styleFilledButton(processButton)
        processButton.setTitle("Process Text", for: .normal)
        processButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        
        // Do any additional setup after loading the view.
    }
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = UIBarStyle.default
        doneToolbar.isTranslucent = true

        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))

        let items = NSMutableArray()
        items.add(flexSpace)
        items.add(done)

        doneToolbar.items = items as? [UIBarButtonItem]
        doneToolbar.sizeToFit()

        self.textView.inputAccessoryView = doneToolbar
      //  self.textField.inputAccessoryView = doneToolbar
    }
    @objc func doneButtonAction()
    {
        self.textView.resignFirstResponder()
    }
     //textfield delegate
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        self.textView.endEditing(true)
    }
    /*
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         self.view.endEditing(true)
         return false
     }
    */
    func loadSavedData() {
        oldWords.removeAll()
        let request = SavedWord.createFetchRequest()
        print(request)
        let sort = NSSortDescriptor(key: "name", ascending: false)
        request.sortDescriptors = [sort]
        
        do {
            
            oldWords = try container.viewContext.fetch(request)
            print("Updated OldWords: \(oldWords)")
            getNames(wordsFromData: oldWords)
            
        } catch {
            print("Fetch failed")
        }
    }
    
    func getNames(wordsFromData: [SavedWord]) {
       oldNames.removeAll()
        if (wordsFromData.count == 0){
            return
        } else {
            for word in wordsFromData {
             oldNames.insert(word.name!)
             print("In Library:\(word.name!)")
            }
        }
    }


    //completion: @escaping (_ difficulWords: Set<String>?) -> ())
    func getWordDifficulty(word: String, completion: @escaping (_ matchScore: Int?) -> ()) {
        
        //PhraseFinder API Data Structure
        struct head_data: Codable {
            var phrases: [tks]
        }
        struct tks: Codable {
            var mc:Int
        }
        
        //Being Networking Code
        let mySession = URLSession(configuration: URLSessionConfiguration.default)
           
        //construt api call
        var apiCallURL : String
        apiCallURL = "https://api.phrasefinder.io/search?corpus=eng-us&query=" + word + "&topk=1"
      
        let url = URL(string: apiCallURL)!
        
        //HTTP REQUEST
        let task = mySession.dataTask(with: url) { data, response, error in
               // ensure there is no error for this HTTP response
               guard error == nil else {
                DispatchQueue.main.async {
                     self.removeSpinner()
                     let alert = UIAlertController(title: "Data Retrieval Failed", message: "Please Check your Internet Connection", preferredStyle: .alert)
                                       alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true)
                    print ("error: \(error!)")
                    return
                }
                return
               }

               // ensure there is data returned from this HTTP response
               guard let jsonData = data else {
                DispatchQueue.main.async {
                    self.removeSpinner()
                     let alert = UIAlertController(title: "Data Retrieval Failed", message: "Please Check your Internet Connection", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true)
                     print ("error: \(error!)")
                     print("No data")
                }
 
                   return
               }
            
                print("Got the data from network")
    // DECODE THE RESULTING JSON
                let decoder = JSONDecoder()
                
                do {
                    var stupid = 0
                    let allTasks = try decoder.decode(head_data.self, from: jsonData)
                    if (allTasks.phrases.count < 1){
                        stupid = -1
                    }else{
                        stupid = allTasks.phrases[0].mc
                    }
                    let matchScore = stupid
                    print("I'm Done !")
                   // DispatchQueue.main.async {
                        completion(matchScore)
                   // }
                    
                  
                    //completion(matchScore)

                } catch {
                    print("JSON Decode error")
                }
            
                //reload
       }
        task.resume()
    }
     func analyzeWords(text: String, thresh: Int, completion: @escaping (_ difficulWords: Set<String>?) -> ()) {
      //  concurrentPhotoQueue.async(flags: .barrier) { [weak self] in
        
     //   let q = DispatchQueue(label: "com.theswiftdev.queues.serial")
     //   q.sync {
        var textVar = text
        //let vowels: Set<Character> = ["ʔ", "~", "`", "$", "#"]
        let letters: Set<Character> = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t","u", "v", "w", "x", "y", "z", " ", "\'", "-", "'", "`", "[", "]", "@", "~", "#", "$", "%", "^", "&", "*", "_", "+", ".", ",", ":", "!", "?", ";", "/", ")", "(", "{", "{", "<",
        ">"]

        textVar.removeAll(where: { !(letters.contains($0)) })
        //print(textVar)
        let separators = CharacterSet(charactersIn: " ~`@#$%^&*_+=.,:!?;/[]-)({}<>\n")
       // let chars = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz")
       // text.removeAll(where: chars.contains($0) })
     //   var phrase = "The rain in Spain stays mainly in the plain."
  
        //let newText = text.addingPercentEncoding(withAllowedCharacters: chars)
       // print("New Text:\(newText)")
       // let perc = CharacterSet(charactersIn: "~`@#$%^&*_+=1234567890|")
       //ʔ
        //let newNewText =
        //trimmingCharacters(in: perc)
       // print("NewNewText:\(newNewText)")
         var parts = textVar.components(separatedBy: separators)
        
         parts = parts.filter({ $0 != ""})
       // print(parts)
         var partSet = Set(parts)
         partSet.subtract(commonWords)
         print(partSet)
         //Arjun parse through deleting words with apostrophes
        if (partSet.isEmpty){
            completion(partSet)
        }
        let partSetLength = partSet.count-1
        var counter = 0
        for phrase in partSet {
         //   group.enter()
            // print(phrase)
            /*
             phrase.contains("’") ||
             phrase.contains("0") ||
             phrase.contains("\\") ||
             phrase.contains("\n") ||
             phrase.contains("\r") ||
             phrase.contains("\t") ||
             phrase.contains("\0") ||
             phrase.contains("^") ||
             phrase.contains("\'") ||
             phrase.contains("\\/") ||
             phrase.contains("\"")
             */
            if(phrase.count <= 1)
                {
                 print("Detected")
                 partSet.remove(phrase)
                 if (counter == partSetLength){
                     completion(partSet)
                 } else {
                     counter = counter + 1
                     continue
                 }
                
             }
   
            self.getWordDifficulty(word: phrase) {  matchScore in
              guard let freq = matchScore else {
                 print("uh ohhhhh")
                  return
              }
                 print("88888888888")
                 print("freq:\(freq)")
                 print("Thresh:\(thresh)")
                 print("88888888888")
             
                 //if freq <= thresh, then it is in the desired range, else remove it
                if (freq == -1){
                    partSet.remove(phrase)
                }
             if (freq > thresh){
                 print("i'm here")
                 partSet.remove(phrase)
                 print("print:\(partSet)")
             }

                if (counter == partSetLength){
                    completion(partSet)
                } else {
                    counter = counter + 1
                }
            }
        }
        
    }
    func setSynonyms(words: Set<String>, completion: @escaping (_ newSyns: [String: String]?) -> ())
    {
        var cinnList = [String: String]()
       let wordsCount = words.count - 1
       var counter = 0
       for part in words {
            cinnList[part] = ""
           //print(part)
           getSynonyms(word: part) { (synArray) in
               guard let ret = synArray else {
                   return
               }
                print("synonyms retrieved")
             //  print("definition:\(ret[0])")
               if (ret[0] == "error"){
                    cinnList[part] = "error"
                   if(counter == wordsCount){
                       
                       completion(cinnList)
                   }else{
                       counter = counter + 1
                   }
               } else {
                var synString:String = ""
                var synCounter = 0
                for syn in ret {
                    if synCounter == 0 {
                        synString = synString + " " + "\(syn)"
                        synCounter = synCounter + 1
                    } else {
                        synString = synString + ", " + "\(syn)"
                    }
                    
                }
                cinnList[part] = synString
                //newWords.append(newWord(name1: part, definition1: ret[0], synonym1: synString))
                       //ret[0]))
                //   print(counter)
                //   print(wordsCount)
                   if(counter == wordsCount){
                       completion(cinnList)
                   }else{
                       counter = counter + 1
                   }
               }
           }
       }
    }
         func setDefinitions(words: Set<String>, completion: @escaping (_ difficulWords: [newWord]?) -> ())
         {
            let wordsCount = words.count - 1
            var counter = 0
            for part in words {
                //print(part)
                getWord(word: part) { (definitions) in
                    guard let ret = definitions else {
                        return
                    }
                     print("definition retrieved")
                  //  print("definition:\(ret[0])")
                    if (ret[0] == "error"){
                        if(counter == wordsCount){
                            print("complete in setDef")
                            completion(newWords)
                        }else{
                            counter = counter + 1
                        }
                    } else {
                        var def = ""
                        var counter1 = 1
                        for sentence in definitions! {
                            def = def + " \(counter1). \(sentence)\n"
                            counter1 = counter1 + 1
                        }
                     //   newWords.append(newWord(name1: part, definition1: ret[0]))
                        newWords.append(newWord(name1: part, definition1: def))
                            //ret[0]))
                        print(counter)
                        print(wordsCount)
                        if(counter == wordsCount){
                            completion(newWords)
                        }else{
                            counter = counter + 1
                        }
                    }
                }
            }
         }
     
    @IBAction func processTouched(_ sender: Any) {
        //on "process text button", do api call,
        self.showSpinner(onView: self.view)
        print("To new ProcessedTwoVC")
        newWords.removeAll()
        let inputString = textView.text.lowercased()
       // let threshold = 47000; //whatever we decide for threshold of difficulty
        if (textView.text.count == 0) {
            self.removeSpinner()
              let alert = UIAlertController(title: "Incomplete Form", message: "Please enter text", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
             self.present(alert, animated: true)
            // print ("error: \(error!)")
             return
        }
        if(sliderThing.selectedSegmentIndex == -1){
            self.removeSpinner()
             let alert = UIAlertController(title: "Incomplete Form", message: "Please select a learning level", preferredStyle: .alert)
                               alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
           // print ("error: \(error!)")
            return
        }
        var threshold = 9999999999
        if (sliderThing.selectedSegmentIndex == 0){
            threshold = 100000000
        } else if (sliderThing.selectedSegmentIndex == 1){
            threshold = 5000000
        } else {
            threshold =  1000000
        }
        print(sliderThing.selectedSegmentIndex)
        
        self.analyzeWords(text: inputString, thresh: threshold) { partSet in
            guard let bamboo = partSet else
            {
                self.removeSpinner()
                return
                    
            }
            
            print("Hellooooo:\(bamboo)")
            if (bamboo.count > 60){
                self.removeSpinner()
                DispatchQueue.main.async {
                      let alert = UIAlertController(title: "Too Many Challenging Words Found", message: "Try and change your difficult level to show challenging words.", preferredStyle: .alert)
                                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                     self.present(alert, animated: true)
                    // print ("error: \(error!)")
                     
                }
                return
            }
            if(bamboo.isEmpty){
                self.removeSpinner()
                DispatchQueue.main.async {
                      let alert = UIAlertController(title: "No Challenging Words Found", message: "Try and change your difficult level to show challenging words.", preferredStyle: .alert)
                                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                     self.present(alert, animated: true)
                    // print ("error: \(error!)")
                     
                }
                return
                /*
                DispatchQueue.main.async {
                    newWords.removeAll()
                        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "processTwoVC") as? ProcessedTextTwoViewController {
                        vc.incomingWordStructs = newWords
                            vc.incomingText = self.textView.text
                            vc.titleLabel = "No Challenging Words Found"
                            print(vc.incomingWordStructs)
                        //maybe should put rootviewcontroller assignment here.
                        self.navigationController?.pushViewController(vc, animated: true)
                        print("NAVVIGGATTTTEEEDDD")
                    }
                }
                */
               // return
            } else {
                self.setDefinitions(words: bamboo) { (structNewWords) in
                    guard let newStruct = structNewWords else {
                        self.removeSpinner()
                        return
                    }
                   // for element in newStruct {
                  //      print("element:\(element)")
                  //  }
                    self.setSynonyms(words: bamboo) { (newSyn) in
                        guard let synonymList = newSyn else{
                            self.removeSpinner()
                            return
                        }
                        print("SynonymLISSSTTTT:\(synonymList)")
                        DispatchQueue.main.async {
                                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "processTwoVC") as? ProcessedTextTwoViewController {
                                vc.incomingWordStructs = newStruct
                                    vc.incomingText = self.textView.text
                                    vc.synList = synonymList
                                    let font = UIFont.systemFont(ofSize: 18)
                                    let attributes = [NSAttributedString.Key.font: font]
                              
                                 //   vc.attributedQuote = attributedQuote
                                  //  for word in bamboo{
                                  //      attributedQuote.ad
                                   // }
                                    print(vc.incomingWordStructs)
                                //maybe should put rootviewcontroller assignment here.
                                self.navigationController?.pushViewController(vc, animated: true)
                                print("NAVVIGGATTTTEEEDDD")
                            }
                        } //END DISPATCH
                        self.removeSpinner()
                    }
                    /*
                    DispatchQueue.main.async {
                            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "processTwoVC") as? ProcessedTextTwoViewController {
                            vc.incomingWordStructs = newStruct
                                vc.incomingText = self.textView.text
                                print(vc.incomingWordStructs)
                            //maybe should put rootviewcontroller assignment here.
                            self.navigationController?.pushViewController(vc, animated: true)
                            print("NAVVIGGATTTTEEEDDD")
                        }
                    } //END DISPATCH
*/
                    
                }
            }

        }
    }
    
    /*
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
    */
       
    
    func getSynonyms(word: String, completion: @escaping (_ syns: Array<String>?) -> ()) {

        struct Root: Codable {
            let metadata: Metadata
                     let results: [Result]
        }
        struct Metadata: Codable {
            let provider: String
        }
        struct Result: Codable {
            let id: String
            let language: String
            let lexicalEntries: [Lexical]
        }
        struct Lexical: Codable {
            let entries: [Entry]
        }
        struct Entry: Codable {
                     
            let senses: [Sense]
        }
        
        struct Sense: Codable {
            let id: String
            //let subsenses: [Subsense]
            let synonyms: [Synonym]
        }
        struct Subsense: Codable {
            let id: String
            
        }
        struct Synonym: Codable {
            let language: String
            let text: String
        }
       
        
        var syns = [String]()
        let appId = "f1456cb7"
        let appKey = "b8c41db8d7143034e5206df098338589"
        let language = "en"
        
        let fields = "synonyms"
        let strictMatch = "false"
        let word_id = word.lowercased()
        let url = URL(string: "https://od-api.oxforddictionaries.com:443/api/v2/thesaurus/\(language)/\(word_id)?fields=\(fields)&strictMatch=\(strictMatch)")!
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(appId, forHTTPHeaderField: "app_id")
        request.addValue(appKey, forHTTPHeaderField: "app_key")

        let session = URLSession.shared
        _ = session.dataTask(with: request, completionHandler: { data, response, error in
            guard let data = data else { return }
                    do {
                        let root = try JSONDecoder().decode(Root.self, from: data)
                        let results = root.results
                        for result in results {
                            for lexical in result.lexicalEntries {
                                for entry in lexical.entries {
                                    for sense in entry.senses {
                                            for synonym in sense.synonyms{
                                                syns.append(synonym.text)
                                            }
                                           //break
                                     //break
                                    }
                                 //break
                                }
                             //break
                            }
                         //break
                        }
                        if(syns.isEmpty){
                            syns.append("no synonyms found")
                        }
                        print(syns)
                       completion(syns)
                    } catch {
                        syns.append("no synonyms found")
                        print(error)
                        completion(syns)
                    }
            }).resume()
    }
    
    func getWord(word: String, completion: @escaping (_ defintions: Array<String>?) -> ()) {
          
          struct Root: Codable {
              let metadata: Metadata
              let results: [Result]
          }
          struct Metadata: Codable {
              let provider: String
          }
          struct Result: Codable {
              let id: String
              let language: String
              let lexicalEntries: [Lexical]
          }
          struct Lexical: Codable {
              let entries: [Entry]
          }
          struct Entry: Codable {
              
              let senses: [Sense]
          }
          struct Feature: Codable {
              let text: String
              let type: String
          }
          struct Sense: Codable {
              let definitions: [String]
              
          }
          struct Example: Codable {
              let registers: [String]?
              let text: String
          }
          
      var definitions = [String]()
      let appId = "f1456cb7"
        //"83f3f95a"
      let appKey = "b8c41db8d7143034e5206df098338589"
        //"3565a919a4f7174a7027863035e56b3d"
      let language = "en-us"
      //let word = "smart"
      let fields = "definitions"
      let strictMatch = "false"
      let word_id = word.lowercased()
      let url = URL(string: "https://od-api.oxforddictionaries.com:443/api/v2/entries/\(language)/\(word_id)?fields=\(fields)&strictMatch=\(strictMatch)&lexicalCategory=noun,verb,adjective")!
      var request = URLRequest(url: url)
      request.addValue("application/json", forHTTPHeaderField: "Accept")
      request.addValue(appId, forHTTPHeaderField: "app_id")
      request.addValue(appKey, forHTTPHeaderField: "app_key")
      print("Made it")
      let session = URLSession.shared
      let task = session.dataTask(with: request, completionHandler: { data, response, error in
           guard let data = data else { return }
               do {
                   let root = try JSONDecoder().decode(Root.self, from: data)
                   let results = root.results
                   for result in results {
                       for lexical in result.lexicalEntries {
                           for entry in lexical.entries {
                               for sense in entry.senses {
                                   for definition in sense.definitions {
                                      definitions.append(definition)
                                      //completion(definitions)
                                     // break
                                   }
                                //break
                               }
                            //break
                           }
                        //break
                       }
                   // break
                   }
                print(definitions)
                  completion(definitions)
                  
               } catch {
                definitions.append("error")
                print(error)
                completion(definitions)
               }
       })
      task.resume()
      }
    
    

    

}

let commonWords: Set = ["are", "is", "a", "ability", "able", "about", "above", "accept", "according", "account", "across", "act", "action", "activity", "actually", "add", "address", "administration", "admit", "adult", "affect", "after", "again", "against", "age", "agency", "agent", "ago", "agree", "agreement", "ahead", "air", "all", "allow", "almost", "alone", "along", "already", "also", "although", "always", "american", "among", "amount", "analysis", "and", "animal", "another", "answer", "any", "anyone", "anything", "appear", "apply", "approach", "area", "argue", "arm", "around", "arrive", "art", "article", "artist", "as", "ask", "assume", "at", "attack", "attention", "attorney", "audience", "author", "authority", "available", "avoid", "away", "baby", "back", "bad", "bag", "ball", "bank", "bar", "base", "be", "beat", "beautiful", "because", "become", "bed", "before", "begin", "behavior", "behind", "believe", "benefit", "best", "better", "between", "beyond", "big", "bill", "billion", "bit", "black", "blood", "blue", "board", "body", "book", "born", "both", "box", "boy", "break", "bring", "brother", "budget", "build", "building", "business", "but", "buy", "by", "call", "camera", "campaign", "can", "cancer", "candidate", "capital", "car", "card", "care", "career", "carry", "case", "catch", "cause", "cell", "center", "central", "century", "certain", "certainly", "chair", "challenge", "chance", "change", "character", "charge", "check", "child", "choice", "choose", "church", "citizen", "city", "civil", "claim", "class", "clear", "clearly", "close", "coach", "cold", "collection", "college", "color", "come", "commercial", "common", "community", "company", "compare", "computer", "concern", "condition", "conference", "congress", "consider", "consumer", "contain", "continue", "control", "cost", "could", "country", "couple", "course", "court", "cover", "create", "crime", "cultural", "culture", "cup", "current", "customer", "cut", "dark", "data", "daughter", "day", "dead", "deal", "death", "debate", "decade", "decide", "decision", "deep", "defense", "degree", "democrat", "democratic", "describe", "design", "despite", "detail", "determine", "develop", "development", "die", "difference", "different", "difficult", "dinner", "direction", "director", "discover", "discuss", "discussion", "disease", "do", "doctor", "dog", "door", "down", "draw", "dream", "drive", "drop", "drug", "during", "each", "early", "east", "easy", "eat", "economic", "economy", "edge", "education", "effect", "effort", "eight", "either", "election", "else", "employee", "end", "energy", "enjoy", "enough", "enter", "entire", "environment", "environmental", "especially", "establish", "even", "evening", "event", "ever", "every", "everybody", "everyone", "everything", "evidence", "exactly", "example", "executive", "exist", "expect", "experience", "expert", "explain", "eye", "face", "fact", "factor", "fail", "fall", "family", "far", "fast", "father", "fear", "federal", "feel", "feeling", "few", "field", "fight", "figure", "fill", "film", "final", "finally", "financial", "find", "fine", "finger", "finish", "fire", "firm", "first", "fish", "five", "floor", "fly", "focus", "follow", "food", "foot", "for", "force", "foreign", "forget", "form", "former", "forward", "four", "free", "friend", "from", "front", "full", "fund", "future", "game", "garden", "gas", "general", "generation", "get", "girl", "give", "glass", "go", "goal", "good", "government", "great", "green", "ground", "group", "grow", "growth", "guess", "gun", "guy", "hair", "half", "hand", "hang", "happen", "happy", "hard", "have", "he", "head", "health", "hear", "heart", "heat", "heavy", "help", "her", "here", "herself", "high", "him", "himself", "his", "history", "hit", "hold", "home", "hope", "hospital", "hot", "hotel", "hour", "house", "how", "however", "huge", "human", "hundred", "husband", "i", "idea", "identify", "if", "image", "imagine", "impact", "important", "improve", "in", "include", "including", "increase", "indeed", "indicate", "individual", "industry", "information", "inside", "instead", "institution", "interest", "interesting", "international", "interview", "into", "investment", "involve", "issue", "it", "item", "its", "itself", "job", "join", "just", "keep", "key", "kid", "kill", "kind", "kitchen", "know", "knowledge", "land", "language", "large", "last", "late", "later", "laugh", "law", "lawyer", "lay", "lead", "leader", "learn", "least", "leave", "left", "leg", "legal", "less", "let", "letter", "level", "lie", "life", "light", "like", "likely", "line", "list", "listen", "little", "live", "local", "long", "look", "lose", "loss", "lot", "love", "low", "machine", "magazine", "main", "maintain", "major", "majority", "make", "man", "manage", "management", "manager", "many", "market", "marriage", "material", "matter", "may", "maybe", "me", "mean", "measure", "media", "medical", "meet", "meeting", "member", "memory", "mention", "message", "method", "middle", "might", "military", "million", "mind", "minute", "miss", "mission", "model", "modern", "moment", "money", "month", "more", "morning", "most", "mother", "mouth", "move", "movement", "movie", "mr", "mrs", "much", "music", "must", "my", "myself", "name", "nation", "national", "natural", "nature", "near", "nearly", "necessary", "need", "network", "never", "new", "news", "newspaper", "next", "nice", "night", "no", "none", "nor", "north", "not", "note", "nothing", "notice", "now", "n't", "number", "occur", "of", "off", "offer", "office", "officer", "official", "often", "oh", "oil", "ok", "old", "on", "once", "one", "only", "onto", "open", "operation", "opportunity", "option", "or", "order", "organization", "other", "others", "our", "out", "outside", "over", "own", "owner", "page", "pain", "painting", "paper", "parent", "part", "participant", "particular", "particularly", "partner", "party", "pass", "past", "patient", "pattern", "pay", "peace", "people", "per", "perform", "performance", "perhaps", "period", "person", "personal", "phone", "physical", "pick", "picture", "piece", "place", "plan", "plant", "play", "player", "pm", "point", "police", "policy", "political", "politics", "poor", "popular", "population", "position", "positive", "possible", "power", "practice", "prepare", "present", "president", "pressure", "pretty", "prevent", "price", "private", "probably", "problem", "process", "produce", "product", "production", "professional", "professor", "program", "project", "property", "protect", "prove", "provide", "public", "pull", "purpose", "push", "put", "quality", "question", "quickly", "quite", "race", "radio", "raise", "range", "rate", "rather", "reach", "read", "ready", "real", "reality", "realize", "really", "reason", "receive", "recent", "recently", "recognize", "record", "red", "reduce", "reflect", "region", "relate", "relationship", "religious", "remain", "remember", "remove", "report", "represent", "republican", "require", "research", "resource", "respond", "response", "responsibility", "rest", "result", "return", "reveal", "rich", "right", "rise", "risk", "road", "rock", "role", "room", "rule", "run", "safe", "same", "save", "say", "scene", "school", "science", "scientist", "score", "sea", "season", "seat", "second", "section", "security", "see", "seek", "seem", "sell", "send", "senior", "sense", "series", "serious", "serve", "service", "set", "seven", "several", "sex", "sexual", "shake", "share", "she", "shoot", "short", "shot", "should", "shoulder", "show", "side", "sign", "significant", "similar", "simple", "simply", "since", "sing", "single", "sister", "sit", "site", "situation", "six", "size", "skill", "skin", "small", "smile", "so", "social", "society", "soldier", "some", "somebody", "someone", "something", "sometimes", "son", "song", "soon", "sort", "sound", "source", "south", "southern", "space", "speak", "special", "specific", "speech", "spend", "sport", "spring", "staff", "stage", "stand", "standard", "star", "start", "state", "statement", "station", "stay", "step", "still", "stock", "stop", "store", "story", "strategy", "street", "strong", "structure", "student", "study", "stuff", "style", "subject", "success", "successful", "such", "suddenly", "suffer", "suggest", "summer", "support", "sure", "surface", "system", "table", "take", "talk", "task", "tax", "teach", "teacher", "team", "technology", "television", "tell", "ten", "tend", "term", "test", "than", "thank", "that", "the", "their", "them", "themselves", "then", "theory", "there", "these", "they", "thing", "think", "third", "this", "those", "though", "thought", "thousand", "threat", "three", "through", "throughout", "throw", "thus", "time", "to", "today", "together", "tonight", "too", "top", "total", "tough", "toward", "town", "trade", "traditional", "training", "travel", "treat", "treatment", "tree", "trial", "trip", "trouble", "true", "truth", "try", "turn", "tv", "two", "type", "under", "understand", "unit", "until", "up", "upon", "us", "use", "usually", "value", "various", "very", "victim", "view", "violence", "visit", "voice", "vote", "wait", "walk", "wall", "want", "war", "watch", "water", "way", "we", "weapon", "wear", "week", "weight", "well", "west", "western", "what", "whatever", "when", "where", "whether", "which", "while", "white", "who", "whole", "whom", "whose", "why", "wide", "wife", "will", "win", "wind", "window", "wish", "with", "within", "without", "woman", "wonder", "word", "work", "worker", "world", "worry", "would", "write", "writer", "wrong", "yard", "yeah", "year", "yes", "yet", "you", "young", "your", "yourself"]

