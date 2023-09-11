//
//  Movie.swift
//  NetflixClone
//
//  Created by ZY H on 2023-09-09.
//

import Foundation

struct TrendingTitleResponses: Codable{
    let results:[Title]
}


struct Title: Codable{
    let id:Int
    let media_type:String?
    let original_name:String?
    let original_title:String?
    let poster_path:String?
    let overview:String?
    
}

