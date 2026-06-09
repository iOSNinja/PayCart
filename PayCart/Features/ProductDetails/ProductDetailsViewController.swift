//
//  ProductDetailsViewController.swift
//  PayCart
//
//  Created by Ravi Doddi on 5/15/26.
//

import Foundation
import UIKit

final class ProductDetailsViewController: UIViewController {

    // MARK: - Dependencies

    private let viewModel: ProductDetailsViewModel
    private let dependencyContainer: AppDependencyContainer

    // MARK: - UI Components

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let titleLabel = UILabel()
    private let priceLabel = UILabel()
    private let categoryLabel = UILabel()
    private let descriptionLabel = UILabel()

    private let addToCartButton = UIButton(type: .system)
    private let activityIndicator = UIActivityIndicatorView(style: .large)

    // MARK: - Init

    init(viewModel: ProductDetailsViewModel,
         dependencyContainer: AppDependencyContainer
    ) {
        self.viewModel = viewModel
        self.dependencyContainer = dependencyContainer
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupNavigationBar()
        setupLayout()
        setupAccessibilityIdentifiers()
        bindViewModel()

        viewModel.loadProductDetails()
    }
}

// MARK: - Setup

private extension ProductDetailsViewController {

    func setupView() {
        title = "Product Details"
        view.backgroundColor = .systemBackground

        titleLabel.numberOfLines = 0
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.textColor = .label

        priceLabel.numberOfLines = 1
        priceLabel.font = .boldSystemFont(ofSize: 22)
        priceLabel.textColor = .systemGreen

        categoryLabel.numberOfLines = 1
        categoryLabel.font = .systemFont(ofSize: 16)
        categoryLabel.textColor = .secondaryLabel

        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = .systemFont(ofSize: 17)
        descriptionLabel.textColor = .label

        addToCartButton.setTitle("Add to Cart", for: .normal)
        addToCartButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        addToCartButton.backgroundColor = .systemBlue
        addToCartButton.setTitleColor(.white, for: .normal)
        addToCartButton.layer.cornerRadius = 10
        addToCartButton.addTarget(
            self,
            action: #selector(addToCartButtonTapped),
            for: .touchUpInside
        )

        activityIndicator.hidesWhenStopped = true
    }

    func setupLayout() {
        view.addSubview(scrollView)
        view.addSubview(activityIndicator)

        scrollView.addSubview(contentView)

        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(addToCartButton)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        addToCartButton.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            priceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            categoryLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 12),
            categoryLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            categoryLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 24),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            addToCartButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 32),
            addToCartButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            addToCartButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            addToCartButton.heightAnchor.constraint(equalToConstant: 52),
            addToCartButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    func setupAccessibilityIdentifiers() {
        view.accessibilityIdentifier = "productDetailsView"

        titleLabel.accessibilityIdentifier = "productDetailsTitleLabel"
        priceLabel.accessibilityIdentifier = "productDetailsPriceLabel"
        categoryLabel.accessibilityIdentifier = "productDetailsCategoryLabel"
        descriptionLabel.accessibilityIdentifier = "productDetailsDescriptionLabel"

        addToCartButton.accessibilityIdentifier = "addToCartButton"
        activityIndicator.accessibilityIdentifier = "productDetailsActivityIndicator"
    }
}

// MARK: - Binding

private extension ProductDetailsViewController {

    func bindViewModel() {

        viewModel.onLoadingChanged = { [weak self] isLoading in
            guard let self = self else { return }

            if isLoading {
                self.activityIndicator.startAnimating()
                self.contentView.isHidden = true
            } else {
                self.activityIndicator.stopAnimating()
                self.contentView.isHidden = false
            }
        }

        viewModel.onProductLoaded = { [weak self] in
            self?.updateUI()
        }

        viewModel.onError = { [weak self] message in
            self?.showError(message)
        }

        viewModel.onAddToCartSuccess = { [weak self] message in
            self?.showSuccess(message)
        }
    }

    func updateUI() {
        titleLabel.text = viewModel.titleText()
        priceLabel.text = viewModel.priceText()
        categoryLabel.text = viewModel.categoryText()
        descriptionLabel.text = viewModel.descriptionText()
    }
}

// MARK: - Actions

private extension ProductDetailsViewController {

    @objc func addToCartButtonTapped() {
        viewModel.addToCart()
    }
}

// MARK: - Alerts

private extension ProductDetailsViewController {

    func showError(_ message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "OK", style: .default))

        present(alert, animated: true)
    }

    func showSuccess(_ message: String) {
        let alert = UIAlertController(
            title: "Success",
            message: message,
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "OK", style: .default))

        present(alert, animated: true)
    }
}

private extension ProductDetailsViewController {

    func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Cart",
            style: .plain,
            target: self,
            action: #selector(cartButtonTapped)
        )
    }

    @objc func cartButtonTapped() {
        let cartVC = dependencyContainer.makeCartViewController()
        navigationController?.pushViewController(cartVC, animated: true)
    }
}
