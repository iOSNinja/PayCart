//
//  CartItem.swift
//  PayCart
//
//  Created by Ravi Doddi on 5/15/26.
//

import Foundation

struct CartItem: Equatable {
    let product: Product
    var quantity: Int
    
    var totalPrice: Double {
        return product.price * Double(quantity)
    }
}
