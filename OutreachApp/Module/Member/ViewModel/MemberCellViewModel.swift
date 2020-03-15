//
//  File.swift
//  OutreachApp
//
//  Created by Demicheli, Stefano on 8/3/2563 BE.
//  Copyright © 2563 NECSI. All rights reserved.
//

final class MemberCellViewModel {

    let identifier: String
    let firstName: String
    let lastName: String
    var fullName: String {
        return firstName + " " + lastName
    }
    let notes: [String] = []

    init(identifier: String,
         firstName: String,
         lastName: String) {
        self.identifier = identifier
        self.firstName = firstName
        self.lastName = lastName
    }
}
