//
//  FilmModel.swift
//  CinemaHall
//
//  Created by Vlad Ralovich on 23.01.22.
//

import Foundation

struct FilmModel: Decodable, Hashable {
    var page: Int
    var results: [Results]
    
//    var identifier = UUID()
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(identifier)
//    }
}

struct Results: Decodable, Hashable {
    var id: Int
    var original_title: String
    var overview: String
    var poster_path: String
    var title: String
    var release_date: String
    
//    var identifier = UUID()
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(identifier)
//    }
}
