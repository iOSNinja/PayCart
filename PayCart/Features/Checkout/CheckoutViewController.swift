//
//  CheckoutViewController.swift
//  PayCart
//
//  Created by Ravi Doddi on 5/17/26.
//

import UIKit

final class CheckoutViewController: UIViewController {

    // MARK: - Dependencies

    private let viewModel: CheckoutViewModel
    private let dependencyContainer: AppDependencyContainer

    // MARK: - UI Components

    private let summaryLabel = UILabel()
    private let totalLabel = UILabel()
    private let paymentMethodLabel = UILabel()
    private let paymentMethodSegmentedControl = UISegmentedControl()
    private let payButton = UIButton(type: .system)
    private let activityIndicator = UIActivityIndicatorView(style: .large)

    // MARK: - Init

    init(
        viewModel: CheckoutViewModel,
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
        setupLayout()
        setupAccessibilityIdentifiers()
        bindViewModel()
        updateUI()
    }
}

// MARK: - Setup

private extension CheckoutViewController {

    func setupView() {
        title = "Checkout"
        view.backgroundColor = .systemBackground

        summaryLabel.font = .systemFont(ofSize: 18)
        summaryLabel.textColor = .label
        summaryLabel.numberOfLines = 0

        totalLabel.font = .boldSystemFont(ofSize: 24)
        totalLabel.textColor = .label
        totalLabel.numberOfLines = 0

        paymentMethodLabel.text = "Select Payment Method"
        paymentMethodLabel.font = .boldSystemFont(ofSize: 18)
        paymentMethodLabel.textColor = .label
        paymentMethodLabel.numberOfLines = 0

        setupPaymentMethodSegmentedControl()

        payButton.setTitle("Pay Now", for: .normal)
        payButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        payButton.backgroundColor = .systemBlue
        payButton.setTitleColor(.white, for: .normal)
        payButton.layer.cornerRadius = 10
        payButton.addTarget(
            self,
            action: #selector(payButtonTapped),
            for: .touchUpInside
        )

        activityIndicator.hidesWhenStopped = true
    }

    func setupPaymentMethodSegmentedControl() {
        for index in 0..<viewModel.numberOfPaymentMethods() {
            paymentMethodSegmentedControl.insertSegment(
                withTitle: viewModel.paymentMethodTitle(at: index),
                at: index,
                animated: false
            )
        }

        let defaultIndex = viewModel.defaultPaymentMethodIndex()
        paymentMethodSegmentedControl.selectedSegmentIndex = defaultIndex
        viewModel.selectPaymentMethod(at: defaultIndex)

        paymentMethodSegmentedControl.addTarget(
            self,
            action: #selector(paymentMethodChanged),
            for: .valueChanged
        )
    }

    func setupLayout() {
        view.addSubview(summaryLabel)
        view.addSubview(totalLabel)
        view.addSubview(paymentMethodLabel)
        view.addSubview(paymentMethodSegmentedControl)
        view.addSubview(payButton)
        view.addSubview(activityIndicator)

        summaryLabel.translatesAutoresizingMaskIntoConstraints = false
        totalLabel.translatesAutoresizingMaskIntoConstraints = false
        paymentMethodLabel.translatesAutoresizingMaskIntoConstraints = false
        paymentMethodSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        payButton.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            summaryLabel.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 32
            ),
            summaryLabel.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 20
            ),
            summaryLabel.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -20
            ),

            totalLabel.topAnchor.constraint(
                equalTo: summaryLabel.bottomAnchor,
                constant: 16
            ),
            totalLabel.leadingAnchor.constraint(
                equalTo: summaryLabel.leadingAnchor
            ),
            totalLabel.trailingAnchor.constraint(
                equalTo: summaryLabel.trailingAnchor
            ),

            paymentMethodLabel.topAnchor.constraint(
                equalTo: totalLabel.bottomAnchor,
                constant: 40
            ),
            paymentMethodLabel.leadingAnchor.constraint(
                equalTo: summaryLabel.leadingAnchor
            ),
            paymentMethodLabel.trailingAnchor.constraint(
                equalTo: summaryLabel.trailingAnchor
            ),

            paymentMethodSegmentedControl.topAnchor.constraint(
                equalTo: paymentMethodLabel.bottomAnchor,
                constant: 16
            ),
            paymentMethodSegmentedControl.leadingAnchor.constraint(
                equalTo: summaryLabel.leadingAnchor
            ),
            paymentMethodSegmentedControl.trailingAnchor.constraint(
                equalTo: summaryLabel.trailingAnchor
            ),

            payButton.topAnchor.constraint(
                equalTo: paymentMethodSegmentedControl.bottomAnchor,
                constant: 40
            ),
            payButton.leadingAnchor.constraint(
                equalTo: summaryLabel.leadingAnchor
            ),
            payButton.trailingAnchor.constraint(
                equalTo: summaryLabel.trailingAnchor
            ),
            payButton.heightAnchor.constraint(equalToConstant: 52),

            activityIndicator.topAnchor.constraint(
                equalTo: payButton.bottomAnchor,
                constant: 32
            ),
            activityIndicator.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            )
        ])
    }

    func setupAccessibilityIdentifiers() {
        view.accessibilityIdentifier = "checkoutView"
        summaryLabel.accessibilityIdentifier = "checkoutSummaryLabel"
        totalLabel.accessibilityIdentifier = "checkoutTotalLabel"
        paymentMethodLabel.accessibilityIdentifier = "checkoutPaymentMethodLabel"
        paymentMethodSegmentedControl.accessibilityIdentifier = "paymentMethodSegmentedControl"
        payButton.accessibilityIdentifier = "payNowButton"
        activityIndicator.accessibilityIdentifier = "checkoutActivityIndicator"
    }
}

// MARK: - Binding

private extension CheckoutViewController {

    func bindViewModel() {
        viewModel.onPaymentStarted = { [weak self] in
            self?.setLoading(true)
        }

        viewModel.onPaymentFinished = { [weak self] in
            self?.setLoading(false)
        }

        viewModel.onPaymentSuccess = { [weak self] receipt in
            self?.showReceipt(receipt)
        }

        viewModel.onPaymentFailure = { [weak self] message in
            self?.showError(message)
        }
    }

    func updateUI() {
        summaryLabel.text = viewModel.itemCountText()
        totalLabel.text = viewModel.totalAmountText()
        updatePayButtonTitle()
    }

    func updatePayButtonTitle() {
        payButton.setTitle(
            "Pay with \(viewModel.selectedPaymentMethodTitle())",
            for: .normal
        )
    }

    func setLoading(_ isLoading: Bool) {
        payButton.isEnabled = !isLoading
        paymentMethodSegmentedControl.isEnabled = !isLoading
        payButton.alpha = isLoading ? 0.5 : 1.0

        if isLoading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
}

// MARK: - Actions

private extension CheckoutViewController {

    @objc func paymentMethodChanged() {
        let selectedIndex = paymentMethodSegmentedControl.selectedSegmentIndex

        guard selectedIndex >= 0 else {
            return
        }

        viewModel.selectPaymentMethod(at: selectedIndex)
        updatePayButtonTitle()
    }

    @objc func payButtonTapped() {
        viewModel.checkout(from: self)
    }
}

// MARK: - Navigation

private extension CheckoutViewController {

    func showReceipt(_ receipt: Receipt) {
        let receiptVC = dependencyContainer.makeReceiptViewController(receipt: receipt)
        navigationController?.pushViewController(receiptVC, animated: true)
    }
}

// MARK: - Alerts

private extension CheckoutViewController {

    func showError(_ message: String) {
        let alert = UIAlertController(
            title: "Payment Failed",
            message: message,
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: .default
            )
        )

        present(alert, animated: true)
    }
}
