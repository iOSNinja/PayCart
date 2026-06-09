//
//  MockCartService.swift
//  PayCartTests
//
//  Created by Ravi Doddi on 5/16/26.
//

import Foundation
@testable import PayCart

final class MockCartService: CartServiceProtocol {
    private(set) var items: [CartItem] = []
    
    var addProductCalled = false
    var addedProduct: Product?
    
    func add(product: Product) {
        addProductCalled = true
        addedProduct = product
        
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
