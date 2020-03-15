//
//  LocalNotificationService.swift
//  OutreachApp
//
//  Created by Demicheli, Stefano on 15/3/2563 BE.
//  Copyright © 2563 NECSI. All rights reserved.
//

import NotificationCenter
import Contacts

protocol LocalNotificationService {

    func notify(contact: CNContact, on date: Date, completion: @escaping (Error?) -> Void)
}

final class LocalNotificationServiceImpl: LocalNotificationService {

    private let notificationCenter: UNUserNotificationCenter

    init(notificationCenter: UNUserNotificationCenter = UNUserNotificationCenter.current()) {
        self.notificationCenter = notificationCenter
    }

    func notify(contact: CNContact, on date: Date, completion: @escaping (Error?) -> Void) {
        checkAuthorization { (error) in
            if let error = error { completion(error) }

            // Setup notification
        }
    }
}

// MARK: - Private

private extension LocalNotificationServiceImpl {

    func checkAuthorization(completion: @escaping (Error?) -> Void) {
        getAuthorizationStatus { [weak self] (status) in
            guard let self = self else { return }
            if status != .authorized {
                self.requestAuthorization { (success, error) in
                    if let error = error {
                        completion(error)
                        return
                    }
                    if success {
                        completion(nil)
                    } else {
                        completion(NotificationError.userDidNotAuthorize)
                    }
                }
            } else {
                completion(nil)
            }
        }
    }

    func getAuthorizationStatus(completion: @escaping (UNAuthorizationStatus) -> Void) {
        notificationCenter.getNotificationSettings { (settings) in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus)
            }
        }
    }

    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in
            if let error = error {
                completion(false, error)
            }

            if success {
                DispatchQueue.main.async {
                    completion(true, nil)
                }
            } else {
                completion(false, nil)
            }
        }
    }

    func deleteNotification(withId id: String) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [id])
    }
}

enum NotificationError: Error {
    case userDidNotAuthorize
}
