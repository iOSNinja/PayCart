//
//  CartServiceProtocol.swift
//  PayCart
//
//  Created by Ravi Doddi on 5/15/26.
//

import Foundation

protocol CartServiceProtocol {
    var items: [CartItem] { get }
    
    func add(product: Product)
    func remove(productId: Int)
    func updateQuantity(productId: Int, quantity: Int)
    func totalAmount() -> Double
    func clearCart()
}
