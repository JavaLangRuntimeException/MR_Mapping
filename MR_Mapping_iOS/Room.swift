import Foundation
struct Room: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let x: Int
    let y: Int
}
