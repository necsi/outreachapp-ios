//
//  MemberViewModel.swift
//  OutreachApp
//
//  Created by Demicheli, Stefano on 8/3/2563 BE.
//  Copyright © 2563 NECSI. All rights reserved.
//

import Contacts

final class MemberListViewModel {

    var title: String {
        // TODO: add community name
        return community.name ?? "Members"
    }

    var numberOfContacts: Int {
        return members.count
    }

    var updateHandler: (() -> Void)?

    var router: MemberRouter?

    private let community: Community
    private var members: [MemberCellViewModel] = []
    private let memberService: MemberService

    init(community: Community,
         memberService: MemberService) {
        self.community = community
        self.memberService = memberService
    }

    func fetchMembers(completion: @escaping (Error?) -> Void) {
        memberService.fetchMembers(fromCommunity: community) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let contacts):
                let viewModels = contacts.map(self.mapToViewModel)
                self.members = viewModels
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }

    func addMember() {
        router?.goToAddMember()
    }

    func cellViewModel(at indexPath: IndexPath) -> MemberCellViewModel {
        return members[indexPath.row]
    }

    func goToMember(at indexPath: IndexPath) {
        let memberId = members[indexPath.row].identifier
        memberService.fetchMember(withId: memberId) { [weak self] result in
            guard let self = self, let contact = try? result.get() else {
                assertionFailure("Failed to fetch member with id \(memberId)")
                return
            }
            self.router?.goTo(contact: contact)
        }
    }

    func goToNotifications(at indexPath: IndexPath) {
        let memberId = members[indexPath.row].identifier
        memberService.fetchMember(withId: memberId) { [weak self] result in
            guard let self = self, let contact = try? result.get() else {
                assertionFailure("Failed to fetch member with id \(memberId)")
                return
            }
            self.router?.goToNotifications(forContact: contact)
        }
    }
}

// MARK: - PhoneContactModuleOutput

extension MemberListViewModel: PhoneContactModuleOutput {

    func didSelect(contacts: [CNContact]) {
        memberService.save(contacts: contacts, in: community)
        updateHandler?()
    }
}

// MARK: - Private

private extension MemberListViewModel {

    func mapToViewModel(contact: CNContact) -> MemberCellViewModel {
        return MemberCellViewModel(identifier: contact.identifier,
                                   firstName: contact.givenName,
                                   lastName: contact.familyName)
    }
}
