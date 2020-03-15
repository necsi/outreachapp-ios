//
//  CommunityCellViewModel.swift
//  OutreachApp
//
//  Created by Demicheli, Stefano on 10/3/2563 BE.
//  Copyright © 2563 NECSI. All rights reserved.
//

final class CommunityCellViewModel {

    let identifier: String
    let name: String

    init(identifier: String,
         name: String) {
        self.identifier = identifier
        self.name = name
    }
}
