//
//  MockProduct.swift
//  PayCartTests
//
//  Created by Ravi Doddi on 5/16/26.
//

import Foundation
@testable import PayCart

struct MockProduct {
    
    static func make(id: Int, title: String, description: String, price: Double, image: String, category: String) -> Product {
        return Product(id: id,
                       title: title,
                       description: description,
                       price: price,
                       image: image,
                       category: category)
    }
}
