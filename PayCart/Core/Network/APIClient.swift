//
//  APIClient.swift
//  PayCart
//
//  Created by Ravi Doddi on 5/15/26.
//

import Foundation

final class APIClient: APIClientProtocol {
    func fetch<T>(urlString: String, completion: @escaping (Result<T, NetworkError>) -> Void) where T : Decodable {
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            // check error
            if error != nil {
                completion(.failure(NetworkError.unknown))
                return
            }
            
            // validate response code
            guard let httpResponse = response as? HTTPURLResponse,
                    200...299 ~= httpResponse.statusCode else {
                completion(.failure(NetworkError.serverError))
                return
            }
            
            // check valid data
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            // Decode data
            do {
                let decodedObject = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedObject))
            } catch {
                completion(.failure(NetworkError.decodingFailed))
            }
        }.resume()
    }
}
