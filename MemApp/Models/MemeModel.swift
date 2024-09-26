//
//  MemeModel.swift
//  MemApp
//
//  Created by Кирилл Бахаровский on 9/27/24.
//

import Foundation

struct Automeme: Codable {
    var template_id: String
    var username: String
    var password: String
    var text0: String
    
    init(template_id: String, username: String, password: String, text0: String) {
        self.template_id = template_id
        self.username = username
        self.password = password
        self.text0 = text0
    }
}

struct MemeResponse: Codable {
    let success: Bool
    let data: MemeData
}

struct MemeData: Codable {
    let memes: [Meme]
}

struct Meme: Codable {
    let id: String
    let name: String
    let url: String
    let width: Int
    let height: Int
    let boxCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id, name, url, width, height
        case boxCount = "box_count"
    }
}
