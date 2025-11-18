//
//  MovieDetailViewModel.swift
//  MovieApp
//
//  Created by Sahithi.Mucchala on 17/11/25.
//

// Purpose: Fetches detailed movie information using parallel async calls
// for improved performance.

import Foundation

@MainActor
final class MovieDetailViewModel: ObservableObject {
    @Published var detail: MovieDetail?
    @Published var cast: [CastMember] = []
    @Published var trailerKey: String?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isFavorite: Bool = false

    private let movieId: Int
    private let repository: MoviesRepositoryProtocol
    private let favoritesStore: FavoritesStoreProtocol

    init(movieId: Int,
         repository: MoviesRepositoryProtocol,
         favoritesStore: FavoritesStoreProtocol) {
        self.movieId = movieId
        self.repository = repository
        self.favoritesStore = favoritesStore
        self.isFavorite = favoritesStore.isFavorite(movieId)
    }

    /// Loads details, credits, and videos concurrently using async let.
    /// This improves performance by avoiding sequential calls.
    func load() {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                // Run all network calls in parallel
                async let detailTask = repository.fetchMovieDetail(id: movieId)
                async let creditsTask = repository.fetchMovieCredits(id: movieId)
                async let videosTask = repository.fetchMovieVideos(id: movieId)

                let (detail, cast, videos) = try await (detailTask, creditsTask, videosTask)

                self.detail = detail
                self.cast = cast

                if let trailer = videos.first(where: { $0.site == "YouTube" && $0.type == "Trailer" }) {
                    self.trailerKey = trailer.key
                } else {
                    self.trailerKey = nil
                }

                self.isLoading = false
            } catch {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }

    func toggleFavorite() {
        favoritesStore.toggleFavorite(movieId)
        isFavorite = favoritesStore.isFavorite(movieId)
    }

    var formattedRuntime: String {
        guard let runtime = detail?.runtime else { return "–" }
        let hours = runtime / 60
        let minutes = runtime % 60
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }

    var genresText: String {
        detail?.genres.map { $0.name }.joined(separator: ", ") ?? "–"
    }

    var ratingText: String {
        String(format: "%.1f", detail?.voteAverage ?? 0)
    }
}
