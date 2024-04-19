//
//  Room.swift
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
}
