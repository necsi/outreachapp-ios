//
//  AddNotificationView.swift
//  OutreachApp
//
//  Created by Demicheli, Stefano on 15/3/2563 BE.
//  Copyright © 2563 NECSI. All rights reserved.
//

import UIKit

protocol AddNotificationViewDelegate: class {

    func didTapView()

    func didSetNotification(with date: Date, note: String)
}

class AddNotificationView: UIView {

    let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel.addNotificationTitle
        label.textColor = Theme.Color.primaryText
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.sizeToFit()
        return label
    }()

    let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = Theme.Color.primaryText
        button.addTarget(self, action: #selector(addNotification), for: .touchUpInside)
        return button
    }()

    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.setValue(Theme.Color.primaryText, forKey: "textColor")
        return datePicker
    }()

    private let separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.Color.primaryText
        view.alpha = 0.5
        return view
    }()

    private lazy var noteLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel.noteTextFieldTitle
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = Theme.Color.primaryText
        label.sizeToFit()
        return label
    }()

    private let noteTextField: LeftIconTextField = {
        let tf = LeftIconTextField()
        tf.leftImage = #imageLiteral(resourceName: "note")
//        tf.tintColor = .mountainBlue
        return tf
    }()

    lazy var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(viewModel.doneButtonTitle, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(Theme.Color.primaryText, for: .normal)
        button.isHidden = true
        button.addTarget(self, action: #selector(handleDone), for: .touchUpInside)
        return button
    }()

    weak var delegate: AddNotificationViewDelegate?
    var isCollapsed = true

    private let viewModel: AddMemberNotificationViewModel

    init(frame: CGRect, viewModel: AddMemberNotificationViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Actions

extension AddNotificationView {

    @objc func addNotification() {
        if isCollapsed {
            delegate?.didTapView()
        } else {
            delegate?.didSetNotification(with: datePicker.date, note: noteTextField.text ?? "")
        }
    }

    @objc private func handleDone() {
        noteTextField.resignFirstResponder()
    }
}

// MARK: - Private

private extension AddNotificationView {

    func setupViews() {
        backgroundColor = Theme.Color.background
        layer.cornerRadius = 8
        layer.masksToBounds = true

        setupHeaderView()
        setupDatePicker()
        setupSeparatorLine()
        setupNoteTextField()
        setupNoteLabel()
        setupDoneButton()
    }

    func setupDatePicker() {
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        addSubview(datePicker)
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 30),
            datePicker.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            datePicker.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            datePicker.heightAnchor.constraint(equalToConstant: 200)
        ])
    }

    func setupSeparatorLine() {
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        addSubview(separatorLine)
        NSLayoutConstraint.activate([
            separatorLine.topAnchor.constraint(equalTo: datePicker.bottomAnchor),
            separatorLine.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorLine.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorLine.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }

    func setupNoteTextField() {
        noteTextField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(noteTextField)
        NSLayoutConstraint.activate([
            noteTextField.topAnchor.constraint(equalTo: separatorLine.bottomAnchor, constant: 30),
            noteTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            noteTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            noteTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    func setupNoteLabel() {
        noteLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(noteLabel)
        NSLayoutConstraint.activate([
            noteLabel.topAnchor.constraint(equalTo: separatorLine.bottomAnchor, constant: 4),
            noteLabel.leadingAnchor.constraint(equalTo: noteTextField.leadingAnchor, constant: 4),
            noteLabel.bottomAnchor.constraint(equalTo: noteTextField.topAnchor, constant: -4)
        ])
    }

    func setupDoneButton() {
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(doneButton)
        NSLayoutConstraint.activate([
            doneButton.topAnchor.constraint(equalTo: noteTextField.bottomAnchor, constant: 8),
            doneButton.leadingAnchor.constraint(equalTo: noteTextField.leadingAnchor),
            doneButton.trailingAnchor.constraint(equalTo: noteTextField.trailingAnchor),
            doneButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    func setupHeaderView() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(headerView)
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: topAnchor),
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 60)
        ])

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 60)
        ])

        addButton.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(addButton)
        NSLayoutConstraint.activate([
            addButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            addButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            addButton.heightAnchor.constraint(equalToConstant: 30),
            addButton.widthAnchor.constraint(equalToConstant: 30)
        ])
    }
}
