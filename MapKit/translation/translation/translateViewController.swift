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
    
    func getSynonyms(inputText: String) {
        
        struct totalSynonyms: Codable {
            let message: String
            let terms: [String]
        }
        
        let headers = [
            "x-rapidapi-host": "wikisynonyms.p.rapidapi.com",
            "x-rapidapi-key": "2a6a7cb51cmshf5c498e9aa3a847p1187ffjsnb381fee134ff"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://wikisynonyms.p.rapidapi.com/\(inputText)")! as URL,
            cachePolicy: .useProtocolCachePolicy,
        timeoutInterval: 10.0)
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                guard let jsonData = data else {return}
                //Cop in do here
                do {
                 // decode the JSON into translations array of string arrays.
                 let root = try JSONDecoder().decode(totalSynonyms.self, from: jsonData)
                      for term in root.terms {
                         print(term)
                      }
                                                                                 //break
                    
                    }
                catch {
                        print("JSON ERROR")
                    }
            }
        })

        dataTask.resume()

    }
    
    
    
    @IBAction func searchPressed(_ sender: Any) {
       // getAllDataThree(inputText: engText.text!)
        getAllDataThree(inputText: engText.text!)
    }
    
    @IBAction func displayText(_ sender: Any) {
        //resultText.text = theTranslation.data.translations[0].translatedText
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


extension translateViewController {
    
    //NEW FUNCTION FOR TRANSLATIONS
    func getAllDataThree(inputText: String){
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
              for (key, value) in retTranslations {
                  print(key)
                
                let request = NSMutableURLRequest(url: NSURL(string: "https://systran-systran-platform-for-language-processing-v1.p.rapidapi.com/resources/dictionary/lookup?source=en&target=\(key)&input=\(inputText)")! as URL,
                    cachePolicy: .useProtocolCachePolicy,
                    timeoutInterval: 10.0)
                
                request.httpMethod = "GET"
                request.allHTTPHeaderFields = headers

                let session = URLSession.shared

                
                      let dataTask = session.dataTask(with: request as URLRequest) {data, response, error in guard error == nil else {
                              DispatchQueue.main.async {
                                //  self.removeSpinner()
                                 
                                  return
                                  
                              }
                              print ("error: \(error!)")
                              return
                              
                          }
                          guard let jsonData = data else {
                              retTranslations[key] = "No data found"
                                print("No data")
                              if(counter == transCount){
                                   print("complete in setDef")
                                  // print(retTranslations)
                               }else{
                                   counter = counter + 1
                               }
                            return
                              
                              
                          }
                        
                          let decoder = JSONDecoder()
                          
                          do {
                              // decode the JSON into translations array of string arrays.
                            
                             let root = try JSONDecoder().decode(Root.self, from: jsonData)
                                    //      print(root)
                                          let outputs = root.outputs
                                          for outputVar in outputs {
                                              let outVar = outputVar.output
                                              for match in outVar.matches {
                                                print("Count for \(key): \(match.targets.count)")
                                                    for target in match.targets {
                                                     //for lemma in target.lemma {
                                                      //print(target.lemma)
                                                        retTranslations[key]?.append("\(target.lemma) ")
                                                    }
                                                
                                                     
                                                                       //break
                                                }
                                                                   //break
                                            }
                                 
                              if(counter == transCount){
                                   print("NOT CATCH")
                                   print(retTranslations)
                               }else{
                                   counter = counter + 1
                               }
                              
                              
                          }
                          catch {
                              retTranslations[key]="Translation not found."
                              if(counter == transCount){
                                   //completion(translations)
                                print("HERE")
                                print(retTranslations)
                               }else{
                                   counter = counter + 1
                               }
                          }
                      }
                      dataTask.resume()
                         // print("hello1111111")
                      }//for loop
                      //print("return")
                      //return
                
    }
    
    
    //OLD TRANSLATIONST FUNCTION
    
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
}
