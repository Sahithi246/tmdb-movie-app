//
//  Untitled.swift
//  MovieApp
//
//  Created by Sahithi.Mucchala on 17/11/25.
//

import SwiftUI

struct RemoteImageView: View {
    let path: String?
    let width: CGFloat?
    let height: CGFloat?
    let cornerRadius: CGFloat
    let contentMode: ContentMode

    init(path: String?,
         width: CGFloat? = nil,
         height: CGFloat? = nil,
         cornerRadius: CGFloat = 0,
         contentMode: ContentMode = .fill) {
        self.path = path
        self.width = width
        self.height = height
        self.cornerRadius = cornerRadius
        self.contentMode = contentMode
    }

    private var url: URL? {
        guard let path = path else { return nil }
        return AppConfig.shared.imageBaseURL.appendingPathComponent(path)
    }

    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                ZStack {
                    Rectangle().opacity(0.1)
                    ProgressView()
                }
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
            case .failure:
                ZStack {
                    Rectangle().opacity(0.1)
                    Image(systemName: "film")
                        .imageScale(.large)
                }
            @unknown default:
                Color.gray
            }
        }
        .frame(width: width, height: height)
        .clipped()
        .cornerRadius(cornerRadius)
    }
}
