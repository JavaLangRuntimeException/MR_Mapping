//
//  RoomListViewModel.swift
//  MR_Mapping_iOS
//
//  Created by 棚橋柊太 on 2024/04/16.
//

import Foundation

class RoomListViewModel: ObservableObject {
    @Published var rooms: [Room] = []
    
    func fetchRooms() {
        APIClient.shared.getRequest(path: "/rooms/") { (result: Result<[Room], Error>) in
            switch result {
            case .success(let rooms):
                DispatchQueue.main.async {
                    self.rooms = rooms
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
