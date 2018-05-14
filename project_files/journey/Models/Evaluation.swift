//
//  Evaluation.swift
//  journey
//
//  Created by sam de smedt on 14/05/2018.
//  Copyright © 2018 sam de smedt. All rights reserved.
//

import Foundation
import CoreData

extension Evaluation {
    
    @NSManaged var review: String
    @NSManaged var mood: Int16
    @NSManaged var goal: Goals
    
    
}


class Evaluation: NSManagedObject {
    // Add this line, the string must be equal to your class name
    static let entityName = "Evaluation"
}

