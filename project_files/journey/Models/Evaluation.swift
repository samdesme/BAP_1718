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
   
    static let entityName = "Evaluation"
}

