//
//  CommunityRouter.swift
//  OutreachApp
//
//  Created by Demicheli, Stefano on 12/3/2563 BE.
//  Copyright © 2563 NECSI. All rights reserved.
//

import UIKit

final class CommunityRouter {

    private let communityList: CommunityViewController
    private var addCommunity: UIViewController?
    private let builder: CommunityBuilder

    init(communityList: CommunityViewController,
         builder: CommunityBuilder) {
        self.communityList = communityList
        self.builder = builder
    }

    func goToAddCommunity() {
        let viewController = builder.buildAddCommunity(output: communityList)
        self.addCommunity = viewController
        communityList.present(viewController, animated: true)
    }
}
