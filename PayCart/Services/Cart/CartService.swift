//
//  CartService.swift
//  PayCart
//
//  Created by Ravi Doddi on 5/15/26.
//

import Foundation

final class CartService: CartServiceProtocol {
    private(set) var items: [CartItem] = []
    
    func add(product: Product) {
        if let index = items.firstIndex(where: { $0.product.id == product.id }) {
            items[index].quantity += 1
        } else {
            items.append(CartItem(product: product, quantity: 1))
        }
    }
    
    func remove(productId: Int) {
        items.removeAll(where: { $0.product.id == productId })
    }
    
    func updateQuantity(productId: Int, quantity: Int) {
        guard let index = items.firstIndex(where: { $0.product.id == productId }) else {
            return
        }
        
        if quantity <= 0 {
            items.removeAll(where: { $0.product.id == productId })
        } else {
            items[index].quantity = quantity
        }
    }
    
    func totalAmount() -> Double {
        return items.reduce(0) { $0 + $1.totalPrice }
    }
    
    func clearCart() {
        items.removeAll()
    }
}
