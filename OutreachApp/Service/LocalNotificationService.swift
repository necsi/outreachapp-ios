//
//  LocalNotificationService.swift
//  OutreachApp
//
//  Created by Demicheli, Stefano on 15/3/2563 BE.
//  Copyright © 2563 NECSI. All rights reserved.
//

import Contacts
import NotificationCenter

protocol LocalNotificationService {

    func notify(contact: CNContact, on date: Date, title: String, note: String, completion: @escaping (Result<UNNotificationRequest, Error>) -> Void)

    func fetchPendingNotifications(completion: @escaping ([UNNotificationRequest]) -> Void)

    func deleteNotification(withId id: String)
}

final class LocalNotificationServiceImpl: LocalNotificationService {

    private let notificationCenter: UNUserNotificationCenter

    init(notificationCenter: UNUserNotificationCenter = UNUserNotificationCenter.current()) {
        self.notificationCenter = notificationCenter
    }

    func notify(contact: CNContact, on date: Date, title: String, note: String, completion: @escaping (Result<UNNotificationRequest, Error>) -> Void) {
        checkAuthorization { [weak self] (error) in
            guard let self = self else { return }

            if let error = error {
                DispatchQueue.main.async {
                    completion(Result.failure(error))
                    return
                }
            }

            let content = UNMutableNotificationContent()
            content.title = title
            content.body = note
            content.sound = UNNotificationSound.default

            let components = Calendar.current.dateComponents([.day, .hour, .minute], from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
            let notificationRequest = UNNotificationRequest(
                identifier: UUID().uuidString,
                content: content,
                trigger: trigger
            )

            self.notificationCenter.add(notificationRequest) { (error) in
                DispatchQueue.main.async {
                    if let error = error { completion(Result.failure(error)) }
                    completion(Result.success(notificationRequest))
                }
            }
        }
    }

    func fetchPendingNotifications(completion: @escaping ([UNNotificationRequest]) -> Void) {
        notificationCenter.getPendingNotificationRequests { request in
            DispatchQueue.main.async {
                completion(request)
            }
        }
    }

    func deleteNotification(withId id: String) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [id])
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
}

enum NotificationError: Error {
    case userDidNotAuthorize
}
