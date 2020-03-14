//
//  PhoneContactService.swift
//  OutreachApp
//
//  Created by Demicheli, Stefano on 8/3/2563 BE.
//  Copyright © 2563 NECSI. All rights reserved.
//

import Contacts
import CoreData

protocol PhoneContactService {

    func fetchContacts(completion: @escaping (Result<[CNContact], Error>) -> Void)
}

final class PhoneContactServiceImpl: PhoneContactService {

    private let contactStore: CNContactStore
    private let persistentStore: ContactPersistenceStore
    private let contactKeys = [
        CNContactGivenNameKey,
        CNContactFamilyNameKey,
        CNContactPhoneNumbersKey,
        CNContactBirthdayKey,
        CNContactOrganizationNameKey,
        CNContactJobTitleKey,
        CNContactMiddleNameKey,
        CNContactEmailAddressesKey,
        CNContactDepartmentNameKey,
        CNContactPhoneNumbersKey,
        CNContactImageDataKey,
        CNContactThumbnailImageDataKey
    ]

    init(contactStore: CNContactStore = CNContactStore(),
         persistentStore: ContactPersistenceStore = ContactPersistenceStore.shared) {
        self.contactStore = contactStore
        self.persistentStore = persistentStore
    }

    func fetchContacts(completion: @escaping (Result<[CNContact], Error>) -> Void) {
        contactStore.requestAccess(for: .contacts) { [weak self] (granted, error) in
            guard let self = self else { return }

            if let error = error {
                completion(Result.failure(error))
                return
            }

            if granted {
                var contacts = [CNContact]()
                let request = CNContactFetchRequest(keysToFetch: self.contactKeys as [CNKeyDescriptor])
                do {
                    try self.contactStore.enumerateContacts(with: request) { (cnContact, _) in
                        contacts.append(cnContact)
                    }
                    DispatchQueue.main.async {
                        completion(Result.success(contacts))
                    }
                } catch let error {
                    DispatchQueue.main.async {
                        completion(Result.failure(error))
                    }
                }
            } else {
                DispatchQueue.main.async {
                    completion(Result.failure(PhoneContactError.accessDenied))
                }
            }
        }
    }

    func delete(contact: Contact) {
        persistentStore.delete(contact)
    }
}

fileprivate enum PhoneContactError: Error {
    case accessDenied
}
