//
//  YoutubeResponse.swift
//  NetflixClone
//
//  Created by ZY H on 2023-09-12.
//

import Foundation

struct YoutubeSearchResult:Codable{
    let items:[VideoElement]
}

struct VideoElement:Codable{
    let id:IdVideoElement
}

struct IdVideoElement:Codable{
    let kind:String
    let videoId:String
}
