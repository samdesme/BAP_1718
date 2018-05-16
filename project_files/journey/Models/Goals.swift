//
//  Goals.swift
//  journey
//
//  Created by sam de smedt on 14/05/2018.
//  Copyright © 2018 sam de smedt. All rights reserved.
//


import Foundation
import CoreData

extension Goals {
    
    @NSManaged var title: String
    @NSManaged var note: String
    @NSManaged var accomplished: Bool
    @NSManaged var deadline: String
    @NSManaged var created: String
    @NSManaged var keywords: NSSet
    @NSManaged var evaluation: Evaluation
    
    
}


class Goals: NSManagedObject {
    // Add this line, the string must be equal to your class name
    static let entityName = "Goals"
}

