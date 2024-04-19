//
//  Navi.swift
//  MR_Mapping_iOS
//
//  Created by 棚橋柊太 on 2024/04/19.
//

import Foundation
struct Navi: Codable, Identifiable {
    let id = UUID()
    let depRoom: Int
    let arrRoom: Int
    let user: Int
    
    enum CodingKeys: String, CodingKey {
        case depRoom = "dep_room"
        case arrRoom = "arr_room"
        case user
    }
}
