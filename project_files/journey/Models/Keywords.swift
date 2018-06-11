//
//  Keywords.swift
//  journey
//
//  Created by sam de smedt on 14/04/2018.
//  Copyright © 2018 sam de smedt. All rights reserved.
//

import Foundation
import CoreData

extension Keywords {
    
    @NSManaged var title: String
    @NSManaged var addedByUser: Bool
    @NSManaged var ranking: Int16
    @NSManaged var profile: Profile
    @NSManaged var entries: NSSet
    
    @objc(addSeveritiesObject:)
    @NSManaged public func addToEntryKeyword(_ value: EntryKeywords)
    
    @objc(addSeverities:)
    @NSManaged public func addToEntryKeyword(_ values: NSSet)
}


class Keywords: NSManagedObject {

    static let entityName = "Keywords"
}

