//
//  PopupView.swift
//  MR_Mapping_iOS
//
//  Created by 棚橋柊太 on 2024/04/19.
//

import Foundation
import SwiftUI

struct PopupView: View {
    var depRoom: Room
    var arrRoom: Room
    
    var body: some View {
        VStack {
            Text("Navigation Details")
                .font(.title)
                .padding()
            
            Text("Departure Room: \(depRoom.name)")
                .font(.headline)
                .padding()
            
            Text("Arrival Room: \(arrRoom.name)")
                .font(.headline)
                .padding()
            
            Button(action: {
                // ポップアップを閉じるアクションを追加
            }) {
                Text("OK")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 10)
    }
}
