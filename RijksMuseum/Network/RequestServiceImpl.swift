//
//  RequestServiceImpl.swift
//  RijksMuseum
//
//  Created by Sokol Vadym on 5/11/21.
//

import Foundation

struct RequestServiceImpl: RequestService {
    func performRequest<T>(with request: NetworkRequest, completionHandler: @escaping (Result<T, NetworkError>) -> ()) where T : Codable {
        guard var urlComponents = URLComponents(string: URLs.requestBaseURL) else {
            completionHandler(.failure(.URLError))
            return
        }
        urlComponents.queryItems = request.parameters
        urlComponents.path = request.urlPath
        guard let url = urlComponents.url else {
            completionHandler(.failure(.URLError))
            return
        }
        let dataTask = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let error = error {
                completionHandler(.failure(.loadingError(error.localizedDescription))); return
            }
            guard let response = response as? HTTPURLResponse, let data = data else {
                completionHandler(.failure(.loadingError(nil))); return
            }
            guard (200..<300).contains(response.statusCode) else {
                completionHandler(.failure(.serverSideError(HTTPURLResponse.localizedString(forStatusCode: response.statusCode)))); return
            }
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completionHandler(.success(decodedData))
            } catch {
                completionHandler(.failure(.decodingError))
            }
        }
        
        dataTask.resume()
    }
    
    func performRequest(with urlString: String, completionHandler: @escaping (Result<Data, NetworkError>)->()) {
        guard let url = URL(string: urlString) else {
            completionHandler(.failure(.URLError))
            return
        }
        let dataTask = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let error = error {
                completionHandler(.failure(.loadingError(error.localizedDescription))); return
            }
            guard let response = response as? HTTPURLResponse, let data = data else {
                completionHandler(.failure(.loadingError(nil))); return
            }
            guard (200..<300).contains(response.statusCode) else {
                completionHandler(.failure(.serverSideError(HTTPURLResponse.localizedString(forStatusCode: response.statusCode)))); return
            }
            completionHandler(.success(data))
        }
        
        dataTask.resume()
    }
}
