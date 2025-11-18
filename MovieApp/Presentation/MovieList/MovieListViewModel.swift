//
//  Untitled 2.swift
//  MovieApp
//
//  Created by Sahithi.Mucchala on 17/11/25.
//

import Foundation

@MainActor
final class MovieListViewModel: ObservableObject {

    @Published var movies: [MovieSummary] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var searchQuery: String = ""

    let repository: MoviesRepositoryProtocol
    let favoritesStore: FavoritesStoreProtocol
    
    private var searchTask: Task<Void, Never>?

    init(repository: MoviesRepositoryProtocol,
         favoritesStore: FavoritesStoreProtocol) {
        self.repository = repository
        self.favoritesStore = favoritesStore
    }

    /// Loads popular movies when Home screen appears.
    func loadPopular() {
        searchTask?.cancel()
        isLoading = true
        errorMessage = nil

        Task {
            do {
                movies = try await repository.fetchPopularMovies()
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }

    func isFavorite(movie: MovieSummary) -> Bool {
        favoritesStore.isFavorite(movie.id)
    }

    func toggleFavorite(movie: MovieSummary) {
        favoritesStore.toggleFavorite(movie.id)
        objectWillChange.send()   // refresh list row state
    }

    /// Trigger search with debounce to avoid spamming API calls.
    func onSearchQueryChanged(_ text: String) {
        searchTask?.cancel()

        let query = text.trimmingCharacters(in: .whitespacesAndNewlines)
        if query.isEmpty {
            loadPopular()
            return
        }

        searchTask = Task {
            try? await Task.sleep(nanoseconds: 400_000_000) // debounce
            await performSearch(query)
        }
    }

    private func performSearch(_ query: String) async {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }

        do {
            let results = try await repository.searchMovies(query: query)
            await MainActor.run {
                movies = results
                isLoading = false
            }
        } catch {
            await MainActor.run {
                errorMessage = error.localizedDescription
                isLoading = false
            }
        }
    }
}
