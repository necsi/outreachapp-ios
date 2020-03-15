//
//  CommunityRouter.swift
//  OutreachApp
//
//  Created by Demicheli, Stefano on 12/3/2563 BE.
//  Copyright © 2563 NECSI. All rights reserved.
//

import ContactsUI
import UIKit

final class MemberRouter {

    private let phoneContactBuilder: PhoneContactBuilder
    private let viewController: MemberViewController
    private let viewModel: MemberListViewModel

    init(phoneContactBuilder: PhoneContactBuilder = PhoneContactBuilder(),
         viewController: MemberViewController,
         viewModel: MemberListViewModel) {
        self.phoneContactBuilder = phoneContactBuilder
        self.viewController = viewController
        self.viewModel = viewModel
    }

    func goToAddMember() {
        let viewController = phoneContactBuilder.build(output: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        self.viewController.navigationController?.present(navigationController, animated: true)
    }

    func goTo(contact: CNContact) {
        if #available(iOS 9.0, *) {
            let store = CNContactStore()
            let viewController = CNContactViewController(for: contact)
            viewController.contactStore = store
            viewController.delegate = self.viewController
            self.viewController.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
