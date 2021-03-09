//
//  Validator.swift
//  
//
//  Created by Ilya Senchukov on 04.03.2021.
//

import Foundation

protocol Validator {
    associatedtype Value
    func validate(_ value: Value) -> Bool
}

class HTTPResponseValidator: Validator {

    typealias Value = HTTPURLResponse

    func validate(_ value: HTTPURLResponse) -> Bool {
        let code = value.statusCode

        if code >= 200 && code < 300 {
            return true
        }

        return false
    }
}
