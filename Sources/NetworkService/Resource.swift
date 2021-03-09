//
//  Resource.swift
//  
//
//  Created by Ilya Senchukov on 04.03.2021.
//

import Foundation

class Resource<T: Decodable> {

    var method: HTTPMethod
    var url: URL
    var body: Data?
    var headers: [String: String]?
    var responseType: T.Type

    init(
        method: HTTPMethod = .get,
        url: URL,
        body: Data? = nil,
        headers: [String: String]? = nil
    ) {

        self.method = method
        self.url = url
        self.body = body
        self.headers = headers
        self.responseType = T.self
    }
}


