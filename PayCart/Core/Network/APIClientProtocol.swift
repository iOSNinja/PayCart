//
//  APIClientProtocol.swift
//  PayCart
//
//  Created by Ravi Doddi on 5/15/26.
//

import Foundation

protocol APIClientProtocol {
    func fetch<T: Decodable>(urlString: String, completion: @escaping (Result<T, NetworkError>) -> Void)
}
