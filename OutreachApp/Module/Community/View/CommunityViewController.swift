//
//  CommunityViewController.swift
//  OutreachApp
//
//  Created by Demicheli, Stefano on 10/3/2563 BE.
//  Copyright © 2563 NECSI. All rights reserved.
//

import UIKit

final class CommunityViewController: UITableViewController {

    private lazy var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.searchResultsUpdater = self
        sc.obscuresBackgroundDuringPresentation = false
        return sc
    }()

    private let viewModel: CommunityListViewModel

    init(style: UITableView.Style, viewModel: CommunityListViewModel) {
        self.viewModel = viewModel
        super.init(style: style)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        fetchCommunities()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCommunities
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: CommunityTableViewCell.reuseId,
            for: indexPath
        )
        let cellViewModel = viewModel.cellViewModel(at: indexPath)
        if let cell = cell as? CommunityTableViewCell {
            cell.configure(with: cellViewModel)
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Route to community
    }
}

// MARK: - Actions

extension CommunityViewController {

    @objc func didPressAddCommunityButton() {
        viewModel.addCommunity()
    }
}

// MARK: - UISearchResultsUpdating

extension CommunityViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        // TODO: Filter sections
        tableView.reloadData()
    }
}

// MARK: - AddCommunityViewModelOutput

extension CommunityViewController: AddCommunityViewModelOutput {

    func didSave(community: Community) {
        fetchCommunities()
    }
}


private extension CommunityViewController {

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
            action: #selector(didPressAddCommunityButton)
        )
    }

    func setupTableView() {
        title = viewModel.title
        view.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CommunityTableViewCell.self,
                           forCellReuseIdentifier: CommunityTableViewCell.reuseId)
    }

    func setupSearchViewController() {
        // TODO: navigationItem.searchController
    }

    func fetchCommunities() {
        viewModel.fetchCommunities { [weak self] error in
            if let error = error {
                // TODO: Handle error
                print(error)
                return
            }
            self?.tableView.reloadData()
        }
    }
}
