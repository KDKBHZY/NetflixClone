//
//  Tv.swift
//  NetflixClone
//
//  Created by ZY H on 2023-09-10.
//

import Foundation
struct TrendingTvResponses:Codable{
    let results:[Tv]
}

struct Tv:Codable{
    let id:Int
    let media_type:String?
    let original_name:String?
    let original_title:String?
    let poster_path:String?
    let overview:String?
}
