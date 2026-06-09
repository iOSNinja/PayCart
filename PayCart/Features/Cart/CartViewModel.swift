//
//  CartViewModel.swift
//  PayCart
//
//  Created by Ravi Doddi on 5/16/26.
//

import Foundation

final class CartViewModel {

    private let cartService: CartServiceProtocol

    var onCartUpdated: (() -> Void)?
    var onCartEmpty: (() -> Void)?
    var onCheckoutTapped: (() -> Void)?

    init(cartService: CartServiceProtocol) {
        self.cartService = cartService
    }

    var numberOfItems: Int {
        return cartService.items.count
    }

    var isCartEmpty: Bool {
        return cartService.items.isEmpty
    }

    func item(at index: Int) -> CartItem {
        return cartService.items[index]
    }

    func titleText(at index: Int) -> String {
        return item(at: index).product.title
    }

    func priceText(at index: Int) -> String {
        let price = item(at: index).product.price
        return String(format: "$%.2f", price)
    }

    func quantityText(at index: Int) -> String {
        return "Qty: \(item(at: index).quantity)"
    }

    func itemTotalText(at index: Int) -> String {
        let total = item(at: index).totalPrice
        return String(format: "$%.2f", total)
    }

    func totalAmountText() -> String {
        let total = cartService.totalAmount()
        return String(format: "Total: $%.2f", total)
    }

    func increaseQuantity(at index: Int) {
        let cartItem = item(at: index)
        let newQuantity = cartItem.quantity + 1

        cartService.updateQuantity(
            productId: cartItem.product.id,
            quantity: newQuantity
        )

        notifyCartStateChanged()
    }

    func decreaseQuantity(at index: Int) {
        let cartItem = item(at: index)
        let newQuantity = cartItem.quantity - 1

        cartService.updateQuantity(
            productId: cartItem.product.id,
            quantity: newQuantity
        )

        notifyCartStateChanged()
    }

    func removeItem(at index: Int) {
        let cartItem = item(at: index)

        cartService.remove(productId: cartItem.product.id)

        notifyCartStateChanged()
    }

    func checkout() {
        guard !cartService.items.isEmpty else {
            onCartEmpty?()
            return
        }

        onCheckoutTapped?()
    }

    private func notifyCartStateChanged() {
        if cartService.items.isEmpty {
            onCartEmpty?()
        }

        onCartUpdated?()
    }
}
