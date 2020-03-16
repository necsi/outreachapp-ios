//
//  AddNotificationViewController.swift
//  OutreachApp
//
//  Created by Demicheli, Stefano on 15/3/2563 BE.
//  Copyright © 2563 NECSI. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController {

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel.title
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.sizeToFit()
        return label
    }()

    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "close").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()

    private let separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.alpha = 0.5
        return view
    }()

    private lazy var tableView: NotificationTableView = {
        let tv = NotificationTableView(frame: .zero, style: .plain, viewModel: viewModel)
        return tv
    }()

    private lazy var addNotificationView: AddNotificationView = {
        let view = AddNotificationView(frame: .zero, viewModel: viewModel.addNotificationViewModel)
        view.delegate = self
        return view
    }()

    private var addNotificationViewTopToBottom: NSLayoutConstraint?
    private var addNotificationViewTopToTop: NSLayoutConstraint?

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    private let viewModel: MemberNotificationListViewModel

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setupKeyboardNotifications()
        setupViews()

        addNotificationView.headerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(animateAddNotificationView)))

        viewModel.fetchNotifications { [weak self] in
            self?.tableView.reloadData()
        }
    }

    init(viewModel: MemberNotificationListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Actions

extension NotificationViewController {

    @objc private func animateAddNotificationView() {
        addNotificationViewTopToBottom?.constant = addNotificationView.isCollapsed ? -400 : -60
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 10, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }) { (completed) in
            self.addNotificationView.isCollapsed = self.addNotificationView.isCollapsed ? false : true
        }
    }

    @objc private func handleDismiss() {
        viewModel.finish()
    }

    @objc private func handleKeyboard(notification: NSNotification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
            let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else { return }

        switch notification.name {
        case UIResponder.keyboardWillShowNotification:
            addNotificationViewTopToBottom?.isActive = false
            addNotificationViewTopToTop?.isActive = true
            addNotificationView.headerView.isUserInteractionEnabled = false
            addNotificationView.addButton.isUserInteractionEnabled = false
            addNotificationView.doneButton.isHidden = false
        case UIResponder.keyboardWillHideNotification:
            addNotificationViewTopToBottom?.isActive = true
            addNotificationViewTopToTop?.isActive = false
            addNotificationView.headerView.isUserInteractionEnabled = true
            addNotificationView.addButton.isUserInteractionEnabled = true
            addNotificationView.doneButton.isHidden = true
        default:
            break
        }

        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(rawValue: curve), animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - AddNotificationViewDelegate

extension NotificationViewController: AddNotificationViewDelegate {

    func didTapView() {
        animateAddNotificationView()
    }

    func didSetNotification(with date: Date, note: String) {
        animateAddNotificationView()
        viewModel.registerNotification(forDate: date, note: note)
    }
}

// MARK: - View Setup

private extension NotificationViewController {

    private func setupViews() {
        view.backgroundColor = .black //.mountainDark
        setupTitleLabel()
        setupCloseButton()
        setupSeparatorLine()
        setupTableView()
        setupAddNotificationView()
    }

    func setupTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleLabel.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    func setupCloseButton() {
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            closeButton.widthAnchor.constraint(equalToConstant: 20),
            closeButton.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    func setupSeparatorLine() {
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(separatorLine)
        NSLayoutConstraint.activate([
            separatorLine.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            separatorLine.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            separatorLine.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            separatorLine.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }

    func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: separatorLine.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func setupAddNotificationView() {
        addNotificationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addNotificationView)
        NSLayoutConstraint.activate([
            addNotificationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            addNotificationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            addNotificationView.heightAnchor.constraint(equalToConstant: 450)
        ])
        addNotificationViewTopToBottom = addNotificationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60)
        addNotificationViewTopToBottom?.isActive = true
        addNotificationViewTopToTop = addNotificationView.topAnchor.constraint(equalTo: separatorLine.bottomAnchor)
    }
}

// MARK: - Private

private extension NotificationViewController {

    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
