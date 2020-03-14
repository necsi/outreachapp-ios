//
//  MemberBuilder.swift
//  OutreachApp
//
//  Created by Demicheli, Stefano on 8/3/2563 BE.
//  Copyright © 2563 NECSI. All rights reserved.
//

import UIKit

struct MemberBuilder {

    static func build() -> UIViewController {
        let service = MemberServiceImpl()
        let viewModel = MemberListViewModel(memberService: service)
        let viewController = MemberViewController(style: .plain,viewModel: viewModel)
        let router = MemberRouter(viewController: viewController)
        viewModel.router = router
        return viewController
    }
}
