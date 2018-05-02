//
//  Events.swift
//  journey
//
//  Created by sam de smedt on 29/04/2018.
//  Copyright © 2018 sam de smedt. All rights reserved.
//

import Foundation
import CoreData

extension Events {
    
    @NSManaged var title: String
    @NSManaged var note: String
    @NSManaged var date: String
    @NSManaged var time: Date
}


class Events: NSManagedObject {
    // Add this line, the string must be equal to your class name
    static let entityName = "Events"
}

