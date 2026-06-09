//
//  CartItemCell.swift
//  PayCart
//
//  Created by Ravi Doddi on 5/16/26.
//

import UIKit

final class CartItemCell: UITableViewCell {

    static let reuseIdentifier = "CartItemCell"

    var onIncreaseTapped: (() -> Void)?
    var onDecreaseTapped: (() -> Void)?
    var onRemoveTapped: (() -> Void)?

    private let titleLabel = UILabel()
    private let priceLabel = UILabel()
    private let quantityLabel = UILabel()
    private let itemTotalLabel = UILabel()

    private let decreaseButton = UIButton(type: .system)
    private let increaseButton = UIButton(type: .system)
    private let removeButton = UIButton(type: .system)

    private let mainStackView = UIStackView()
    private let quantityStackView = UIStackView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupView()
        setupLayout()
        setupActions()
        setupAccessibilityIdentifiers()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        onIncreaseTapped = nil
        onDecreaseTapped = nil
        onRemoveTapped = nil
    }

    func configure(
        title: String,
        price: String,
        quantity: String,
        itemTotal: String
    ) {
        titleLabel.text = title
        priceLabel.text = price
        quantityLabel.text = quantity
        itemTotalLabel.text = itemTotal
    }
}

// MARK: - Setup

private extension CartItemCell {

    func setupView() {
        selectionStyle = .none

        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.numberOfLines = 0

        priceLabel.font = .systemFont(ofSize: 15)
        priceLabel.textColor = .secondaryLabel

        quantityLabel.font = .systemFont(ofSize: 15)
        quantityLabel.textAlignment = .center

        itemTotalLabel.font = .boldSystemFont(ofSize: 16)
        itemTotalLabel.textAlignment = .right

        decreaseButton.setTitle("-", for: .normal)
        decreaseButton.titleLabel?.font = .boldSystemFont(ofSize: 22)

        increaseButton.setTitle("+", for: .normal)
        increaseButton.titleLabel?.font = .boldSystemFont(ofSize: 22)

        removeButton.setTitle("Remove", for: .normal)
        removeButton.setTitleColor(.systemRed, for: .normal)

        quantityStackView.axis = .horizontal
        quantityStackView.spacing = 12
        quantityStackView.alignment = .center

        mainStackView.axis = .vertical
        mainStackView.spacing = 8
    }

    func setupLayout() {
        contentView.addSubview(mainStackView)

        mainStackView.translatesAutoresizingMaskIntoConstraints = false

        quantityStackView.addArrangedSubview(decreaseButton)
        quantityStackView.addArrangedSubview(quantityLabel)
        quantityStackView.addArrangedSubview(increaseButton)
        quantityStackView.addArrangedSubview(UIView())
        quantityStackView.addArrangedSubview(removeButton)

        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(priceLabel)
        mainStackView.addArrangedSubview(quantityStackView)
        mainStackView.addArrangedSubview(itemTotalLabel)

        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),

            decreaseButton.widthAnchor.constraint(equalToConstant: 36),
            increaseButton.widthAnchor.constraint(equalToConstant: 36)
        ])
    }

    func setupActions() {
        increaseButton.addTarget(
            self,
            action: #selector(increaseButtonTapped),
            for: .touchUpInside
        )

        decreaseButton.addTarget(
            self,
            action: #selector(decreaseButtonTapped),
            for: .touchUpInside
        )

        removeButton.addTarget(
            self,
            action: #selector(removeButtonTapped),
            for: .touchUpInside
        )
    }

    func setupAccessibilityIdentifiers() {
        titleLabel.accessibilityIdentifier = "cartItemTitleLabel"
        priceLabel.accessibilityIdentifier = "cartItemPriceLabel"
        quantityLabel.accessibilityIdentifier = "cartItemQuantityLabel"
        itemTotalLabel.accessibilityIdentifier = "cartItemTotalLabel"

        increaseButton.accessibilityIdentifier = "cartItemIncreaseButton"
        decreaseButton.accessibilityIdentifier = "cartItemDecreaseButton"
        removeButton.accessibilityIdentifier = "cartItemRemoveButton"
    }
}

// MARK: - Actions

private extension CartItemCell {

    @objc func increaseButtonTapped() {
        onIncreaseTapped?()
    }

    @objc func decreaseButtonTapped() {
        onDecreaseTapped?()
    }

    @objc func removeButtonTapped() {
        onRemoveTapped?()
    }
}
