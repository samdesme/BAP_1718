//
//  ProfileKeywords.swift
//  journey
//
//  Created by sam de smedt on 20/04/2018.
//  Copyright © 2018 sam de smedt. All rights reserved.
//

import Foundation
import CoreData

extension ProfileKeywords {
    @NSManaged var profile: NSSet
    @NSManaged var keyword: NSSet
    @NSManaged var ranking: Int16

    
}


class ProfileKeywords: NSManagedObject {
    
    static let entityName = "ProfileKeywords"
}
