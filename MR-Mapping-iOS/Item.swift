//
//  Item.swift
//  MR-Mapping-iOS
//
//  Created by 棚橋柊太 on 2024/06/19.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
