//
//  Untitled 4.swift
//  MovieApp
//
//  Created by Sahithi.Mucchala on 17/11/25.
//

import Foundation

struct CreditsResponse: Decodable {
    let id: Int?
    let cast: [CastMember]
}

struct CastMember: Decodable, Identifiable {
    let id: Int
    let name: String
    let character: String?
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case character
        case profilePath = "profile_path"
    }
}
