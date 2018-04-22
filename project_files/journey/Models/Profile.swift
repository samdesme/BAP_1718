//
//  Profile.swift
//  journey
//
//  Created by sam de smedt on 20/04/2018.
//  Copyright © 2018 sam de smedt. All rights reserved.
//

import Foundation
import CoreData

extension Profile {
    @NSManaged var id: Int16
    @NSManaged var name: String
    @NSManaged var about: String
    @NSManaged var keywords: NSSet
    
    @objc(addKeywordsObject:)
    @NSManaged public func addToKeywords(_ value: Keywords)
    
    @objc(addKeywords:)
    @NSManaged public func addToKeywords(_ values: NSSet)
}


class Profile: NSManagedObject {
    // Add this line, the string must be equal to your class name
    static let entityName = "Profile"
}

