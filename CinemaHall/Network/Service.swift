//
//  Service.swift
//  CinemaHall
//
//  Created by Vlad Ralovich on 24.01.22.
//

import Foundation
import UIKit

protocol ServiceProtocol {
    func getDataFilms(urlString: String, onResult: @escaping (Result<FilmModel, Error>) -> Void)
    func getDataTv(urlString: String, onResult: @escaping (Result<TVModel, Error>) -> Void)
    func loadFilm(id: Int, onResult: @escaping (Result<Results, Error>) -> Void)
    func loadTv(id: Int, onResult: @escaping (Result<ResultsTv, Error>) -> Void)
    func loadCastFilm(id: Int, onResult: @escaping (Result<CastFilmModel, Error>) -> Void)
    func loadCastTv(id: Int, onResult: @escaping (Result<CastFilmModel, Error>) -> Void)
    var urlFilms: String {get}
    var tvUrl: String {get}
}

class Service: ServiceProtocol {
    
    let apiKey = "946704c4cea830a60d4c476f0019196d"
    var urlFilms: String
    var tvUrl: String
    
    init() {
        self.urlFilms = "https://api.themoviedb.org/3/discover/movie?api_key=\(apiKey)&language=ru-RUS&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate"
        self.tvUrl = "https://api.themoviedb.org/3/discover/tv?api_key=\(apiKey)&language=ru-RUS&sort_by=popularity.desc&page=1&timezone=America%2FNew_York&include_null_first_air_dates=false&with_watch_monetization_types=flatrate&with_status=0&with_type=0"
    }
    
    func getDataFilms(urlString: String, onResult: @escaping (Result<FilmModel, Error>) -> Void) {
        let session = URLSession.shared
        guard let url = URL(string: urlString) else {return}
        let urlRequest = URLRequest(url: url)

        let dataTask = session.dataTask(with: urlRequest, completionHandler: { data, response, error in
            guard let data = data else {
                onResult(.failure(error!))
                return
            }
            do {
                let response = try JSONDecoder().decode(FilmModel.self, from: data)
                onResult(.success(response))
            } catch(let error) {
                print(error)
                onResult(.failure(error))
            }
        })
        dataTask.resume()
    }
    
    func getDataTv(urlString: String, onResult: @escaping (Result<TVModel, Error>) -> Void) {
        let session = URLSession.shared
        guard let url = URL(string: urlString) else {return}
        let urlRequest = URLRequest(url: url)

        let dataTask = session.dataTask(with: urlRequest, completionHandler: { data, response, error in
            guard let data = data else {
                onResult(.failure(error!))
                return
            }
            do {
                let response = try JSONDecoder().decode(TVModel.self, from: data)
                onResult(.success(response))
            } catch(let error) {
                print(error)
                onResult(.failure(error))
            }
        })
        dataTask.resume()
    }
    
    func loadFilm(id: Int, onResult: @escaping (Result<Results, Error>) -> Void) {
        let session = URLSession.shared
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(id)?api_key=\(apiKey)&language=ru-RUS") else {return}
        let urlRequest = URLRequest(url: url)
        
        let dataTask = session.dataTask(with: urlRequest, completionHandler: { data, response, error in
            guard let data = data else {
                onResult(.failure(error!))
                return
            }
            do {
                let response = try JSONDecoder().decode(Results.self, from: data)
                onResult(.success(response))
            } catch(let error) {
                print(error)
                onResult(.failure(error))
            }
        })
        dataTask.resume()
    }

    func loadTv(id: Int, onResult: @escaping (Result<ResultsTv, Error>) -> Void) {
        let session = URLSession.shared
        guard let url = URL(string: "https://api.themoviedb.org/3/tv/\(id)?api_key=\(apiKey)&language=ru-RUS") else {return}
        let urlRequest = URLRequest(url: url)
        
        let dataTask = session.dataTask(with: urlRequest, completionHandler: { data, response, error in
            guard let data = data else {
                onResult(.failure(error!))
                return
            }
            do {
                let response = try JSONDecoder().decode(ResultsTv.self, from: data)
                onResult(.success(response))
            } catch(let error) {
                print(error)
                onResult(.failure(error))
            }
        })
        dataTask.resume()
    }
    
    func loadCastFilm(id: Int, onResult: @escaping (Result<CastFilmModel, Error>) -> Void) {
        let session = URLSession.shared
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(id)/credits?api_key=\(apiKey)&language=ru-RUS") else {return}
        let urlRequest = URLRequest(url: url)
        
        let dataTask = session.dataTask(with: urlRequest, completionHandler: { data, response, error in
            guard let data = data else {
                onResult(.failure(error!))
                return
            }
            do {
                let response = try JSONDecoder().decode(CastFilmModel.self, from: data)
                onResult(.success(response))
            } catch(let error) {
                print(error)
                onResult(.failure(error))
            }
        })
        dataTask.resume()
    }
    
    func loadCastTv(id: Int, onResult: @escaping (Result<CastFilmModel, Error>) -> Void) {
        let session = URLSession.shared
        guard let url = URL(string: "https://api.themoviedb.org/3/tv/\(id)/credits?api_key=\(apiKey)&language=ru-RUS") else {return}
        let urlRequest = URLRequest(url: url)
    
        let dataTask = session.dataTask(with: urlRequest, completionHandler: { data, response, error in
            guard let data = data else {
                onResult(.failure(error!))
                return
            }
            do {
                let response = try JSONDecoder().decode(CastFilmModel.self, from: data)
                onResult(.success(response))
            } catch(let error) {
                print(error)
                onResult(.failure(error))
            }
        })
        dataTask.resume()
    }
}
