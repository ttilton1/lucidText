//
//  newWord.swift
//  LucidText
//
//  Created by Thomas Tilton on 4/17/20.
//  Copyright © 2020 Thomas Tilton. All rights reserved.
//

import Foundation

struct newWord {
    var name = String()
    var definition = String()
    var synonyms = String()
    var spanish = String()
    var hindi = String()
    var arabic = String()
    var mandarin = String()
    var bengali = String()
    var portuguese = String()
    // "Arabic", "Mandarin", "Bengali", "Portuguese"
    init() {
        name = "Unable to fetch value"
        definition = "Unable to fetch value"
        synonyms = "Unable to fetch value"
        spanish = "Unable to fetch value"
        hindi = "Unable to fetch value"
        arabic = "Unable to fetch value"
        mandarin = "Unable to fetch value"
        bengali = "Unable to fetch value"
        portuguese = "Unable to fetch value"
    }
    init(name1: String, definition1: String){
        name = name1
        definition = definition1
        synonyms = "Unable to fetch value"
        spanish = "Unable to fetch value"
        hindi = "Unable to fetch value"
        arabic = "Unable to fetch value"
        mandarin = "Unable to fetch value"
        bengali = "Unable to fetch value"
        portuguese = "Unable to fetch value"
    }
    init(name1: String, definition1: String, syn1: String, sp1: String,
          hi1: String, ar1: String, ma1:String, be1: String, pt1: String){
        name = name1
        definition = definition1
        synonyms = syn1
        spanish = sp1
        hindi = hi1
        arabic = ar1
        mandarin = ma1
        bengali = be1
        portuguese = pt1
    }
}

/*
 //before ViewDidLoad
var container: NSPersistentContainer! //<-separate one for each class
var newWords = [newWord]() //<-put this avove as well
var oldWords = [SavedWord]() //<-put this above homeviewcontroller class
var oldNames = Set<String>()
var newHardWordsCheck = Set<String>() //will do intersection with oldNames
 
 //in ViewDidLoad:
 container = NSPersistentContainer(name: "LucidText")
 
 container.loadPersistentStores { storeDescription, error in
     self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
     
     if let error = error {
         print("Unresolved error \(error)")
     }
 }
 //for ProcessingText1:
 //need to loadNewWords on ViewDidLoad
 //in ViewDidLoad
 loadSavedData() //loads data into oldWords and puts names into oldNames, use .contains("String") with set
 
 //func belowviewdidload
 func loadSavedData() {
     let request = SavedWord.createFetchRequest()
     let sort = NSSortDescriptor(key: "name", ascending: false)
     request.sortDescriptors = [sort]
     
     do {
         oldWords = try container.viewContext.fetch(request)
         //tableView.reloadData()
         getNames(oldWords)
     } catch {
         print("Fetch failed")
     }
 }
 func getNames(wordsFromData: [SavedWord]) {
    oldNames.removeAll()
    for word in wordsFromData {
        oldNames.insert(word.name)
    }
 }
 //on "process text button", do api call, insect "oldNames" and "newHardWordsCheck"
 //after getting newHardWordsCheck do:
 newHardWordsCheck.subtract(oldNames)
 //next create structs with just definitions
 newWords.clearAll()
 for word in newHardWordsCheck
    var 
 
 //FOR PROCESSED TEXT TWO VIEW CONTROLLER
 //separte function:
 func saveContext() {
     if container.viewContext.hasChanges {
         do {
             try container.viewContext.save()
         } catch {
             print("An error occurred while saving: \(error)")
         }
     }
 }
 
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
 
 
 */
