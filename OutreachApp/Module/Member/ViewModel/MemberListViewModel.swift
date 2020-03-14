//
//  MemberViewModel.swift
//  OutreachApp
//
//  Created by Demicheli, Stefano on 8/3/2563 BE.
//  Copyright © 2563 NECSI. All rights reserved.
//

import Foundation

final class MemberListViewModel {

    var title: String {
        // TODO: add community name
        return community?.name ?? "Members"
    }

    var numberOfContacts: Int {
        return members.count
    }

    var router: MemberRouter?

    private var members: [MemberCellViewModel] = []
    private var community: Community?
    private let memberService: MemberService

    init(memberService: MemberService) {
        self.memberService = memberService
    }

    func fetchMembers(completion: @escaping (Error?) -> Void) {
        memberService.fetchMembers { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let contacts):
                let viewModels = contacts.compactMap(self.mapToViewModel)
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
}

// MARK: - Private

private extension MemberListViewModel {

    func mapToViewModel(contact: Contact) -> MemberCellViewModel? {
        guard let firstName = contact.firstName, let lastName = contact.lastName else { return nil }
        return MemberCellViewModel(firstName: firstName, lastName: lastName)
    }
}
