//
//  EntryKeyword.swift
//  journey
//
//  Created by sam de smedt on 08/05/2018.
//  Copyright © 2018 sam de smedt. All rights reserved.
//

import Foundation
import CoreData

extension EntryKeyword {
    @NSManaged var entry: Entries
    @NSManaged var keyword: Keywords
    @NSManaged var severity: Int16
    
    @objc(addEntryObject:)
    @NSManaged public func addToEntries(_ value: Entries)
    
    @objc(addEntry:)
    @NSManaged public func addToEntries(_ values: NSSet)
    
}


class EntryKeyword: NSManagedObject {
    // Add this line, the string must be equal to your class name
    static let entityName = "EntryKeyword"
}
