//
//  PhoneContactViewController.swift
//  OutreachApp
//
//  Created by Demicheli, Stefano on 8/3/2563 BE.
//  Copyright © 2563 NECSI. All rights reserved.
//

import ContactsUI
import UIKit

final class PhoneContactViewController: UITableViewController {

    private lazy var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.searchResultsUpdater = self
        sc.obscuresBackgroundDuringPresentation = false
        return sc
    }()
    private let doneButton = UIButton()
    private let viewModel: PhoneContactListViewModel

    init(style: UITableView.Style, viewModel: PhoneContactListViewModel) {
        self.viewModel = viewModel
        super.init(style: style)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        fetchPhoneContacts()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // TODO: Create sections based on first letter of last name
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfContacts
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: PhoneContactTableViewCell.reuseId,
            for: indexPath
        )
        let cellViewModel = viewModel.cellViewModel(at: indexPath)
        if let cell = cell as? PhoneContactTableViewCell {
            cell.configure(with: cellViewModel)
        }

        if !viewModel.cellViewModel(at: indexPath).isSelected {
            cell.accessoryType = .none
        } else {
            cell.accessoryType = .checkmark
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .none {
                cell.accessoryType = .checkmark
                viewModel.cellViewModel(at: indexPath).isSelected = true
            } else {
                cell.accessoryType = .none
                viewModel.cellViewModel(at: indexPath).isSelected = false
            }
        }
    }
}

// MARK: - Actions

extension PhoneContactViewController {

    @objc func didPressAddPhoneContactButton() {
        viewModel.addPhoneContact()
    }
}

// MARK: - UISearchResultsUpdating

extension PhoneContactViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        // TODO: Filter sections
        tableView.reloadData()
    }
}

// MARK: - CNContactViewControllerDelegate

extension PhoneContactViewController: CNContactViewControllerDelegate {

    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
        fetchPhoneContacts()
    }
}

// MARK: - Private

private extension PhoneContactViewController {

    func setupViews() {
        setupNavigationBar()
        setupTableView()
        setupSearchViewController()
    }

    func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(didPressAddPhoneContact)
        )
    }

    func setupTableView() {
        title = viewModel.title
        view.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PhoneContactTableViewCell.self,
                           forCellReuseIdentifier: PhoneContactTableViewCell.reuseId)
    }

    func setupSearchViewController() {
        // TODO: navigationItem.searchController
    }

    func fetchPhoneContacts() {
        viewModel.fetchPhoneContacts { [weak self] error in
            if let error = error {
                // TODO: Handle error
                print(error)
                return
            }
            self?.tableView.reloadData()
        }
    }
}
