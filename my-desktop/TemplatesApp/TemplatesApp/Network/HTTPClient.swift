//
//  HTTPClient.swift
//  TemplatesApp
//
//  Created by Jackson  on 04.05.2022.
//

import Foundation

protocol IHTTPClient {
    func execute<T: IModel>(_ request: Request, completion: @escaping (Result<T, Error>) -> ())
    
    /// Use this method to meta-data (images) to server.
    func executeUpload(_ request: Request, completion: @escaping BoolResultClosure)
}

final class HTTPClient: IHTTPClient {
    
    private let urlSession: URLSession
    
    // MARK: - Init
    
    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }
    
    // MARK: - Protocol
    
    func executeUpload(_ request: Request, completion: @escaping BoolResultClosure) {
        executeUploadRequest(request.request) { result in
            switch result {
            case .success(let isSuccess): completion(.success(isSuccess))
            case .failure(let error): completion(.failure(error))
            }
        }
    }
    
    func execute<T: IModel>(_ request: Request, completion: @escaping (Result<T, Error>) -> ()) {
        if request.isNeededToken {
            getToken { [weak self] result in
                switch result {
                case .failure(let error): completion(.failure(error))
                case .success(let token):
                    var urlRequest = request.request
                    
                    urlRequest.allHTTPHeaderFields?.updateValue(
                        "Bearer \(token)",
                        forKey: HeaderKey.accessToken.rawValue)
                    
                    self?.executeRequest(urlRequest, completion: completion)
                }
            }
        } else {
            executeRequest(request.request, completion: completion)
        }
    }
}

// MARK: - Private

private extension HTTPClient {
    func extractError(data: Data, error: Error) -> Error {
        do {
            let error = try JSONDecoder().decode(ErrorResponse.self, from: data)
            throw error.serverError
        } catch let error {
            print("⛔️ Error request, \(error.localizedDescription)")
            return error
        }
    }

    func getToken(completion: @escaping ResultClosure<String>) {
        // PLACE TO FETCH TOKEN
        completion(.success("Fake token"))
    }
    
    func executeUploadRequest(_ request: URLRequest, completion: @escaping BoolResultClosure) {
        urlSession.dataTask(with: request) { _, response, error in
            if let error = error { return completion(.failure(error)) }
            
            guard let response = response as? HTTPURLResponse,
                  let responseStatus = response.status?.rawValue else {
                return completion(.failure("Invalid response"))
            }
            
            let httpStatus = HTTPStatusCode(rawValue: responseStatus) ?? .undefined
            let successfully = httpStatus.responseType == .success
            
            successfully ? print("✅ Upload request success.") : print("⛔️ Upload Request Error.")
            
            completion(.success(successfully))
        }.resume()
    }
    
    func executeRequest<T: IModel>(_ request: URLRequest, completion: @escaping (Result<T, Error>) -> ()) {
        urlSession.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            
            do {
                if let error = error { throw error }
                guard let response = response as? HTTPURLResponse else { throw "Invalid response" }
                guard let data = data else { throw "Response data is empty" }
                guard let statusCode = HTTPStatusCode(rawValue: response.statusCode) else { throw "Status code is invalid" }
                
                switch statusCode.responseType {
                case .success:
                    print("✅ Success: \(statusCode.rawValue), \(request.url?.absoluteString ?? "")")
                    completion(.success(try self.mapData(data: data, decodingType: T.self)))
                default:
                    throw self.extractError(data: data, error: "Something went wrong")
                }
            } catch let error {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func mapData<T: IModel>(data: Data, decodingType: T.Type) throws -> T {
        do {
            return try JSONDecoder().decode(decodingType, from: data)
        } catch let error {
            throw extractError(data: data, error: error)
        }
    }
}
