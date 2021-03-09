//
//  NetworkService.swift
//
//
//  Created by Ilya Senchukov on 04.03.2021.
//

import Foundation

class NetworkService {

    var session = URLSession.shared
    var validator = HTTPResponseValidator()

    var headers: [String: String]

    init(headers: [String: String] = [:]) {
        self.headers = headers
    }

    @discardableResult
    func fetch<T: Decodable>(
        with resource: Resource<T>,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) -> URLSessionDataTask? {

        let request = getRequest(basedOn: resource)

        let task = session.dataTask(with: request) { [weak self] data, res, err in

            guard let self = self else {
                return
            }

            guard let res = res as? HTTPURLResponse else {
                return
            }

            guard self.validator.validate(res) else {
                completion(.failure(.responseError(res.statusCode)))
                return
            }

            if let data = data {
                do {
                    let result = try JSONDecoder().decode(resource.responseType, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(.decodingError))
                }
            }
        }

        task.resume()

        return task
    }
}

private extension NetworkService {

    func getRequest<T: Decodable>(basedOn resource: Resource<T>) -> URLRequest {
        var request = URLRequest(url: resource.url)

        if let headers = resource.headers {
            self.headers.merge(with: headers)
        }

        request.allHTTPHeaderFields = self.headers
        request.httpMethod = resource.method.rawValue
        request.httpBody = resource.body

        return request
    }

}

