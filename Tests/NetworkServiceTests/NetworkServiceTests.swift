import XCTest
@testable import NetworkService

struct Todo: Decodable, Equatable {
    var userId: Int
    var id: Int
    var title: String
    var completed: Bool
}

final class NetworkServiceTests: XCTestCase {

    let networkService = NetworkService()

    let badURL = URL(string: "https://jsonplaceholder.typicode.com/todos/t")!
    let goodURL = URL(string: "https://jsonplaceholder.typicode.com/todos/1")!

    lazy var goodResource = Resource<Todo>(url: goodURL)
    lazy var badResource = Resource<Todo>(url: badURL)

    lazy var expectedRequest: URLRequest = {
        var request = URLRequest(url: goodURL)

        request.httpMethod = "GET"

        return request
    }()

    let expectedTodo = Todo(
        userId: 1,
        id: 1,
        title: "delectus aut autem",
        completed: false)

    func testNetworkServiceSuccess() {
        let expectation = XCTestExpectation(description: "Successful decoding")

        networkService.fetch(with: goodResource) { [weak self] res in
            switch res {
                case .success(let todo):
                    guard let self = self else { return }

                    XCTAssertEqual(todo.id, self.expectedTodo.id)
                    XCTAssertEqual(todo.title, self.expectedTodo.title)
                    XCTAssertEqual(todo.userId, self.expectedTodo.userId)
                    XCTAssertEqual(todo.completed, self.expectedTodo.completed)

                    expectation.fulfill()
                case .failure(let error):
                    print(error)
            }
        }

        wait(for: [expectation], timeout: 5)
    }

    func testNetworkServiceFailure() {
        let expectation = XCTestExpectation()

        networkService.fetch(with: badResource) { res in
            switch res {
                case .success(_):
                    break
                case .failure(let error):
                    switch error {
                        case .responseError(let code):
                            XCTAssertEqual(code, 404)
                            expectation.fulfill()
                        default:
                            break
                    }
            }
        }

        wait(for: [expectation], timeout: 5)
    }

    func testOverridingHeaders() {
        let expectedHeaders = ["overridingHeader": "newValue"]

        networkService.headers = ["overridingHeader" : "oldValue"]
        goodResource.headers = ["overridingHeader": "newValue"]

        networkService.headers.merge(with: goodResource.headers!)
        XCTAssertEqual(networkService.headers, expectedHeaders)
    }

    func testResourceConvertion() {

        let request = networkService.getRequest(basedOn: goodResource)

        XCTAssertEqual(request.url, expectedRequest.url)
        XCTAssertEqual(request.httpMethod, expectedRequest.httpMethod)
        XCTAssertEqual(request.allHTTPHeaderFields, expectedRequest.allHTTPHeaderFields)
    }

    static var allTests = [
        "testNetworkService": testNetworkServiceSuccess
    ]
}
