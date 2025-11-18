//
//  Untitled.swift
//  MovieApp
//
//  Created by Sahithi.Mucchala on 17/11/25.
//

import SwiftUI

struct MovieListView: View {
    @StateObject var viewModel: MovieListViewModel
    let repository: MoviesRepositoryProtocol
    let favoritesStore: FavoritesStoreProtocol

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Popular Movies")
                .searchable(text: $viewModel.searchQuery, prompt: "Search movies")
                .onChange(of: viewModel.searchQuery) { _, newValue in
                    viewModel.onSearchQueryChanged(newValue)
                }
                .onAppear {
                    if viewModel.movies.isEmpty {
                        viewModel.loadPopular()
                    }
                }
        }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading && viewModel.movies.isEmpty {
            ProgressView("Loading…")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if let error = viewModel.errorMessage, viewModel.movies.isEmpty {
            VStack(spacing: 8) {
                Text("Something went wrong")
                Text(error).font(.caption).foregroundColor(.red)
                Button("Retry") { viewModel.loadPopular() }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            List(viewModel.movies) { movie in
                NavigationLink {
                    MovieDetailView(
                        viewModel: MovieDetailViewModel(
                            movieId: movie.id,
                            repository: repository,
                            favoritesStore: favoritesStore
                        )
                    )
                } label: {
                    MovieRowView(
                        movie: movie,
                        isFavorite: viewModel.isFavorite(movie: movie),
                        onFavoriteTap: { viewModel.toggleFavorite(movie: movie) }
                    )
                }
            }
            .listStyle(.plain)
        }
    }
}
