//
//  Brewery.swift
//  BreweryApp
//
//  Created by yc on 2022/02/27.
//

import Foundation

struct Brewery: Codable {
    let id: Int
    let name: String
    let taglineString: String
    var tagline: String {
        var tag = taglineString.replacingOccurrences(of: ". ", with: "#")
        tag = tag.replacingOccurrences(of: ", ", with: "#")
        tag.removeAll { $0 == "." }
        tag = "#" + tag
        return tag
    }
    let description: String
    let abv: Float
    private let image: String?
    var imageURL: URL? { URL(string: image ?? "") }
    let foodPairing: [String]
    let tips: String
    var like: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case taglineString = "tagline"
        case image = "image_url"
        case foodPairing = "food_pairing"
        case tips = "brewers_tips"
        case id, name, description, abv
    }
}
