//
//  ValidatorTests.swift
//  
//
//  Created by Ilya Senchukov on 10.03.2021.
//

import Foundation
import XCTest
@testable import NetworkService

final class ValidatorTests: XCTestCase {

    let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1")!

    func testValidation() {
        let goodResponse = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil)!

        let badResponse = HTTPURLResponse(
            url: url,
            statusCode: 400,
            httpVersion: nil,
            headerFields: nil)!

        let validator = HTTPResponseValidator()

        XCTAssertTrue(validator.validate(goodResponse))
        XCTAssertFalse(validator.validate(badResponse))
    }
}
