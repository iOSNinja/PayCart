//
//  Product.swift
//  PayCart
//
//  Created by Ravi Doddi on 5/15/26.
//

import Foundation

struct Product: Decodable, Equatable {
    let id: Int
    let title: String
    let description: String
    let price: Double
    let image: String
    let category: String
}
