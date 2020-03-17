//
//  MemberNotificationBuilder.swift
//  OutreachApp
//
//  Created by Demicheli, Stefano on 15/3/2563 BE.
//  Copyright © 2563 NECSI. All rights reserved.
//

import Contacts
import UIKit

struct MemberNotificationBuilder {

    func build(withContact contact: CNContact) -> UIViewController {
        let notificationService = LocalNotificationServiceImpl()
        let listViewModel = MemberNotificationListViewModel(member: contact,
                                                            notificationService: notificationService)
        let viewController = NotificationViewController(viewModel: listViewModel)
        let router = MemberNotificationRouter(viewController: viewController)
        listViewModel.router = router
        return viewController
    }
}
