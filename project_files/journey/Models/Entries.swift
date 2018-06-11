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
    @NSManaged var edited: Bool


}


class Entries: NSManagedObject {
   
    static let entityName = "Entries"
}
