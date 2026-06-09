//
//  CartViewController.swift
//  PayCart
//
//  Created by Ravi Doddi on 5/16/26.
//

import UIKit

final class CartViewController: UIViewController {

    private let viewModel: CartViewModel
    private let dependencyContainer: AppDependencyContainer

    private let tableView = UITableView()
    private let totalLabel = UILabel()
    private let checkoutButton = UIButton(type: .system)
    private let emptyCartLabel = UILabel()

    private let bottomContainerView = UIView()

    init(viewModel: CartViewModel,
         dependencyContainer: AppDependencyContainer) {
        self.viewModel = viewModel
        self.dependencyContainer = dependencyContainer
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupLayout()
        setupTableView()
        setupAccessibilityIdentifiers()
        bindViewModel()
        refreshUI()
    }
}

// MARK: - Setup

private extension CartViewController {

    func setupView() {
        title = "Cart"
        view.backgroundColor = .systemBackground

        totalLabel.font = .boldSystemFont(ofSize: 20)
        totalLabel.textAlignment = .left

        checkoutButton.setTitle("Checkout", for: .normal)
        checkoutButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        checkoutButton.backgroundColor = .systemBlue
        checkoutButton.setTitleColor(.white, for: .normal)
        checkoutButton.layer.cornerRadius = 10
        checkoutButton.addTarget(
            self,
            action: #selector(checkoutButtonTapped),
            for: .touchUpInside
        )

        emptyCartLabel.text = "Your cart is empty."
        emptyCartLabel.font = .systemFont(ofSize: 18)
        emptyCartLabel.textColor = .secondaryLabel
        emptyCartLabel.textAlignment = .center
        emptyCartLabel.isHidden = true
    }

    func setupLayout() {
        view.addSubview(tableView)
        view.addSubview(emptyCartLabel)
        view.addSubview(bottomContainerView)

        bottomContainerView.addSubview(totalLabel)
        bottomContainerView.addSubview(checkoutButton)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        emptyCartLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomContainerView.translatesAutoresizingMaskIntoConstraints = false
        totalLabel.translatesAutoresizingMaskIntoConstraints = false
        checkoutButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            bottomContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomContainerView.heightAnchor.constraint(equalToConstant: 120),

            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomContainerView.topAnchor),

            emptyCartLabel.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            emptyCartLabel.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
            emptyCartLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            emptyCartLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            totalLabel.topAnchor.constraint(equalTo: bottomContainerView.topAnchor, constant: 16),
            totalLabel.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor, constant: 20),
            totalLabel.trailingAnchor.constraint(equalTo: bottomContainerView.trailingAnchor, constant: -20),

            checkoutButton.topAnchor.constraint(equalTo: totalLabel.bottomAnchor, constant: 16),
            checkoutButton.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor, constant: 20),
            checkoutButton.trailingAnchor.constraint(equalTo: bottomContainerView.trailingAnchor, constant: -20),
            checkoutButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(
            CartItemCell.self,
            forCellReuseIdentifier: CartItemCell.reuseIdentifier
        )

        tableView.tableFooterView = UIView()
    }

    func setupAccessibilityIdentifiers() {
        view.accessibilityIdentifier = "cartView"
        tableView.accessibilityIdentifier = "cartTableView"
        totalLabel.accessibilityIdentifier = "cartTotalLabel"
        checkoutButton.accessibilityIdentifier = "checkoutButton"
        emptyCartLabel.accessibilityIdentifier = "emptyCartLabel"
    }
}

// MARK: - Binding

private extension CartViewController {
 
    func bindViewModel() {
        viewModel.onCartUpdated = { [weak self] in
            self?.refreshUI()
        }

        viewModel.onCartEmpty = { [weak self] in
            self?.refreshUI()
        }

        viewModel.onCheckoutTapped = { [weak self] in
            self?.showCheckout()
        }
    }

    func refreshUI() {
        let isEmpty = viewModel.isCartEmpty

        emptyCartLabel.isHidden = !isEmpty
        tableView.isHidden = isEmpty
        checkoutButton.isEnabled = !isEmpty
        checkoutButton.alpha = isEmpty ? 0.5 : 1.0

        totalLabel.text = viewModel.totalAmountText()

        tableView.reloadData()
    }
}

// MARK: - Actions

private extension CartViewController {

    @objc func checkoutButtonTapped() {
        viewModel.checkout()
    }
}

// MARK: - UITableViewDataSource

extension CartViewController: UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return viewModel.numberOfItems
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CartItemCell.reuseIdentifier,
            for: indexPath
        ) as? CartItemCell else {
            return UITableViewCell()
        }

        cell.configure(
            title: viewModel.titleText(at: indexPath.row),
            price: viewModel.priceText(at: indexPath.row),
            quantity: viewModel.quantityText(at: indexPath.row),
            itemTotal: viewModel.itemTotalText(at: indexPath.row)
        )

        cell.onIncreaseTapped = { [weak self] in
            self?.viewModel.increaseQuantity(at: indexPath.row)
        }

        cell.onDecreaseTapped = { [weak self] in
            self?.viewModel.decreaseQuantity(at: indexPath.row)
        }

        cell.onRemoveTapped = { [weak self] in
            self?.viewModel.removeItem(at: indexPath.row)
        }

        return cell
    }
}

// MARK: - UITableViewDelegate

extension CartViewController: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return UITableView.automaticDimension
    }
}

private extension CartViewController {

    func showCheckout() {
        let checkoutVC = dependencyContainer.makeCheckoutViewController()
        navigationController?.pushViewController(checkoutVC, animated: true)
    }
}
