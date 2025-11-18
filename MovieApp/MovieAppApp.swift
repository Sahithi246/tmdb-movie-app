//
//  MovieAppApp.swift
//  MovieApp
//
//  Created by Sahithi.Mucchala on 17/11/25.
//

import SwiftUI

@main
struct MovieAppApp: App {
    private let repository: MoviesRepositoryProtocol
    @StateObject private var favoritesStore = FavoritesStore()

    init() {
        let apiClient = TMDBAPIClient(appConfig: AppConfig.shared)
        self.repository = MoviesRepository(apiClient: apiClient)
    }

    var body: some Scene {
        WindowGroup {
            MovieListView(
                viewModel: MovieListViewModel(
                    repository: repository,
                    favoritesStore: favoritesStore
                ),
                repository: repository,
                favoritesStore: favoritesStore
            )
            .environmentObject(favoritesStore)
        }
    }
}


