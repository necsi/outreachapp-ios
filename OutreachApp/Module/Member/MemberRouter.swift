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

    init(viewController: MemberViewController,
         phoneContactBuilder: PhoneContactBuilder = PhoneContactBuilder()) {
        self.viewController = viewController
        self.phoneContactBuilder = phoneContactBuilder
    }

    func goToAddMember() {
        let phoneContactViewController = phoneContactBuilder.build()
        self.viewController.navigationController?.pushViewController(phoneContactViewController, animated: true)
    }
}
