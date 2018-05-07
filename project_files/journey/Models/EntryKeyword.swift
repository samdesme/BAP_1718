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
    @NSManaged var entries: NSSet
    @NSManaged var keywords: NSSet
    @NSManaged var severity: Decimal
    
    
}


class EntryKeyword: NSManagedObject {
    // Add this line, the string must be equal to your class name
    static let entityName = "EntryKeyword"
}
