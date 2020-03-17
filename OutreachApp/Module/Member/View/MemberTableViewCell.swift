//
//  MemberTableViewCell.swift
//  OutreachApp
//
//  Created by Demicheli, Stefano on 8/3/2563 BE.
//  Copyright © 2563 NECSI. All rights reserved.
//

import UIKit

protocol MemberTableViewCellDelegate: class {

    func didTapAccessoryView(at indexPath: IndexPath)
}

final class MemberTableViewCell: UITableViewCell {

    static let reuseId = "MemberTableViewCell"
    var indexPath: IndexPath?
    weak var delegate: MemberTableViewCellDelegate?

    func configure(with viewModel: MemberCellViewModel, indexPath: IndexPath) {
        textLabel?.text = viewModel.fullName
        textLabel?.textColor = Theme.Color.primaryText
        selectionStyle = .none
        backgroundColor = Theme.Color.background
        self.indexPath = indexPath
        let button = UIButton(type: .contactAdd)
        button.addTarget(self, action: #selector(didTapAccessoryView), for: .touchUpInside)
        accessoryView = button
    }

    @objc func didTapAccessoryView() {
        guard let indexPath = indexPath else {
            assertionFailure("Table view did not provide index path.")
            return
        }
        delegate?.didTapAccessoryView(at: indexPath)
    }
}
