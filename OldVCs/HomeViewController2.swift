//
//  HomeViewController.swift
//  LucidText
//
//  Created by Thomas Tilton on 4/12/20.
//  Copyright © 2020 Thomas Tilton. All rights reserved.
//
/*
import UIKit
import CoreData

 //<-separate one for each class
var newWords = [newWord]() //<-put this avove as well
var oldWords = [SavedWord]() //<-put this above homeviewcontroller class
var oldNames = Set<String>()
var newHardWordsCheck = Set<String>() //will do intersection with oldNames

class HomeViewController: UIViewController {
   private let concurrentPhotoQueue =
   DispatchQueue(
     label: "com.raywenderlich.GooglyPuff.photoQueue",
     attributes: .concurrent)
    var container: NSPersistentContainer!
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       //newHardWordsCheck = ["Banana"]
        //********CoreData********
        container = NSPersistentContainer(name: "LucidText")
        
        container.loadPersistentStores { storeDescription, error in
            self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            if let error = error {
                print("Unresolved error \(error)")
            }
        }
        loadSavedData()
        //***********************
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
    
    func loadSavedData() {
        let request = SavedWord.createFetchRequest()
        let sort = NSSortDescriptor(key: "name", ascending: false)
        request.sortDescriptors = [sort]
        do {
            oldWords = try container.viewContext.fetch(request)
            //tableView.reloadData()
            getNames(wordsFromData: oldWords)
        } catch {
            print("Fetch failed")
        }
    }
    func getNames(wordsFromData: [SavedWord]) {
       oldNames.removeAll()
       for word in wordsFromData {
        oldNames.insert(word.name!)
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
                   let alert = UIAlertController(title: "No Internet Connection", message: "Please Try Again", preferredStyle: .alert)
                   self.present(alert, animated: true)
                   print ("error: \(error!)")
                   return
               }

               // ensure there is data returned from this HTTP response
               guard let jsonData = data else {
                   let alert = UIAlertController(title: "No Internet Connection", message: "Please Try Again", preferredStyle: .alert)
                   self.present(alert, animated: true)
                   print ("error: \(error!)")
                   print("No data")
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
        let separators = CharacterSet(charactersIn: " .,:!?;/[]-)(\n")
         var parts = text.components(separatedBy: separators)
         parts = parts.filter({ $0 != ""})
         var partSet = Set(parts)
         partSet.subtract(commonWords)
         //Arjun parse through deleting words with apostrophes
 
    
        for phrase in partSet {
         //   group.enter()
            // print(phrase)
             if(phrase.contains("’")){
                 print("Detected")
                 partSet.remove(phrase)
                 continue
                 
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
             if (freq > thresh){
                 print("i'm here")
                 partSet.remove(phrase)
                 print("print:\(partSet)")
             }
            }
             
            }
        
        completion(partSet)
      
      //  }
        
        print("hi")
      //  }
        
         //   print("hi")
         //   completion(partSet)
        

        
          //  DispatchQueue.main.async {
       // print("hi")
      //  completion(partSet)
           // }

        
      //  DispatchQueue.main.async {
     //       completion(partSet)
     //   }
          
        // completion(partSet)
        // newHardWordsCheck = partSet
     }
    @IBAction func processTouched(_ sender: Any) {
        //on "process text button", do api call,
        print("To new ProcessedTwoVC")
        let inputString = textView.text.lowercased()
        
        let threshold = 46000; //whatever we decide for threshold of difficulty
        /*
         getWordDifficulty(word: phrase) {  matchScore in
         guard let freq = matchScore else {
             return
         }
         DispatchQueue.main.async {
                         switch result {
                         case let .success(data):
                             print(data)
                         case let .failure(error):
                             print(error)
                         }
                     }
         */
       // let group = DispatchGroup()
       // group.enter()
   //     DispatchQueue.main.async {
          //  self.analyzeWords(text: inputString, thresh: threshold)
    
    
        self.analyzeWords(text: inputString, thresh: threshold) { partSet in
            guard let bamboo = partSet else
            {
                return
            //let newHardWordsCheck = ["Messed Up"]
            }
            print("Hello:\(bamboo)")
           // DispatchQueue.main.async {
                newHardWordsCheck = bamboo
                print("HopeThisDoesSomething:\(newHardWordsCheck)")
           // }
        //    group.leave()
            }
    // concurrentPhotoQueue.sync {
        print("End:\(newHardWordsCheck)")
            // }
        
            
         //   print("HopeThisDoesSomething:\(newHardWordsCheck)")
        

       
            /*
            DispatchQueue.main.async {
                print("Hello Arjun youre cute")
                print("**************")
                print("result array:\(newHardWordsCheck)")
            }
 */
      //  }
   //     group.notify(queue: .main) {
  //          print("ArjunHeySexy:\(newHardWordsCheck)")
  //      }
        //print(newHardWordsCheck)
        //Func
        /**********DO API CALL ON on words inside "inputString", the resulting String set of hardwords should be assign to newHardWordsCheck */
        //after getting newHardWordsCheck do:
      //newHardWordsCheck.subtract(oldNames) //subtract savedwords that already exist
        //next create structs with just definitions
        newWords.removeAll()
       // newHardWordsCheck = ["hobby"]
        /*INSTER API CALL TO GET DEFINITIONS*/
        /*
        for word in newHardWordsCheck{
            getWord(word: word) { definitions in
                guard let ret = definitions else{
                    return
                }
                print(ret[0])
                newWords.append(newWord(name: word, defintion: ret[0]))
                print(newWords.count)
            }
            //newWords.append(newWord(name: word, defintion: "PUT DEF VARIABLE IN"))
        }
        */
        //print(newWords.count)
        /*
 */
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
      let appId = "83f3f95a"
      let appKey = "3565a919a4f7174a7027863035e56b3d"
      let language = "en-gb"
      let word = "smart"
      let fields = "definitions"
      let strictMatch = "false"
      let word_id = word.lowercased()
      let url = URL(string: "https://od-api.oxforddictionaries.com:443/api/v2/entries/\(language)/\(word_id)?fields=\(fields)&strictMatch=\(strictMatch)")!
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
                                      
                                      break
                                   }
                                break
                               }
                            break
                           }
                        break
                       }
                    break
                   }
                  completion(definitions)
               } catch {
                   print(error)
               }
       })
      task.resume()
      }
    
    

    

}
*/
 /*
let commonWords: Set = ["are", "is", "a", "ability", "able", "about", "above", "accept", "according", "account", "across", "act", "action", "activity", "actually", "add", "address", "administration", "admit", "adult", "affect", "after", "again", "against", "age", "agency", "agent", "ago", "agree", "agreement", "ahead", "air", "all", "allow", "almost", "alone", "along", "already", "also", "although", "always", "american", "among", "amount", "analysis", "and", "animal", "another", "answer", "any", "anyone", "anything", "appear", "apply", "approach", "area", "argue", "arm", "around", "arrive", "art", "article", "artist", "as", "ask", "assume", "at", "attack", "attention", "attorney", "audience", "author", "authority", "available", "avoid", "away", "baby", "back", "bad", "bag", "ball", "bank", "bar", "base", "be", "beat", "beautiful", "because", "become", "bed", "before", "begin", "behavior", "behind", "believe", "benefit", "best", "better", "between", "beyond", "big", "bill", "billion", "bit", "black", "blood", "blue", "board", "body", "book", "born", "both", "box", "boy", "break", "bring", "brother", "budget", "build", "building", "business", "but", "buy", "by", "call", "camera", "campaign", "can", "cancer", "candidate", "capital", "car", "card", "care", "career", "carry", "case", "catch", "cause", "cell", "center", "central", "century", "certain", "certainly", "chair", "challenge", "chance", "change", "character", "charge", "check", "child", "choice", "choose", "church", "citizen", "city", "civil", "claim", "class", "clear", "clearly", "close", "coach", "cold", "collection", "college", "color", "come", "commercial", "common", "community", "company", "compare", "computer", "concern", "condition", "conference", "congress", "consider", "consumer", "contain", "continue", "control", "cost", "could", "country", "couple", "course", "court", "cover", "create", "crime", "cultural", "culture", "cup", "current", "customer", "cut", "dark", "data", "daughter", "day", "dead", "deal", "death", "debate", "decade", "decide", "decision", "deep", "defense", "degree", "democrat", "democratic", "describe", "design", "despite", "detail", "determine", "develop", "development", "die", "difference", "different", "difficult", "dinner", "direction", "director", "discover", "discuss", "discussion", "disease", "do", "doctor", "dog", "door", "down", "draw", "dream", "drive", "drop", "drug", "during", "each", "early", "east", "easy", "eat", "economic", "economy", "edge", "education", "effect", "effort", "eight", "either", "election", "else", "employee", "end", "energy", "enjoy", "enough", "enter", "entire", "environment", "environmental", "especially", "establish", "even", "evening", "event", "ever", "every", "everybody", "everyone", "everything", "evidence", "exactly", "example", "executive", "exist", "expect", "experience", "expert", "explain", "eye", "face", "fact", "factor", "fail", "fall", "family", "far", "fast", "father", "fear", "federal", "feel", "feeling", "few", "field", "fight", "figure", "fill", "film", "final", "finally", "financial", "find", "fine", "finger", "finish", "fire", "firm", "first", "fish", "five", "floor", "fly", "focus", "follow", "food", "foot", "for", "force", "foreign", "forget", "form", "former", "forward", "four", "free", "friend", "from", "front", "full", "fund", "future", "game", "garden", "gas", "general", "generation", "get", "girl", "give", "glass", "go", "goal", "good", "government", "great", "green", "ground", "group", "grow", "growth", "guess", "gun", "guy", "hair", "half", "hand", "hang", "happen", "happy", "hard", "have", "he", "head", "health", "hear", "heart", "heat", "heavy", "help", "her", "here", "herself", "high", "him", "himself", "his", "history", "hit", "hold", "home", "hope", "hospital", "hot", "hotel", "hour", "house", "how", "however", "huge", "human", "hundred", "husband", "i", "idea", "identify", "if", "image", "imagine", "impact", "important", "improve", "in", "include", "including", "increase", "indeed", "indicate", "individual", "industry", "information", "inside", "instead", "institution", "interest", "interesting", "international", "interview", "into", "investment", "involve", "issue", "it", "item", "its", "itself", "job", "join", "just", "keep", "key", "kid", "kill", "kind", "kitchen", "know", "knowledge", "land", "language", "large", "last", "late", "later", "laugh", "law", "lawyer", "lay", "lead", "leader", "learn", "least", "leave", "left", "leg", "legal", "less", "let", "letter", "level", "lie", "life", "light", "like", "likely", "line", "list", "listen", "little", "live", "local", "long", "look", "lose", "loss", "lot", "love", "low", "machine", "magazine", "main", "maintain", "major", "majority", "make", "man", "manage", "management", "manager", "many", "market", "marriage", "material", "matter", "may", "maybe", "me", "mean", "measure", "media", "medical", "meet", "meeting", "member", "memory", "mention", "message", "method", "middle", "might", "military", "million", "mind", "minute", "miss", "mission", "model", "modern", "moment", "money", "month", "more", "morning", "most", "mother", "mouth", "move", "movement", "movie", "mr", "mrs", "much", "music", "must", "my", "myself", "name", "nation", "national", "natural", "nature", "near", "nearly", "necessary", "need", "network", "never", "new", "news", "newspaper", "next", "nice", "night", "no", "none", "nor", "north", "not", "note", "nothing", "notice", "now", "n't", "number", "occur", "of", "off", "offer", "office", "officer", "official", "often", "oh", "oil", "ok", "old", "on", "once", "one", "only", "onto", "open", "operation", "opportunity", "option", "or", "order", "organization", "other", "others", "our", "out", "outside", "over", "own", "owner", "page", "pain", "painting", "paper", "parent", "part", "participant", "particular", "particularly", "partner", "party", "pass", "past", "patient", "pattern", "pay", "peace", "people", "per", "perform", "performance", "perhaps", "period", "person", "personal", "phone", "physical", "pick", "picture", "piece", "place", "plan", "plant", "play", "player", "pm", "point", "police", "policy", "political", "politics", "poor", "popular", "population", "position", "positive", "possible", "power", "practice", "prepare", "present", "president", "pressure", "pretty", "prevent", "price", "private", "probably", "problem", "process", "produce", "product", "production", "professional", "professor", "program", "project", "property", "protect", "prove", "provide", "public", "pull", "purpose", "push", "put", "quality", "question", "quickly", "quite", "race", "radio", "raise", "range", "rate", "rather", "reach", "read", "ready", "real", "reality", "realize", "really", "reason", "receive", "recent", "recently", "recognize", "record", "red", "reduce", "reflect", "region", "relate", "relationship", "religious", "remain", "remember", "remove", "report", "represent", "republican", "require", "research", "resource", "respond", "response", "responsibility", "rest", "result", "return", "reveal", "rich", "right", "rise", "risk", "road", "rock", "role", "room", "rule", "run", "safe", "same", "save", "say", "scene", "school", "science", "scientist", "score", "sea", "season", "seat", "second", "section", "security", "see", "seek", "seem", "sell", "send", "senior", "sense", "series", "serious", "serve", "service", "set", "seven", "several", "sex", "sexual", "shake", "share", "she", "shoot", "short", "shot", "should", "shoulder", "show", "side", "sign", "significant", "similar", "simple", "simply", "since", "sing", "single", "sister", "sit", "site", "situation", "six", "size", "skill", "skin", "small", "smile", "so", "social", "society", "soldier", "some", "somebody", "someone", "something", "sometimes", "son", "song", "soon", "sort", "sound", "source", "south", "southern", "space", "speak", "special", "specific", "speech", "spend", "sport", "spring", "staff", "stage", "stand", "standard", "star", "start", "state", "statement", "station", "stay", "step", "still", "stock", "stop", "store", "story", "strategy", "street", "strong", "structure", "student", "study", "stuff", "style", "subject", "success", "successful", "such", "suddenly", "suffer", "suggest", "summer", "support", "sure", "surface", "system", "table", "take", "talk", "task", "tax", "teach", "teacher", "team", "technology", "television", "tell", "ten", "tend", "term", "test", "than", "thank", "that", "the", "their", "them", "themselves", "then", "theory", "there", "these", "they", "thing", "think", "third", "this", "those", "though", "thought", "thousand", "threat", "three", "through", "throughout", "throw", "thus", "time", "to", "today", "together", "tonight", "too", "top", "total", "tough", "toward", "town", "trade", "traditional", "training", "travel", "treat", "treatment", "tree", "trial", "trip", "trouble", "true", "truth", "try", "turn", "tv", "two", "type", "under", "understand", "unit", "until", "up", "upon", "us", "use", "usually", "value", "various", "very", "victim", "view", "violence", "visit", "voice", "vote", "wait", "walk", "wall", "want", "war", "watch", "water", "way", "we", "weapon", "wear", "week", "weight", "well", "west", "western", "what", "whatever", "when", "where", "whether", "which", "while", "white", "who", "whole", "whom", "whose", "why", "wide", "wife", "will", "win", "wind", "window", "wish", "with", "within", "without", "woman", "wonder", "word", "work", "worker", "world", "worry", "would", "write", "writer", "wrong", "yard", "yeah", "year", "yes", "yet", "you", "young", "your", "yourself"]
*/

 */*/
