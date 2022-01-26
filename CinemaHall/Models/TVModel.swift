//
//  TVModel.swift
//  CinemaHall
//
//  Created by Vlad Ralovich on 24.01.22.
//

import Foundation

struct TVModel: Decodable, Hashable {
    var page: Int
    var results: [ResultsTv]
}

struct ResultsTv: Decodable, Hashable {
    var id: Int
    var original_name: String
    var overview: String
//    var poster_path: String
    var name: String
    var first_air_date: String
}
