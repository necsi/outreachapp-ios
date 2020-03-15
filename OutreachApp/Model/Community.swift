//
//  Community.swift
//  OutreachApp
//
//  Created by Demicheli, Stefano on 10/3/2563 BE.
//  Copyright © 2563 NECSI. All rights reserved.
//

import CoreData
import Contacts

extension Community {

    convenience init(identifier: String = UUID().uuidString,
                     name: String,
                     context: NSManagedObjectContext = ContactPersistenceStore.shared.mainContext) {
        self.init(context: context)
        self.identifier = identifier
        self.name = name
    }
}
