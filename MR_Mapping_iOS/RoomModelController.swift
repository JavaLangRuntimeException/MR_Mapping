//
//  RoomModelController.swift
//  MR_Mapping_iOS
//
//  Created by 棚橋柊太 on 2024/04/16.
//

import Foundation
import UIKit

class RoomListViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var rooms: [Room] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        fetchRooms()
    }
    
    func fetchRooms() {
        APIClient.shared.fetchRooms { result in
            switch result {
            case .success(let rooms):
                self.rooms = rooms
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print("Failed to fetch rooms: \(error.localizedDescription)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomCell", for: indexPath)
        let room = rooms[indexPath.row]
        cell.textLabel?.text = room.name
        return cell
    }
}
