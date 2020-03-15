//
//  CommunityListViewModel.swift
//  OutreachApp
//
//  Created by Demicheli, Stefano on 10/3/2563 BE.
//  Copyright © 2563 NECSI. All rights reserved.
//

import Foundation

final class CommunityListViewModel {

    var title: String {
        // TODO: Internationalize
        return "Communities"
    }

    var numberOfCommunities: Int {
        return cellViewModels.count
    }

    var router: CommunityRouter?

    private var cellViewModels: [CommunityCellViewModel] = []
    private let communityService: CommunityService

    init(communityService: CommunityService) {
        self.communityService = communityService
    }

    func fetchCommunities(completion: @escaping (Error?) -> Void) {
        communityService.fetchCommunities { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let communities):
                let viewModels = communities.compactMap(self.mapToViewModel)
                self.cellViewModels = viewModels
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }

    func cellViewModel(at indexPath: IndexPath) -> CommunityCellViewModel {
        return cellViewModels[indexPath.row]
    }

    func addCommunity() {
        router?.goToAddCommunity()
    }

    func goToCommunity(at indexPath: IndexPath) {
        let communityId = cellViewModels[indexPath.row].identifier
        communityService.fetchCommunity(withId: communityId) { [weak self] result in
            guard let self = self, let community = try? result.get() else {
                assertionFailure("Failed to fetch community with id \(communityId)")
                return
            }
            self.router?.goTo(community: community)
        }
    }
}

// MARK: - Private

private extension CommunityListViewModel {

    func mapToViewModel(community: Community) -> CommunityCellViewModel? {
        guard let id = community.identifier, let name = community.name else { return nil }
        return CommunityCellViewModel(identifier: id, name: name)
    }
}
