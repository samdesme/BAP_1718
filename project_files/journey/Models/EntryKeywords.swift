//
//  EntryKeyword.swift
//  journey
//
//  Created by sam de smedt on 08/05/2018.
//  Copyright © 2018 sam de smedt. All rights reserved.
//

import Foundation
import CoreData

extension EntryKeywords {
    @NSManaged var entry: Entries
    @NSManaged var keyword: Keywords
    @NSManaged var severity: Int16
    
    @objc(addEntryObject:)
    @NSManaged public func addToEntries(_ value: Entries)
    
    @objc(addEntry:)
    @NSManaged public func addToEntries(_ values: NSSet)
    
}


class EntryKeywords: NSManagedObject {
   
    static let entityName = "EntryKeywords"
}
