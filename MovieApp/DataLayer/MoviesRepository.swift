//
//  MoviesRepository.swift
//  MovieApp
//
//  Created by Sahithi.Mucchala on 17/11/25.

// Purpose: Converts endpoint calls into strongly typed model fetch operations.
// Why: Keeps ViewModels unaware of networking or endpoint structure.
// Advantage: Enables mocking for unit tests.

import Foundation

protocol MoviesRepositoryProtocol {
    func fetchPopularMovies() async throws -> [MovieSummary]
    func searchMovies(query: String) async throws -> [MovieSummary]
    func fetchMovieDetail(id: Int) async throws -> MovieDetail
    func fetchMovieVideos(id: Int) async throws -> [MovieVideo]
    func fetchMovieCredits(id: Int) async throws -> [CastMember]
}

final class MoviesRepository: MoviesRepositoryProtocol {
    private let apiClient: NetworkClient

    init(apiClient: NetworkClient) {
        self.apiClient = apiClient
    }

    func fetchPopularMovies() async throws -> [MovieSummary] {
        let response: PopularMoviesResponse = try await apiClient.request(TMDBEndpoint.popular)
        return response.results
    }

    func searchMovies(query: String) async throws -> [MovieSummary] {
        let response: PopularMoviesResponse = try await apiClient.request(TMDBEndpoint.search(query: query))
        return response.results
    }

    func fetchMovieDetail(id: Int) async throws -> MovieDetail {
        return try await apiClient.request(TMDBEndpoint.movieDetail(id: id))
    }

    func fetchMovieVideos(id: Int) async throws -> [MovieVideo] {
        let response: MovieVideosResponse = try await apiClient.request(TMDBEndpoint.movieVideos(id: id))
        return response.results
    }

    func fetchMovieCredits(id: Int) async throws -> [CastMember] {
        let response: CreditsResponse = try await apiClient.request(TMDBEndpoint.movieCredits(id: id))
        return response.cast
    }
}
