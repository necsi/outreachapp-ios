//
//  CommunityRouter.swift
//  OutreachApp
//
//  Created by Demicheli, Stefano on 12/3/2563 BE.
//  Copyright © 2563 NECSI. All rights reserved.
//

import ContactsUI
import UIKit

final class PhoneContactRouter {
    
    private let viewController: PhoneContactViewController

    init(viewController: PhoneContactViewController) {
        self.viewController = viewController
    }

    func goToAddPhoneContact() {
        if #available(iOS 9.0, *) {
            let store = CNContactStore()
            let controller = CNContactViewController(forNewContact: nil)
            controller.contactStore = store
            controller.delegate = viewController
            self.viewController.navigationController?.setNavigationBarHidden(false, animated: true)
            self.viewController.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
