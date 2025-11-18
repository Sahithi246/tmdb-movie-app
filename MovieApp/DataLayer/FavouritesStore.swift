//
//  FavoritesStore.swift
//  MovieApp
//
//  Created by Sahithi.Mucchala on 17/11/25.
//

// Purpose: Manage favorite movie persistence using UserDefaults.

import Foundation

protocol FavoritesStoreProtocol: AnyObject {
    var favorites: Set<Int> { get }
    func isFavorite(_ id: Int) -> Bool
    func toggleFavorite(_ id: Int)
}

final class FavoritesStore: ObservableObject, FavoritesStoreProtocol {
    @Published private(set) var favorites: Set<Int> = []
    private let storeKey = "favorite_movies"

    init() {
        load()
    }

    func isFavorite(_ id: Int) -> Bool {
        favorites.contains(id)
    }

    func toggleFavorite(_ id: Int) {
        if favorites.contains(id) {
            favorites.remove(id)
        } else {
            favorites.insert(id)
        }
        save()
    }

    private func save() {
        // Saves set as array to UserDefaults for persistence after relaunch
        UserDefaults.standard.set(Array(favorites), forKey: storeKey)
    }

    private func load() {
        if let saved = UserDefaults.standard.array(forKey: storeKey) as? [Int] {
            favorites = Set(saved)
        }
    }
}

