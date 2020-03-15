//
//  CommunityBuilder.swift
//  OutreachApp
//
//  Created by Demicheli, Stefano on 10/3/2563 BE.
//  Copyright © 2563 NECSI. All rights reserved.
//

import UIKit

struct CommunityBuilder {

    func buildCommunityList() -> UIViewController {
        let service = CommunityServiceImpl()
        let viewModel = CommunityListViewModel(communityService: service)
        let viewController = CommunityViewController(style: .plain,viewModel: viewModel)
        let router = CommunityRouter(communityList: viewController)
        viewModel.router = router
        return viewController
    }

    func buildAddCommunity(output: AddCommunityViewModelOutput) -> UIViewController {
        let viewModel = AddCommunityViewModel()
        viewModel.output = output
        let viewController = AddCommunityViewController(viewModel: viewModel)
        let navController = UINavigationController(rootViewController: viewController)
        return navController
    }
}
