//
//  CommunityService.swift
//  OutreachApp
//
//  Created by Demicheli, Stefano on 10/3/2563 BE.
//  Copyright © 2563 NECSI. All rights reserved.
//

import CoreData

protocol CommunityService {

    func fetchCommunities(completion: @escaping (Result<[Community], Error>) -> Void)

    func fetchCommunity(withId id: String, completion: @escaping (Result<Community, Error>) -> Void)
}

final class CommunityServiceImpl: CommunityService {

    let persistenceStore: ContactPersistenceStore

    init(persistenceStore: ContactPersistenceStore = ContactPersistenceStore.shared) {
        self.persistenceStore = persistenceStore
    }

    func fetchCommunities(completion: @escaping (Result<[Community], Error>) -> Void) {
        do {
            let communities: [Community] = try persistenceStore.fetch()
            completion(Result.success(communities))
        } catch {
            completion(Result.failure(error))
        }
    }

    func fetchCommunity(withId id: String, completion: @escaping (Result<Community, Error>) -> Void) {
        do {
            guard let community: Community = try persistenceStore.fetch(withId: id) else {
                completion(Result.failure(ServiceError.fetchError))
                return
            }
            completion(Result.success(community))
        } catch {
            completion(Result.failure(error))
        }
    }
}
