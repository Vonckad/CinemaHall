//
//  CastFilmModel.swift
//  CinemaHall
//
//  Created by Vlad Ralovich on 29.01.22.
//

import Foundation

/*
 "id": 634649,
     "cast": [
         {
             "adult": false,
             "gender": 2,
             "id": 1136406,
             "known_for_department": "Acting",
             "name": "Tom Holland",
             "original_name": "Tom Holland",
             "popularity": 143.674,
             "profile_path": "/2qhIDp44cAqP2clOgt2afQI07X8.jpg",
             "cast_id": 1,
             "character": "Peter Parker / Spider-Man",
             "credit_id": "5d8e28d38289a0000fcc32f9",
             "order": 0
 */

struct CastFilmModel: Decodable, Hashable {
    var id: Int?
    var cast: [ResultCastFilm]
}

struct ResultCastFilm: Decodable, Hashable {
    var id: Int?
    var name: String?
    var profile_path: String?
    var character: String?
}
