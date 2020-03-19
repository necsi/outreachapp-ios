//
//  AddNotificationTableView.swift
//  OutreachApp
//
//  Created by Demicheli, Stefano on 15/3/2563 BE.
//  Copyright © 2563 NECSI. All rights reserved.
//

import UIKit

final class NotificationTableView: UITableView, UITableViewDelegate, UITableViewDataSource {

    let viewModel: MemberNotificationListViewModel

    init(frame: CGRect, style: UITableView.Style, viewModel: MemberNotificationListViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame, style: style)
        setupViews()
        viewModel.updateHandler = {
            self.reloadSections(IndexSet(integer: 0), with: .automatic)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfNotifications
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return viewModel.numberOfNotifications == 0 ? 200 : 0
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = viewModel.emptyNotificationsDescription
        label.textColor = Theme.Color.primaryText
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: NotificationTableViewCell.reuseId, for: indexPath)
        let cellViewModel = viewModel.cellViewModel(at: indexPath)
        if let cell = cell as? NotificationTableViewCell {
            cell.configure(with: cellViewModel)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: viewModel.deleteNotificationsTitle, handler: deleteHandlerFunction)
        return [deleteAction]
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private

private extension NotificationTableView {

    func setupViews() {
        backgroundColor = .clear
        delegate = self
        dataSource = self
        register(NotificationTableViewCell.self, forCellReuseIdentifier: NotificationTableViewCell.reuseId)
        separatorStyle = .none
        allowsSelection = false
    }

    func deleteHandlerFunction(action: UITableViewRowAction, indexPath: IndexPath) {
        viewModel.deleteNotification(at: indexPath)
        deleteRows(at: [indexPath], with: .automatic)
    }
}
