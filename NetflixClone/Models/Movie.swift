//
//  Movie.swift
//  NetflixClone
//
//  Created by ZY H on 2023-09-09.
//

import Foundation

struct TrendingMoviesResponses: Codable{
    let results:[Movie]
}


struct Movie: Codable{
    let id:Int
    let media_type:String?
    let original_name:String?
    let original_title:String?
    let poster_path:String?
    let overview:String?
    
}

