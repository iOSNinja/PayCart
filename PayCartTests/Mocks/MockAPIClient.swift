//
//  MockAPIClient.swift
//  PayCartTests
//
//  Created by Ravi Doddi on 5/16/26.
//

import Foundation
@testable import PayCart

final class MockAPIClient: APIClientProtocol {
    
    var requestedUrl: String?
    var resultToReturn: Any?
    var errorToReturn: NetworkError?
    
    func fetch<T>(urlString: String, completion: @escaping (Result<T, PayCart.NetworkError>) -> Void) where T : Decodable {
        requestedUrl = urlString
        
        if let error = errorToReturn {
            completion(.failure(error))
        }
        
        if let result = resultToReturn as? T {
            completion(.success(result))
        } else {
            completion(.failure(.decodingFailed))
        }
    }
}
