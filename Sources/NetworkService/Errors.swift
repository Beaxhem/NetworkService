//
//  Errors.swift
//  
//
//  Created by Ilya Senchukov on 09.03.2021.
//

import Foundation

enum NetworkError: Error {
    case responseError(Int)
    case decodingError
}
