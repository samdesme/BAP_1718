//
//  DataHelper.swift
//  journey
//
//  Created by sam de smedt on 14/04/2018.
//  Copyright © 2018 sam de smedt. All rights reserved.
//

import Foundation
import CoreData
import UIKit

public class DataHelper {
    
    var arrayKeywords = [String]()
    var arrayCustomKeywords = [String]()
    let context: NSManagedObjectContext
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    public func seedDataStore() {
        seedKeywords()
    }
    
    // SEEDING
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
            
            //without model:
            /*
            let entity = NSEntityDescription.entity(forEntityName: "Keywords", in: context)
            let newKeyords = NSManagedObject(entity: entity!, insertInto: context)
            newKeyords.setValue(keyword.title, forKey: "title")
            newKeyords.setValue(keyword.addedByUser, forKey: "addedByUser")
            */
            
            //with model:
            
            let newKeyword = NSEntityDescription.insertNewObject(forEntityName: "Keywords", into: appDelegate.persistentContainer.viewContext) as! Keywords
            let newProfile = NSEntityDescription.insertNewObject(forEntityName: "Profile", into: appDelegate.persistentContainer.viewContext) as! Profile

            newProfile.name = ""
            newProfile.about = ""
            newProfile.id = 1 
            
            
            newKeyword.title = keyword.title
            newKeyword.addedByUser = keyword.addedByUser
            newKeyword.profile = newProfile
            newKeyword.ranking = 0
            
        }
        
        do {
            try appDelegate.persistentContainer.viewContext.save()
        } catch _ {
        }
    }
    
    // KEYWORDS

    // Returns all keywords
    func getAll() -> [Keywords]{
        return get(withPredicate: NSPredicate(value:true))
    }
    
    func get(withPredicate queryPredicate: NSPredicate) -> [Keywords]{
        let fetchRequest = NSFetchRequest<Keywords>(entityName: "Keywords")
        fetchRequest.predicate = queryPredicate
        
      
            let response = try! context.fetch(fetchRequest)
            return response as [Keywords]
        
       
    }
    
    // Returns a keyword by id
    func getById(id: NSManagedObjectID) -> Keywords? {
        return context.object(with: id) as? Keywords
    }

    // Updates a keyword
    func update(updatedKeyword: Keywords){
        if let keyword = getById(id: updatedKeyword.objectID){
            keyword.ranking = updatedKeyword.ranking
           keyword.profile = updatedKeyword.profile
        }
    }
    
    // Deletes a keyword by id
    func delete(id: NSManagedObjectID){
        if let keywordToDelete = getById(id:id){
            context.delete(keywordToDelete)
        }
    }
    
    
    
    
    
    // PROFILE
    
    func getAllProfiles() -> [Profile]{
        return getProfile(withPredicate: NSPredicate(value:true))
    }
    
    func getProfile(withPredicate queryPredicate: NSPredicate) -> [Profile] {
        let fetchRequest = NSFetchRequest<Profile>(entityName: "Profile")
        fetchRequest.predicate = queryPredicate
        
        
        let response = try! context.fetch(fetchRequest)
        return response as [Profile]
        
        
    }
    
    func getProfileById(id: NSManagedObjectID) -> Profile? {
        return context.object(with: id) as? Profile
    }
    
    
    // Updates a profile
    func updateProfile(updatedProfile: Profile){
        if let profile = getProfileById(id: updatedProfile.objectID){
            profile.name = updatedProfile.name
            profile.about = updatedProfile.about
            profile.id = updatedProfile.id
        }
    }
    
    // Deletes a profile by id
    func deleteProfile(id: NSManagedObjectID){
        if let profileToDelete = getProfileById(id:id){
            context.delete(profileToDelete)
        }
    }
    
    
    
    
    // Saves all changes
    func saveChanges(){
        do{
            try context.save()
        } catch let error as NSError {
            // failure
            print(error)
        }
    }
    
    /*
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
 */
    
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
    
   
    
    
    
    public func fetchStandardKeywordsToArray(inputArray:Array<String>) -> Array<String> {
        let keywordFetchRequest = NSFetchRequest<Keywords>(entityName: "Keywords")
        
        
        let allKeywords = try! context.fetch(keywordFetchRequest)
        
        for key in allKeywords {
            //print("Keyword title: \(key.title)\nAdded by user? \(key.addedByUser) \n-------\n", terminator: "")
            if(key.addedByUser == false){
                arrayKeywords.append(key.title)
            }
        }
        
        return arrayKeywords
    }
    
    /*
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

