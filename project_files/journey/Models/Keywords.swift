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
    
}


class Keywords: NSManagedObject {
    // Add this line, the string must be equal to your class name
    static let entityName = "Keywords"
}

