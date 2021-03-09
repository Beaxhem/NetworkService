import XCTest
@testable import NetworkService

struct Todo: Decodable, Equatable {
    var userId: Int
    var id: Int
    var title: String
    var completed: Bool
}

final class NetworkServiceTests: XCTestCase {

    let resource = Resource<Todo>(url: URL(string: "https://jsonplaceholder.typicode.com/todos/1")!)

    let todo1 = Todo(
        userId: 1,
        id: 1,
        title: "delectus aut autem",
        completed: false)

    func testNetworkService() {
        let networkService = NetworkService()

        let expectation = XCTestExpectation(description: "Successful decoding")

        networkService.fetch(with: resource) { [weak self] res in
            switch res {
                case .success(let todo):
                    guard let self = self else { return }

                    XCTAssertEqual(todo.id, self.todo1.id)
                    expectation.fulfill()
                case .failure(let error):
                    print(error)
            }
        }

        wait(for: [expectation], timeout: 5)
    }

    func testOverridingHeaders() {
        let expectedHeaders = ["overridingHeader": "newValue"]

        let networkService = NetworkService(headers: ["overridingHeader" : "oldValue"])

        resource.headers = ["overridingHeader": "newValue"]

        networkService.headers.merge(with: resource.headers!)
        XCTAssertEqual(networkService.headers, expectedHeaders)
    }

    static var allTests = [
        "testNetworkService": testNetworkService
    ]
}
