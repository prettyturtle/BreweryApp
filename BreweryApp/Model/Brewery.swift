//
//  Brewery.swift
//  BreweryApp
//
//  Created by yc on 2022/02/27.
//

import Foundation

struct Brewery: Decodable {
    let name: String
    let tagline: String
    let description: String
    let abv: Float
    private let image: String
    var imageURL: URL? { URL(string: image) }
    let foodPairing: [String]
    let tips: String
    
    enum CodingKeys: String, CodingKey {
        case image = "image_url"
        case foodPairing = "food_pairing"
        case tips = "brewers_tips"
        case name, tagline, description, abv
    }
}
