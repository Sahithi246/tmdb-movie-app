//
//  Endpoint.swift
//  MovieApp
//
//  Created by Sahithi.Mucchala on 17/11/25.
//

// Responsible for type-safe API route building to avoid hardcoded strings throughout the project.


import Foundation

enum HTTPMethod: String {
    case get = "GET"
}

// Protocol that defines required properties for building API requests
protocol Endpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem] { get }
}

// Enum listing all supported API routes for TMDB.
// So when new endpoints are added, it's easier and scalable.

enum TMDBEndpoint: Endpoint {
    case popular
    case search(query: String)
    case movieDetail(id: Int)
    case movieVideos(id: Int)
    case movieCredits(id: Int)

    var path: String {
        switch self {
        case .popular:
            return "/movie/popular"
        case .search:
            return "/search/movie"
        case .movieDetail(let id):
            return "/movie/\(id)"
        case .movieVideos(let id):
            return "/movie/\(id)/videos"
        case .movieCredits(let id):
            return "/movie/\(id)/credits"
        }
    }

    var method: HTTPMethod { .get }

    var queryItems: [URLQueryItem] {
        switch self {
        case .search(let query):
            // Search endpoint requires a "query" parameter
            return [URLQueryItem(name: "query", value: query)]
        default:
            return []
        }
    }
}
