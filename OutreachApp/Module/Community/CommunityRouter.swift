//
//  CommunityRouter.swift
//  OutreachApp
//
//  Created by Demicheli, Stefano on 12/3/2563 BE.
//  Copyright © 2563 NECSI. All rights reserved.
//

import UIKit

final class CommunityRouter {

    private let communityListViewController: CommunityViewController
    private var addCommunity: UIViewController?
    private let communityBuilder: CommunityBuilder
    private let memberBuilder: MemberBuilder

    init(communityList: CommunityViewController,
         communityBuilder: CommunityBuilder = CommunityBuilder(),
         memberBuilder: MemberBuilder = MemberBuilder()) {
        self.communityListViewController = communityList
        self.communityBuilder = communityBuilder
        self.memberBuilder = memberBuilder
    }

    func goToAddCommunity() {
        let viewController = communityBuilder.buildAddCommunity(output: communityListViewController)
        self.addCommunity = viewController
        communityListViewController.present(viewController, animated: true)
    }

    func goTo(community: Community) {
        let viewController = memberBuilder.build(withCommunity: community)
        communityListViewController.navigationController?.pushViewController(viewController, animated: true)
    }
}
