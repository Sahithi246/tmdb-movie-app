//
//  TMDBAPIClient.swift
//  MovieApp
//
//  Created by Sahithi.Mucchala on 17/11/25.


// Handles actual network calls using async/await.

import Foundation

// Clearly defined what networking errors will come so that we can disaply user-friendly error messages

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case badStatusCode(Int)
    case decodingError
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid request URL."
        case .badStatusCode(let code):
            return "Network error - Status Code: \(code)"
        case .decodingError:
            return "Failed to decode server response."
        case .unknown:
            return "Something went wrong."
        }
    }
}

protocol NetworkClient {
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
}

final class TMDBAPIClient: NetworkClient {
    private let config: AppConfig
    private let urlSession: URLSession

    init(appConfig: AppConfig) {
        self.config = appConfig
        self.urlSession = URLSession.shared
    }

    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        guard var components = URLComponents(url: config.baseURL.appendingPathComponent(endpoint.path), resolvingAgainstBaseURL: false) else {
            throw NetworkError.invalidURL
        }

        var items = endpoint.queryItems
        items.append(URLQueryItem(name: "api_key", value: config.apiKey))
        components.queryItems = items

        guard let url = components.url else { throw NetworkError.invalidURL }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue

        let (data, response) = try await urlSession.data(for: request)

        if let httpResponse = response as? HTTPURLResponse,
           !(200...299).contains(httpResponse.statusCode) {
            throw NetworkError.badStatusCode(httpResponse.statusCode)
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError
        }
    }
}

