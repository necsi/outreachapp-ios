//
//  MemberTableViewCell.swift
//  OutreachApp
//
//  Created by Demicheli, Stefano on 8/3/2563 BE.
//  Copyright © 2563 NECSI. All rights reserved.
//

import UIKit

final class MemberTableViewCell: UITableViewCell {

    static let reuseId = "MemberTableViewCell"

    func configure(with viewModel: MemberCellViewModel) {
        textLabel?.text = viewModel.fullName
        selectionStyle = .none
    }
}
