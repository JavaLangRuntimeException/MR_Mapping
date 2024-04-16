//
//  ContentView.swift
//  MR_Mapping_iOS
//
//  Created by 棚橋柊太 on 2024/04/16.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = RoomListViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.rooms) { room in
                VStack(alignment: .leading) {
                    Text(room.name)
                        .font(.headline)
                    Text("ID: \(room.id)")
                    Text("X: \(room.x)")
                    Text("Y: \(room.y)")
                    Text("User ID: \(room.user)")
                }
            }
            .navigationTitle("Rooms")
        }
        .onAppear {
            viewModel.fetchRooms()
        }
    }
}
