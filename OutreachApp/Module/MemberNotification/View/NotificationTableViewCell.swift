//
//  NotificationCell.swift
//  OutreachApp
//
//  Created by Demicheli, Stefano on 15/3/2563 BE.
//  Copyright © 2563 NECSI. All rights reserved.
//

import UIKit

final class NotificationTableViewCell: UITableViewCell {

    static let reuseId = "NotificationTableViewCell"

    let labelStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fillEqually
        return sv
    }()

    let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 25)//Appearance.appFont(with: 30)
        label.sizeToFit()
        return label
    }()

    let noteLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(white: 0.85, alpha: 1)
//        label.font = Appearance.appFont(with: 13)
        label.sizeToFit()
        return label
    }()

    private let stateSwitch: UISwitch = {
        let sw = UISwitch()
        sw.onTintColor = .systemPink//.mountainBlue
        sw.tintColor = .white//UIColor.rgb(red: 80, green: 80, blue: 80)
        sw.thumbTintColor = .white
        sw.isOn = true
        return sw
    }()

    private let separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .white//.mountainBlue
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with viewModel: MemberNotificationCellViewModel) {
        timeLabel.text = viewModel.date
        noteLabel.text = viewModel.note
    }
}

// MARK: - Private

private extension NotificationTableViewCell {

    func setupViews() {
        setupStateSwitch()
        setupLabels()
        setupSeparatorLine()
    }

    func setupLabels() {
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(labelStackView)
        NSLayoutConstraint.activate([
            labelStackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            labelStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            labelStackView.trailingAnchor.constraint(equalTo: stateSwitch.leadingAnchor, constant: -16),
            labelStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
        labelStackView.addArrangedSubview(timeLabel)
        labelStackView.addArrangedSubview(noteLabel)
    }

    func setupTimeLabel() {
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(timeLabel)
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            timeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        ])

    }

    func setupNoteLabel() {
        noteLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(noteLabel)
        NSLayoutConstraint.activate([
            noteLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor),
            noteLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        ])
    }

    func setupStateSwitch() {
        stateSwitch.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stateSwitch)
        NSLayoutConstraint.activate([
            stateSwitch.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            stateSwitch.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    func setupSeparatorLine() {
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        addSubview(separatorLine)
        NSLayoutConstraint.activate([
            separatorLine.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            separatorLine.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            separatorLine.bottomAnchor.constraint(equalTo: bottomAnchor),
            separatorLine.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
}
