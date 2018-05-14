//
//  GoalKeywords.swift
//  journey
//
//  Created by sam de smedt on 14/05/2018.
//  Copyright © 2018 sam de smedt. All rights reserved.
//

import Foundation
import CoreData

extension GoalKeywords {
    @NSManaged var goal: Goals
    @NSManaged var keyword: Keywords
    @NSManaged var rate: Int16
    
}


class GoalKeywords: NSManagedObject {
    // Add this line, the string must be equal to your class name
    static let entityName = "GoalKeywords"
}
