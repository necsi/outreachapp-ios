//
//  MemberService.swift
//  OutreachApp
//
//  Created by Demicheli, Stefano on 10/3/2563 BE.
//  Copyright © 2563 NECSI. All rights reserved.
//

import CoreData

protocol MemberService {

    func fetchMembers(completion: @escaping (Result<[Contact], Error>) -> Void)
}

final class MemberServiceImpl: MemberService {

    let persistenceStore: ContactPersistenceStore

    init(persistenceStore: ContactPersistenceStore = ContactPersistenceStore.shared) {
        self.persistenceStore = persistenceStore
    }

    func fetchMembers(completion: @escaping (Result<[Contact], Error>) -> Void) {
        do {
            let communities: [Contact] = try persistenceStore.fetch()
            completion(Result.success(communities))
        } catch {
            completion(Result.failure(error))
        }
    }
}
