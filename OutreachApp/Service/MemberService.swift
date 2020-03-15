//
//  MemberService.swift
//  OutreachApp
//
//  Created by Demicheli, Stefano on 10/3/2563 BE.
//  Copyright © 2563 NECSI. All rights reserved.
//

import Contacts
import ContactsUI
import CoreData

protocol MemberService {

    func fetchMembers(fromCommunity community: Community, completion: @escaping (Result<[CNContact], Error>) -> Void)

    func fetchMember(withId id: String, completion: @escaping (Result<CNContact, Error>) -> Void)

    func save(contacts: [CNContact], in community: Community)
}

final class MemberServiceImpl: MemberService {

    private let cnContactStore: CNContactStore
    private let persistenceStore: ContactPersistenceStore

    init(cnContactStore: CNContactStore = CNContactStore(),
         persistenceStore: ContactPersistenceStore = ContactPersistenceStore.shared) {
        self.cnContactStore = cnContactStore
        self.persistenceStore = persistenceStore
    }

    func fetchMembers(fromCommunity community: Community, completion: @escaping (Result<[CNContact], Error>) -> Void) {
        guard let id = community.identifier else { return }
        do {
            let community: Community? = try persistenceStore.fetch(withId: id)
            let members = community?.members?.allObjects as? [Contact] ?? []
            let cnContacts = try fetchCnContacts(from: members)
            completion(Result.success(cnContacts))
        } catch {
            completion(Result.failure(error))
        }
    }

    func fetchMember(withId id: String, completion: @escaping (Result<CNContact, Error>) -> Void) {
        do {
            let contact = try fetchCnContact(withId: id)
            completion(Result.success(contact))
        } catch {
            completion(Result.failure(error))
        }
    }

    func save(contacts: [CNContact], in community: Community) {
        contacts.forEach {
            let contact = Contact(cnContact: $0)
            community.addToMembers(contact)
        }
        do {
            try persistenceStore.save()
        } catch {
            print(error)
        }
    }
}

// MARK: - Private

private extension MemberServiceImpl {

    func fetchCnContacts(from members: [Contact]) throws -> [CNContact] {
        let identifiers = members.compactMap { $0.identifier }
        let predicate: NSPredicate = CNContact.predicateForContacts(withIdentifiers: identifiers)
        return try cnContactStore.unifiedContacts(matching: predicate, keysToFetch: keysWithViewControllerDescriptor())
    }

    func fetchCnContact(withId id: String) throws -> CNContact {
        return try cnContactStore.unifiedContact(withIdentifier: id, keysToFetch: keysWithViewControllerDescriptor())
    }

    func keysWithViewControllerDescriptor() -> [CNKeyDescriptor] {
        var keys = CNContact.defaultKeys
        keys.append(CNContactViewController.descriptorForRequiredKeys())
        return keys
    }
}
