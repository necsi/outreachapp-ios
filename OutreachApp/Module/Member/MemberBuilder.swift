//
//  MemberBuilder.swift
//  OutreachApp
//
//  Created by Demicheli, Stefano on 8/3/2563 BE.
//  Copyright © 2563 NECSI. All rights reserved.
//

import UIKit

struct MemberBuilder {

    static func build(withCommunity community: Community) -> UIViewController {
        let service = MemberServiceImpl()
        let viewModel = MemberListViewModel(community: community, memberService: service)
        let viewController = MemberViewController(style: .plain,viewModel: viewModel)
        let router = MemberRouter(viewController: viewController, viewModel: viewModel)
        viewModel.router = router
        return viewController
    }
}
