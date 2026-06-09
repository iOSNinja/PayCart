//
//  ReceiptViewController.swift
//  PayCart
//
//  Created by Ravi Doddi on 5/17/26.
//

import UIKit

final class ReceiptViewController: UIViewController {

    private let viewModel: ReceiptViewModel

    private let titleLabel = UILabel()
    private let orderIdLabel = UILabel()
    private let transactionIdLabel = UILabel()
    private let paymentMethodLabel = UILabel()
    private let totalAmountLabel = UILabel()
    private let itemCountLabel = UILabel()
    private let dateLabel = UILabel()
    private let doneButton = UIButton(type: .system)

    private let stackView = UIStackView()

    init(viewModel: ReceiptViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupLayout()
        setupAccessibilityIdentifiers()
        updateUI()
    }
}

// MARK: - Setup

private extension ReceiptViewController {

    func setupView() {
        title = "Receipt"
        view.backgroundColor = .systemBackground

        navigationItem.hidesBackButton = true

        titleLabel.font = .boldSystemFont(ofSize: 28)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .systemGreen

        let labels = [
            orderIdLabel,
            transactionIdLabel,
            paymentMethodLabel,
            totalAmountLabel,
            itemCountLabel,
            dateLabel
        ]

        labels.forEach { label in
            label.font = .systemFont(ofSize: 16)
            label.numberOfLines = 0
            label.textColor = .label
        }

        totalAmountLabel.font = .boldSystemFont(ofSize: 20)

        doneButton.setTitle("Done", for: .normal)
        doneButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        doneButton.backgroundColor = .systemBlue
        doneButton.setTitleColor(.white, for: .normal)
        doneButton.layer.cornerRadius = 10
        doneButton.addTarget(
            self,
            action: #selector(doneButtonTapped),
            for: .touchUpInside
        )

        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
    }

    func setupLayout() {
        view.addSubview(stackView)
        view.addSubview(doneButton)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(orderIdLabel)
        stackView.addArrangedSubview(transactionIdLabel)
        stackView.addArrangedSubview(paymentMethodLabel)
        stackView.addArrangedSubview(totalAmountLabel)
        stackView.addArrangedSubview(itemCountLabel)
        stackView.addArrangedSubview(dateLabel)

        NSLayoutConstraint.activate([

            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            doneButton.heightAnchor.constraint(equalToConstant: 52)
        ])
    }

    func setupAccessibilityIdentifiers() {
        view.accessibilityIdentifier = "receiptView"
        titleLabel.accessibilityIdentifier = "receiptTitleLabel"
        orderIdLabel.accessibilityIdentifier = "receiptOrderIdLabel"
        transactionIdLabel.accessibilityIdentifier = "receiptTransactionIdLabel"
        paymentMethodLabel.accessibilityIdentifier = "receiptPaymentMethodLabel"
        totalAmountLabel.accessibilityIdentifier = "receiptTotalAmountLabel"
        itemCountLabel.accessibilityIdentifier = "receiptItemCountLabel"
        dateLabel.accessibilityIdentifier = "receiptDateLabel"
        doneButton.accessibilityIdentifier = "receiptDoneButton"
    }
}

// MARK: - UI

private extension ReceiptViewController {

    func updateUI() {
        titleLabel.text = viewModel.titleText()
        orderIdLabel.text = viewModel.orderIdText()
        transactionIdLabel.text = viewModel.transactionIdText()
        paymentMethodLabel.text = viewModel.paymentMethodText()
        totalAmountLabel.text = viewModel.totalAmountText()
        itemCountLabel.text = viewModel.itemCountText()
        dateLabel.text = viewModel.dateText()
    }
}

// MARK: - Actions

private extension ReceiptViewController {

    @objc func doneButtonTapped() {
        navigationController?.popToRootViewController(animated: true)
    }
}
