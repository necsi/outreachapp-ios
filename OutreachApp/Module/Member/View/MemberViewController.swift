//
//  MemberViewController.swift
//  OutreachApp
//
//  Created by Demicheli, Stefano on 8/3/2563 BE.
//  Copyright © 2563 NECSI. All rights reserved.
//

import ContactsUI
import UIKit

final class MemberViewController: UITableViewController {

    private lazy var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.searchResultsUpdater = self
        sc.obscuresBackgroundDuringPresentation = false
        return sc
    }()

    private let viewModel: MemberListViewModel

    init(style: UITableView.Style, viewModel: MemberListViewModel) {
        self.viewModel = viewModel
        super.init(style: style)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        fetchMembers()
        viewModel.updateHandler = fetchMembers
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
            withIdentifier: MemberTableViewCell.reuseId,
            for: indexPath
        )
        let cellViewModel = viewModel.cellViewModel(at: indexPath)
        if let cell = cell as? MemberTableViewCell {
            cell.configure(with: cellViewModel)
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.goToMember(at: indexPath)
    }
}

// MARK: - Actions

extension MemberViewController {

    @objc func didPressAddMemberButton() {
        viewModel.addMember()
    }
}

// MARK: - UISearchResultsUpdating

extension MemberViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        // TODO: Filter sections
        tableView.reloadData()
    }
}

// MARK: - CNContactViewControllerDelegate

extension MemberViewController: CNContactViewControllerDelegate {

    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
        fetchMembers()
    }
}

// MARK: - Private

private extension MemberViewController {

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
            action: #selector(didPressAddMemberButton)
        )
    }

    func setupTableView() {
        title = viewModel.title
        view.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MemberTableViewCell.self,
                           forCellReuseIdentifier: MemberTableViewCell.reuseId)
    }

    func setupSearchViewController() {
        // TODO: navigationItem.searchController
    }

    func fetchMembers() {
        viewModel.fetchMembers { [weak self] error in
            if let error = error {
                // TODO: Handle error
                print(error)
                return
            }
            self?.tableView.reloadData()
        }
    }
}
