//
//  NetworkError.swift
//  PayCart
//
//  Created by Ravi Doddi on 5/15/26.
//

import Foundation

enum NetworkError: Error, Equatable {
    case invalidURL
    case noData
    case decodingFailed
    case serverError
    case unknown
}
