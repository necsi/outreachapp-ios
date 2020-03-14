//
//  PhoneContactBuilder.swift
//  OutreachApp
//
//  Created by Demicheli, Stefano on 8/3/2563 BE.
//  Copyright © 2563 NECSI. All rights reserved.
//

import UIKit

struct PhoneContactBuilder {

    static func build() -> UIViewController {
        let service = PhoneContactServiceImpl()
        let viewModel = PhoneContactListViewModel(phoneContactService: service)
        let viewController = PhoneContactViewController(style: .plain,viewModel: viewModel)
        let router = PhoneContactRouter(viewController: viewController)
        viewModel.router = router
        return viewController
    }
}
