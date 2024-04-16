//
//  Model.swift
//  MR_Mapping_iOS
//
//  Created by 棚橋柊太 on 2024/04/16.
//

import Foundation
struct Room: Codable, Identifiable {
    let id: Int
    let name: String
    let x: Int
    let y: Int
    let user: Int
}

struct Navi: Codable {
    let id: Int
    let depRoom: Int
    let arrRoom: Int
}
