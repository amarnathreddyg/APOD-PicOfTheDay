//
//  Apod.swift
//  APOD
//
//  Created by Amarnath Gopireddy on 4/14/21.
//

import Foundation

protocol PicOfTheDay {
    var imageUrl:String { get }
    var description:String { get }
    var title:String { get }
    var date:String { get }
}

struct Apod: PicOfTheDay, Codable {
    let imageUrl:String
    let description:String
    let title:String
    let date:String
    private enum DataKeys: String, CodingKey {
        case imageUrl = "url"
        case description = "explanation"
        case title
        case date
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DataKeys.self)
        self.imageUrl = try container.decode(String.self, forKey: .imageUrl)
        self.description = try container.decode(String.self, forKey: .description)
        self.title = try container.decode(String.self, forKey: .title)
        self.date = try container.decode(String.self, forKey: .date)
    }
}
