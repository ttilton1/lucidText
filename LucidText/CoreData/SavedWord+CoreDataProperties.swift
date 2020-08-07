//
//  SavedWord+CoreDataProperties.swift
//  LucidText
//
//  Created by Thomas Tilton on 4/17/20.
//  Copyright © 2020 Thomas Tilton. All rights reserved.
//
import Foundation
import CoreData

extension SavedWord {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<SavedWord> {
        return NSFetchRequest<SavedWord>(entityName: "SavedWord")
    }
    
    @nonobjc public class func createDeleteRequest() -> NSBatchDeleteRequest {
        return NSBatchDeleteRequest(fetchRequest: NSFetchRequest<SavedWord>(entityName: "SavedWord") as! NSFetchRequest<NSFetchRequestResult>)
    }
    
    

    @NSManaged public var name: String?
    @NSManaged public var definition: String?
    @NSManaged public var synonyms: String?
    @NSManaged public var spanish: String?
    @NSManaged public var arabic: String?
    @NSManaged public var hindi: String?
    @NSManaged public var portuguese: String?
    @NSManaged public var bengali: String?
    @NSManaged public var mandarin: String?
    

}
