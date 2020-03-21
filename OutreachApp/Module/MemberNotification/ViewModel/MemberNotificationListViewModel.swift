//
//  MemberViewModel.swift
//  OutreachApp
//
//  Created by Demicheli, Stefano on 8/3/2563 BE.
//  Copyright © 2563 NECSI. All rights reserved.
//

import Contacts
import NotificationCenter

final class MemberNotificationListViewModel {

    var title: String {
        return "\(member.givenName) \(member.familyName)"
    }

    var emptyNotificationsDescription: String {
        // TODO: Localize
        return "No notifications have been scheduled yet"
    }

    var deleteNotificationsTitle: String {
        // TODO: Localize
        return "Delete"
    }

    var numberOfNotifications: Int {
        return notificationCellViewModels.count
    }

    var updateHandler: (() -> Void)?

    var router: MemberNotificationRouter?
    let addNotificationViewModel: AddMemberNotificationViewModel

    private let member: CNContact
    private var notificationCellViewModels: [MemberNotificationCellViewModel] = []
    private let notificationService: LocalNotificationService

    init(addNotificationViewModel: AddMemberNotificationViewModel = AddMemberNotificationViewModel(),
         member: CNContact,
         notificationService: LocalNotificationService) {
        self.addNotificationViewModel = addNotificationViewModel
        self.member = member
        self.notificationService = notificationService
    }

    func fetchNotifications(completion: @escaping () -> Void) {
        notificationService.fetchPendingNotifications(memberId: member.identifier) { [weak self] notifications in
            guard let self = self else { return }
            self.notificationCellViewModels = notifications.compactMap(self.mapToViewModel)
            completion()
        }
    }

    func deleteNotification(at indexPath: IndexPath) {
        let cellViewModel = notificationCellViewModels.remove(at: indexPath.row)
        notificationService.deleteNotification(withId: cellViewModel.identifier)
    }

    func registerNotification(forDate date: Date, note: String) {
        // TODO: Localize
        let title = "Reminder to contact \(member.givenName) \(member.familyName)"
        notificationService.notify(contact: member, on: date, title: title, note: note) { [weak self] result in
            guard
                let self = self,
                let request = try? result.get(),
                let cellViewModel = self.mapToViewModel(notification: request) else {
                    assertionFailure("Failed to add notification.")
                    return
            }
            self.notificationCellViewModels.insert(cellViewModel, at: 0)
            self.updateHandler?()
        }
    }

    func cellViewModel(at indexPath: IndexPath) -> MemberNotificationCellViewModel {
        return notificationCellViewModels[indexPath.row]
    }

    func finish() {
        router?.dismiss()
    }
}

// MARK: - Private

private extension MemberNotificationListViewModel {

    func mapToViewModel(notification: UNNotificationRequest) -> MemberNotificationCellViewModel? {
        guard let trigger = notification.trigger as? UNCalendarNotificationTrigger else { return nil }
        return MemberNotificationCellViewModel(
            identifier: notification.identifier,
            date: dateString(from: trigger.dateComponents),
            note: notification.content.body
        )
    }

    func dateString(from dateComponent: DateComponents) -> String {
        guard let date = dateComponent.date else { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, HH:mm"
        return dateFormatter.string(from: date)
    }
}
