//
//  File.swift
//  OutreachApp
//
//  Created by Demicheli, Stefano on 8/3/2563 BE.
//  Copyright © 2563 NECSI. All rights reserved.
//

struct MemberNotificationCellViewModel {

    let identifier: String
    let date: String
    let note: String

    init(identifier: String,
         date: String,
         note: String) {
        self.identifier = identifier
        self.date = date
        self.note = note
    }
}
