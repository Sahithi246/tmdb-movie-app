//
//  AppConfig.swift
//  MovieApp
//
//  Created by Sahithi.Mucchala on 17/11/25.
//
//  Purpose: Centralized configuration for API endpoints & image base URL.
//  Why: Ensures all URLs and API keys are managed in one place for easy future maintenance.
//

import Foundation

struct AppConfig {
    static let shared = AppConfig()  // Singleton config to avoid duplication

    // API key split into two parts for light security (not full security, but prevents quick scanning)
    private let tmdbKeyPart1 = "8e01725e41f64"
    private let tmdbKeyPart2 = "ef6bf29e1de8a59a36d"
    let apiKey: String

    // Base URLs for networking
    let baseURL: URL
    let imageBaseURL: URL

    private init() {
        self.apiKey = tmdbKeyPart1 + tmdbKeyPart2
        self.baseURL = URL(string: "https://api.themoviedb.org/3")!
        self.imageBaseURL = URL(string: "https://image.tmdb.org/t/p/w500")!
    }
}
