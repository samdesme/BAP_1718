//
//  DataHelper.swift
//  journey
//
//  Created by sam de smedt on 14/04/2018.
//  Copyright © 2018 sam de smedt. All rights reserved.
//

import Foundation
import CoreData

public class DataHelper {
    
    var arrayKeywords = [String]()
    var arrayCustomKeywords = [String]()
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    public func seedDataStore() {
        seedKeywords()
    }
    
    fileprivate func seedKeywords() {
        let keywords = [
            (title: "General Anxiety", addedByUser: false),
            (title: "Social Anxiety", addedByUser: false),
            (title: "Depression", addedByUser: false),
            (title: "Bipolar Disorder", addedByUser: false),
            (title: "ADHD", addedByUser: false),
            (title: "ADD", addedByUser: false),
            (title: "Schizophrenia", addedByUser: false),
            (title: "OCD", addedByUser: false),
            (title: "Trauma", addedByUser: false),
            (title: "Sexual Abuse", addedByUser: false),
            (title: "Verbal Abuse", addedByUser: false),
            (title: "Physical Abuse", addedByUser: false),
            (title: "Addiction", addedByUser: false),
            (title: "Weight Issues", addedByUser: false),
            (title: "LGBT", addedByUser: false),
            (title: "Burn Out", addedByUser: false),
            (title: "Anger Management", addedByUser: false),
            (title: "Autism", addedByUser: false)
        ]
        
        for keyword in keywords {
            let entity = NSEntityDescription.entity(forEntityName: "Keywords", in: context)
            let newKeyords = NSManagedObject(entity: entity!, insertInto: context)
            newKeyords.setValue(keyword.title, forKey: "title")
            newKeyords.setValue(keyword.addedByUser, forKey: "addedByUser")
            
            /*
            let newKeyword = NSEntityDescription.insertNewObject(forEntityName: "Keywords", into: context) as! Keywords
            newKeyword.title = keyword.title
            newKeyword.addedByUser = keyword.addedByUser
             */
        }
        
        do {
            try context.save()
        } catch _ {
        }
    }
    
    public func fetchStandardKeywordsToArray(inputArray:Array<String>) -> Array<String> {
        let keywordFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Keywords")
        let primarySortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        keywordFetchRequest.sortDescriptors = [primarySortDescriptor]
        keywordFetchRequest.returnsObjectsAsFaults = false
        
        let allKeywords = try! context.fetch(keywordFetchRequest)
        
        for key in allKeywords as! [NSManagedObject] {
            //print("Keyword title: \(key.title)\nAdded by user? \(key.addedByUser) \n-------\n", terminator: "")
          
            let bool = key.value(forKey: "addedByUser") as! Bool
            
            if(bool == false){
                
                arrayKeywords.append(key.value(forKey: "title") as! String)
                
            }
           
        }
        
        return arrayKeywords
    }
    
    public func fetchCustomKeywordsToArray(inputArray:Array<String>) -> Array<String> {
        let keywordFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Keywords")
        let primarySortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        keywordFetchRequest.sortDescriptors = [primarySortDescriptor]
        keywordFetchRequest.returnsObjectsAsFaults = false
        
        let allKeywords = try! context.fetch(keywordFetchRequest)
        
        for key in allKeywords as! [NSManagedObject] {
            //print("Keyword title: \(key.title)\nAdded by user? \(key.addedByUser) \n-------\n", terminator: "")
            let bool = key.value(forKey: "addedByUser") as! Bool
            
            if(bool == true){
                
                arrayCustomKeywords.append(key.value(forKey: "title") as! String)
                
            }
            
            
        }
        
        return arrayCustomKeywords
    }
    
    
    
    
    /*
    public func fetchStandardKeywordsToArray(inputArray:Array<String>) -> Array<String> {
        let keywordFetchRequest = NSFetchRequest<Keywords>(entityName: "Keywords")
        let primarySortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        keywordFetchRequest.sortDescriptors = [primarySortDescriptor]
        
        let allKeywords = try! context.fetch(keywordFetchRequest)
        
        for key in allKeywords {
            //print("Keyword title: \(key.title)\nAdded by user? \(key.addedByUser) \n-------\n", terminator: "")
            if(key.addedByUser == false){
                arrayKeywords.append(key.title)
            }
        }
        
        return arrayKeywords
    }
    
    public func fetchCustomKeywordsToArray(inputArray:Array<String>) -> Array<String> {
        let keywordFetchRequest = NSFetchRequest<Keywords>(entityName: "Keywords")
        let primarySortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        keywordFetchRequest.sortDescriptors = [primarySortDescriptor]
        
        let allKeywords = try! context.fetch(keywordFetchRequest)
        
        for key in allKeywords {
            
            if(key.addedByUser == true){
                arrayCustomKeywords.append(key.title)
            }
        }
        
        return arrayCustomKeywords
    }
     */
    
   
}

