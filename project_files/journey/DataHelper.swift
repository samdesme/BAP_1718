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
            
            newKeyword.title = keyword.title
            newKeyword.addedByUser = keyword.addedByUser
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
    
    func createProfile(name: String, about: String, id: Int16) -> Profile {
        
        let newProfile = NSEntityDescription.insertNewObject(forEntityName: Profile.entityName, into: context) as! Profile
        
        newProfile.name = name
        newProfile.about = about
        newProfile.id = id
        
        return newProfile
    }
    
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
    
    
    // EVENTS
    
    func createEvent(title: String, note: String, date: String, time: Date) -> Events {
        
        let newEvent = NSEntityDescription.insertNewObject(forEntityName: Events.entityName, into: context) as! Events
        
        newEvent.title = title
        newEvent.note = note
        newEvent.date = date
        newEvent.time = time
        
        return newEvent
    }
    
    // Returns all keywords
    func getAllEvents() -> [Events]{
        return getEvent(withPredicate: NSPredicate(value:true))
    }
    
    func getEvent(withPredicate queryPredicate: NSPredicate) -> [Events]{
        let fetchRequest = NSFetchRequest<Events>(entityName: "Events")
        fetchRequest.predicate = queryPredicate
        
        
        let response = try! context.fetch(fetchRequest)
        return response as [Events]
        
        
    }
    
    func getEventById(id: NSManagedObjectID) -> Events? {
        return context.object(with: id) as? Events
    }
    
    func updateEvent(updatedEvent: Events){
        if let event = getEventById(id: updatedEvent.objectID){
            event.title = updatedEvent.title
            event.note = updatedEvent.note
            event.date = updatedEvent.date
            event.time = updatedEvent.time
        }
    }
    
    func deleteEvent(id: NSManagedObjectID){
        if let EventToDelete = getEventById(id:id){
            context.delete(EventToDelete)
        }
    }
    
    
    // ENTRIES
    
    func createEntry(title: String, entry: String, mood: Int16, date: Date) -> Entries {
        
        let newEntry = NSEntityDescription.insertNewObject(forEntityName: Entries.entityName, into: context) as! Entries
        
        newEntry.title = title
        newEntry.entry = entry
        newEntry.mood = mood
        newEntry.date = date
        
        return newEntry
    }
    
    // Returns all keywords
    func getAllEntries() -> [Entries]{
        return getEntry(withPredicate: NSPredicate(value:true))
    }
    
    func getEntry(withPredicate queryPredicate: NSPredicate) -> [Entries]{
        
        let fetchRequest = NSFetchRequest<Entries>(entityName: "Entries")
        fetchRequest.predicate = queryPredicate
        
        let response = try! context.fetch(fetchRequest)
        return response as [Entries]
        
        
    }
    
    func getEntryById(id: NSManagedObjectID) -> Entries? {
        return context.object(with: id) as? Entries
    }
    
    func updateEntry(updatedEntry: Entries){
        if let entry = getEntryById(id: updatedEntry.objectID){
            
            entry.title = updatedEntry.title
            entry.entry = updatedEntry.entry
            entry.mood = updatedEntry.mood
            entry.date = updatedEntry.date

        }
    }
    
    func deleteEntry(id: NSManagedObjectID){
        if let EntryToDelete = getEntryById(id:id){
            context.delete(EntryToDelete)
        }
    }
    
    // ENTRY_KEYWORD
    
    func createSeverity(keyword: Keywords, entry: Entries, severity: Int16) -> EntryKeyword {
        
        let newSeverity = NSEntityDescription.insertNewObject(forEntityName: EntryKeyword.entityName, into: context) as! EntryKeyword
        
        newSeverity.entry = entry
        newSeverity.keyword = keyword
        newSeverity.severity = severity
 
        
        return newSeverity
    }
    
    // Returns all keywords
    func getAllSeverities() -> [EntryKeyword]{
        return getSeverity(withPredicate: NSPredicate(value:true))
    }
    
    func getSeverity(withPredicate queryPredicate: NSPredicate) -> [EntryKeyword]{
        let fetchRequest = NSFetchRequest<EntryKeyword>(entityName: "EntryKeyword")
        fetchRequest.predicate = queryPredicate
        
        let response = try! context.fetch(fetchRequest)
        return response as [EntryKeyword]
        
        
    }
    
    func getSeverityById(id: NSManagedObjectID) -> EntryKeyword? {
        return context.object(with: id) as? EntryKeyword
    }
    
    func updateSeverity(updatedSeverity: EntryKeyword){
        if let severity = getSeverityById(id: updatedSeverity.objectID){
            severity.entry = updatedSeverity.entry
            severity.keyword = updatedSeverity.keyword
            severity.severity = updatedSeverity.severity

            
        }
    }
    
    func deleteSeverity(id: NSManagedObjectID){
        if let SeverityToDelete = getSeverityById(id:id){
            context.delete(SeverityToDelete)
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

