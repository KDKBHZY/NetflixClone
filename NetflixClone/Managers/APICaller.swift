//
//  APICaller.swift
//  NetflixClone
//
//  Created by ZY H on 2023-09-09.
//

import Foundation
struct constants{
    static let APIKey = "eb44f0fcf658ab1c46018fcee798becb"
    static let baseUrl = "https://api.themoviedb.org"
}

enum APIError:Error{
    case failedtoGetData
}

class APICaller{
    static let shared = APICaller()
    
    func getTrendingMovies(completion:@escaping (Result<[Title],Error>) -> Void){
        guard let url = URL(string: "\(constants.baseUrl)/3/trending/movie/day?api_key=\(constants.APIKey)&language=en-US") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else{
                return
            }
            do{
                let results = try JSONDecoder().decode(TrendingTitleResponses.self, from: data)
                completion(.success(results.results))
                
            }catch{
                completion(.failure(APIError.failedtoGetData))
            }
        }
        task.resume()
    }
    
    func getTrendingTv(completion:@escaping (Result<[Title],Error>) -> Void){
        guard let url = URL(string: "\(constants.baseUrl)/3/trending/tv/day?api_key=\(constants.APIKey)&language=en-US") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else{
                return
            }
            do{
                let results = try JSONDecoder().decode(TrendingTitleResponses.self, from: data)
                completion(.success(results.results))
                
            }catch{
                completion(.failure(APIError.failedtoGetData))
            }
        }
        task.resume()
    }
    
    func getUpcomingMovies(completion:@escaping (Result<[Title],Error>) -> Void){
        guard let url = URL(string: "\(constants.baseUrl)/3/movie/upcoming?api_key=\(constants.APIKey)&language=en-US") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else{
                return
            }
            do{
                let results = try JSONDecoder().decode(TrendingTitleResponses.self, from: data)
                completion(.success(results.results))
                
            }catch{
                completion(.failure(APIError.failedtoGetData))
            }
        }
        task.resume()
    }
    
    func getPopular(completion:@escaping (Result<[Title],Error>) -> Void){
        guard let url = URL(string: "\(constants.baseUrl)/3/movie/popular?api_key=\(constants.APIKey)&language=en-US") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else{
                return
            }
            do{
                let results = try JSONDecoder().decode(TrendingTitleResponses.self, from: data)
                completion(.success(results.results))
                
            }catch{
                completion(.failure(APIError.failedtoGetData))
            }
        }
        task.resume()
    }
    
    func getTopRated(completion:@escaping (Result<[Title],Error>) -> Void){
        guard let url = URL(string: "\(constants.baseUrl)/3/movie/top_rated?api_key=\(constants.APIKey)&language=en-US") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else{
                return
            }
            do{
                let results = try JSONDecoder().decode(TrendingTitleResponses.self, from: data)
                completion(.success(results.results))
                
            }catch{
                completion(.failure(APIError.failedtoGetData))
            }
        }
        task.resume()
    }
    
    func getDiscoverMovies(completion:@escaping (Result<[Title],Error>) -> Void){
        guard let url = URL(string: "\(constants.baseUrl)/3/discover/movie?api_key=\(constants.APIKey)&language=en-US") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else{
                return
            }
            do{
                let results = try JSONDecoder().decode(TrendingTitleResponses.self, from: data)
                completion(.success(results.results))
                
            }catch{
                completion(.failure(APIError.failedtoGetData))
            }
        }
        task.resume()
    }
    
}
