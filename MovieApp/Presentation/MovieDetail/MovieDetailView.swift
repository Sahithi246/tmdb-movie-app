//
//  Untitled.swift
//  MovieApp
//
//  Created by Sahithi.Mucchala on 17/11/25.
//

import SwiftUI

struct MovieDetailView: View {
    @StateObject var viewModel: MovieDetailViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                if let posterPath = viewModel.detail?.posterPath {
                    RemoteImageView(
                        path: posterPath,
                        width: UIScreen.main.bounds.width,
                        height: 260,
                        cornerRadius: 0
                    )
                }
//                
//                if let trailerKey = viewModel.trailerKey {
//                    YouTubePlayerView(videoKey: trailerKey)
//                        .frame(height: 220)
//                        .cornerRadius(12)
//                        .padding(.horizontal)
//                }

                // Trailer button - opens system video player (Safari / YouTube)
                if let trailerKey = viewModel.trailerKey,
                   let url = URL(string: "https://www.youtube.com/watch?v=\(trailerKey)") {

                    Link(destination: url) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.black.opacity(0.9))
                                .frame(height: 200)

                            VStack(spacing: 8) {
                                Image(systemName: "play.circle.fill")
                                    .font(.system(size: 48))
                                    .foregroundColor(.white)

                                Text("Play trailer")
                                    .foregroundColor(.white)
                                    .font(.subheadline)
                            }
                        }
                        .padding(.horizontal)
                    }
                }

                VStack(alignment: .leading, spacing: 12) {
                    // Title + favorite
                    HStack(alignment: .top) {
                        Text(viewModel.detail?.title ?? "Movie")
                            .font(.title)
                            .fontWeight(.bold)
                            .lineLimit(2)
                        Spacer()
                        Button(action: {
                            viewModel.toggleFavorite()
                        }) {
                            Image(systemName: viewModel.isFavorite ? "star.fill" : "star")
                                .imageScale(.large)
                                .foregroundColor(viewModel.isFavorite ? .yellow : .gray)
                        }
                    }

                    // Duration + rating
                    HStack(spacing: 16) {
                        HStack {
                            Image(systemName: "clock")
                            Text(viewModel.formattedRuntime)
                        }

                        HStack {
                            Image(systemName: "star.fill")
                            Text(viewModel.ratingText)
                        }
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                    // Genres
                    if !viewModel.genresText.isEmpty {
                        Text(viewModel.genresText)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    // Plot
                    if let overview = viewModel.detail?.overview {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Plot")
                                .font(.headline)
                            Text(overview)
                                .font(.body)
                        }
                    }

                    // Cast
                    if !viewModel.cast.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Cast")
                                .font(.headline)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(viewModel.cast.prefix(15)) { member in
                                        VStack {
                                            RemoteImageView(
                                                path: member.profilePath,
                                                width: 70,
                                                height: 90,
                                                cornerRadius: 8
                                            )
                                            Text(member.name)
                                                .font(.caption)
                                                .lineLimit(1)
                                            Text(member.character ?? "")
                                                .font(.caption2)
                                                .foregroundColor(.secondary)
                                                .lineLimit(1)
                                        }
                                        .frame(width: 80)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if viewModel.detail == nil {
                viewModel.load()
            }
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView()
            }
        }
        .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK") { }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
}

