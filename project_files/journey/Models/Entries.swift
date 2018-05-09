//
//  Entries.swift
//  journey
//
//  Created by sam de smedt on 08/05/2018.
//  Copyright © 2018 sam de smedt. All rights reserved.
//

import Foundation
import CoreData

extension Entries {
    
    @NSManaged var title: String
    @NSManaged var entry: String
    @NSManaged var mood: Int16
    @NSManaged var date: Date
    @NSManaged var keywords: NSSet
    

}


class Entries: NSManagedObject {
    // Add this line, the string must be equal to your class name
    static let entityName = "Entries"
}
