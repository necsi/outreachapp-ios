//
//  AddCommunityViewModel.swift
//  OutreachApp
//
//  Created by Demicheli, Stefano on 12/3/2563 BE.
//  Copyright © 2563 NECSI. All rights reserved.
//

protocol AddCommunityViewModelOutput: class {

    func didSave(community: Community)
}

final class AddCommunityViewModel {

    var title: String {
        // TODO: Internationalize
        return "Add new community"
    }
    var placeholderText: String {
        // TODO: Internationalize
        return "Add a name for your community"
    }
    var buttonText: String {
        // TODO: Internationalize
        return "Done"
    }
    weak var output: AddCommunityViewModelOutput?

    private var name: String?
    private var description: String?
    private let contactStore: ContactPersistenceStoreProtocol

    init(contactStore: ContactPersistenceStoreProtocol = ContactPersistenceStore.shared) {
        self.contactStore = contactStore
    }

    func set(name: String) {
        self.name = name
    }

    func set(description: String) {
        self.description = description
    }

    func save() {
        guard let name = name else {
            // TODO: Handle error message when no name given
            return
        }
        let community = Community(name: name)
        // TODO: Handle error
        try? contactStore.save(context: nil)
        output?.didSave(community: community)
    }
}
