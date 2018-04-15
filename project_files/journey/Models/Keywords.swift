//
//  Keywords.swift
//  journey
//
//  Created by sam de smedt on 14/04/2018.
//  Copyright © 2018 sam de smedt. All rights reserved.
//

import Foundation
import CoreData

public class Keywords: NSManagedObject {
    
    @NSManaged var title: String
    @NSManaged var addedByUser: Bool
    
}

