//
//  PhoneContactViewModel.swift
//  OutreachApp
//
//  Created by Demicheli, Stefano on 8/3/2563 BE.
//  Copyright © 2563 NECSI. All rights reserved.
//

import Contacts

protocol PhoneContactModuleOutput: class {

    func didSelect(contacts: [CNContact])
}

final class PhoneContactListViewModel {

    var title: String {
        // TODO: Localize
        return "Add Contacts"
    }

    var buttonText: String {
        // TODO: Localize
        return "Done"
    }

    var numberOfContacts: Int {
        return phoneContactViewModels.count
    }

    var output: PhoneContactModuleOutput?
    var router: PhoneContactRouter?

    private var phoneContactViewModels: [PhoneContactCellViewModel] = []
    private var contacts: [CNContact] = []
    private let phoneContactService: PhoneContactService

    init(phoneContactService: PhoneContactService) {
        self.phoneContactService = phoneContactService
    }

    func fetchPhoneContacts(completion: @escaping (Error?) -> Void) {
        phoneContactService.fetchContacts { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let contacts):
                self.contacts = contacts
                let viewModels = contacts.compactMap(self.mapToViewModel)
                self.phoneContactViewModels = viewModels
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }

    func addPhoneContact() {
        router?.goToAddPhoneContact()
    }

    func cellViewModel(at indexPath: IndexPath) -> PhoneContactCellViewModel {
        return phoneContactViewModels[indexPath.row]
    }

    func finish() {
        let contacts = filterSelected(cellViewModels: self.phoneContactViewModels)
        output?.didSelect(contacts: contacts)
        router?.dismiss()
    }
}

// MARK: - Private

private extension PhoneContactListViewModel {

    func mapToViewModel(contact: CNContact) -> PhoneContactCellViewModel? {
        return PhoneContactCellViewModel(
            identifier: contact.identifier,
            firstName: contact.givenName,
            lastName: contact.familyName
        )
    }

    func filterSelected(cellViewModels: [PhoneContactCellViewModel]) -> [CNContact] {
        return zip(cellViewModels, contacts)
            .filter { $0.0.isSelected }
            .map { $0.1 }
    }
}
