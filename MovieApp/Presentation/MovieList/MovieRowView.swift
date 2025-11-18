//
//  Untitled 3.swift
//  MovieApp
//
//  Created by Sahithi.Mucchala on 17/11/25.
//

import SwiftUI

struct MovieRowView: View {
    let movie: MovieSummary
    let isFavorite: Bool
    let onFavoriteTap: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            RemoteImageView(
                path: movie.posterPath,
                width: 80,
                height: 120,
                cornerRadius: 8
            )

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(movie.title)
                        .font(.headline)
                        .lineLimit(2)
                    Spacer()
                    Button(action: onFavoriteTap) {
                        Image(systemName: isFavorite ? "star.fill" : "star")
                            .foregroundColor(isFavorite ? .yellow : .gray)
                    }
                    .buttonStyle(.plain)
                }

                Text(movie.overview)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(3)

                HStack(spacing: 16) {
                    HStack {
                        Image(systemName: "clock")
                        Text("– min") // runtime only available in detail API
                    }
                    .font(.caption)

                    HStack {
                        Image(systemName: "star.fill")
                        Text(String(format: "%.1f", movie.voteAverage))
                    }
                    .font(.caption)
                }
                .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
    }
}
