**TMDb Movie App (iOS – SwiftUI)**
This is an iOS application built using SwiftUI that integrates with The Movie Database (TMDb) API. The app allows users to browse popular movies, search movies by title, view detailed movie information, watch trailers, and mark movies as favorites with local persistence.

**Features**

Display list of popular movies with title, rating, and poster

Movie detail screen with title, plot, genres, cast, duration, and rating

Trailer playback via direct YouTube URL launch

Search functionality using TMDb search API

Favorite/unfavorite movies from list and detail screens

Favorites persistence using UserDefaults

Clean MVVM architecture with separate networking and image loader

Improved UI design on home screen for better visual experience


**Setup Instructions**

Clone the repository

Open the project using Xcode (.xcodeproj)

No external dependencies or pods required

Build and run on any iOS 17+ device or simulator


**TMDb API Key**

The app uses a simple multi-part key combination for readability/obfuscation:

private let tmdbKeyPart1 = "8e01725e41f64"

private let tmdbKeyPart2 = "ef6bf29e1de8a59a36"

let apiKey = tmdbKeyPart1 + tmdbKeyPart2

**Implementation Details**

Built entirely using SwiftUI

MVVM architecture with separate models, services, and view models

Network layer using async/await and URLSession

Poster images loaded using a reusable image component

Favorites stored simply using UserDefaults

Trailer opened using YouTube URL via UIApplication.shared.open(...)

**Assumptions**

The /movie/popular endpoint does not return runtime, and making a separate API call for each movie on the home screen would cause unnecessary load and latency. Therefore, runtime is shown only on the detail screen.

TMDb trailer keys link to YouTube videos, and since direct streaming URLs are not available for use with native players, opening the YouTube link externally is the most reliable and dependency-free approach.

Home screen includes additional movie details to create a better-looking and more informative UI, even though it was not strictly mandated.

**Known Limitations**

Offline mode is not yet supported

Favorites are stored locally and not synced across devices

Video playback is external and not embedded inside the app

Minimal loading/error UI due to time focus on core requirements


**Possible Future Improvements**

Add YouTube iOS SDK for inline trailer playback

Introduce CoreData or file-based caching

Add pagination and pull-to-refresh

Implement unit testing and UI test coverage

Show watchlist vs favorites separately

Add skeleton UI for loading states

<img width="600" height="1000" alt="Simulator Screenshot - iPhone 16 Pro - 2025-11-17 at 19 54 58" src="https://github.com/user-attachments/assets/17b4ba73-717f-4b45-8275-73f5bcaa38fc" />


