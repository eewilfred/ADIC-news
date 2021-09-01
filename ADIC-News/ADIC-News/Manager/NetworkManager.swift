//
//  NetworkManager.swift
//  ADIC-News
//
//  Created by Edwin Wilson on 01/09/2021.
//

import Foundation

// MARK: - Response

public struct Response<Value> {

    /// The URL request sent to the server
    public let requestURL: URL?

    /// The data returned by the server
    public let data: Data?

    /// Decoded Result
    public let result: Value?

    /// Error received
    public let error: Error?
}

// MARK: - BaseResult

public protocol BaseResult: Decodable {}

// MARK: - NetworkManager

open class NetworkManager {

    static let shared = NetworkManager()
    let session  = URLSession.shared

    private enum Constants {

        static let baseURL = "https://api.nytimes.com/svc/mostpopular/v2"
        static let apiKey = "G61SecWUjVcl5aeGqcaX2Dww5kifeMeY"
        static let apiKeyParam = "?api-key="
    }

    static func URLForApi(path: String) -> URL? {

        return URL(string: Constants.baseURL + path + Constants.apiKeyParam + Constants.apiKey)
    }

    func start<T: BaseResult>(request: URL, complition: ((Response<T>) -> Void)?) {

        let dataTask = session.dataTask(
        with: request) { ( data, response, error) in

            if error != nil {
                print(error!.localizedDescription)
            }

            guard let data = data else { return }

            if let model = try? JSONDecoder().decode(T.self, from: data) {
                let result = Response(
                    requestURL: request,
                    data: data,
                    result: model,
                    error: error
                )
                complition?(result)
            }
        }
        dataTask.resume()
    }
}
