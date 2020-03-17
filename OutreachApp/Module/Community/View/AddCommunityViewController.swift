//
//  AddCommunityViewController.swift
//  OutreachApp
//
//  Created by Demicheli, Stefano on 12/3/2563 BE.
//  Copyright © 2563 NECSI. All rights reserved.
//

import UIKit

class AddCommunityViewController: UIViewController {

    private let viewModel: AddCommunityViewModel
    private let nameTextField = UITextField()
    private let doneButton = UIButton()

    init(viewModel: AddCommunityViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
}

// MARK: - UITextFieldDelegate

extension AddCommunityViewController: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {

    }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {

    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}

// MARK: - Actions

extension AddCommunityViewController {

    @objc func onTextFieldEnd(_ textField: UITextField) {
        guard let name = textField.text else { return }
        viewModel.set(name: name)
    }

    @objc func didTapDone() {
        viewModel.save()
        dismiss(animated: true)
    }

    @objc func didTapDismissButton() {
        dismiss(animated: true)
    }
}

private extension AddCommunityViewController {

    func setupViews() {
        setupMainView()
        setupNameTextField()
        setupDoneButton()
    }

    func setupMainView() {
        title = viewModel.title
        view.backgroundColor = Theme.Color.background
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(didTapDismissButton)
        )
    }

    func setupNameTextField() {
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.addTarget(self, action: #selector(onTextFieldEnd), for: .editingChanged)
        nameTextField.delegate = self
        nameTextField.backgroundColor = Theme.Color.secondaryBackground
        nameTextField.placeholder = viewModel.placeholderText
        nameTextField.layer.cornerRadius = 10
        view.addSubview(nameTextField)
        NSLayoutConstraint.activate([
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            nameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    func setupDoneButton() {
        // TODO: Extract to view
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.addTarget(self, action: #selector(didTapDone), for: .touchUpInside)
        doneButton.backgroundColor = .blue
        doneButton.setTitle(viewModel.buttonText, for: .normal)
        doneButton.setTitleColor(Theme.Color.primaryText, for: .normal)
        doneButton.layer.cornerRadius = 10
        view.addSubview(doneButton)
        NSLayoutConstraint.activate([
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            doneButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
