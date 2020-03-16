//
//  MemberNotificationRouter.swift
//  OutreachApp
//
//  Created by Demicheli, Stefano on 16/3/2563 BE.
//  Copyright © 2563 NECSI. All rights reserved.
//

import UIKit

final class MemberNotificationRouter {

    let viewController: NotificationViewController

    init(viewController: NotificationViewController) {
        self.viewController = viewController
    }

    func dismiss() {
        viewController.dismiss(animated: true)
    }
}
