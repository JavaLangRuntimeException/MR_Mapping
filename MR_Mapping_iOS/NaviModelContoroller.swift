//
//  NaviModelContoroller.swift
//  MR_Mapping_iOS
//
//  Created by 棚橋柊太 on 2024/04/19.
//

import Foundation
import UIKit

class NaviListViewController: UIViewController, UITableViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var arrRoomPicker: UIPickerView!
    @IBOutlet weak var depRoomPicker: UIPickerView!
    @IBOutlet weak var sendButton: UIButton!
    
    var navis: [Navi] = []
    var rooms: [Room] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        arrRoomPicker.delegate = self
        depRoomPicker.delegate = self
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        fetchNavis()
        fetchRooms()
    }
    
    func fetchNavis() {
        APIClient.shared.fetchNavis { result in
            switch result {
            case .success(let navis):
                self.navis = navis
            case .failure(let error):
                print("Failed to fetch navis: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchRooms() {
        APIClient.shared.fetchRooms { result in
            switch result {
            case .success(let rooms):
                self.rooms = rooms
                DispatchQueue.main.async {
                    self.arrRoomPicker.reloadAllComponents()
                    self.depRoomPicker.reloadAllComponents()
                }
            case .failure(let error):
                print("Failed to fetch rooms: \(error.localizedDescription)")
            }
        }
    }
    
    @objc func sendButtonTapped() {
        let arrRoomIndex = arrRoomPicker.selectedRow(inComponent: 0)
        let depRoomIndex = depRoomPicker.selectedRow(inComponent: 0)
        
        if arrRoomIndex >= 0 && depRoomIndex >= 0 {
            let arrRoom = rooms[arrRoomIndex]
            let depRoom = rooms[depRoomIndex]
            
            postNavi(depRoomId: depRoom.id, arrRoomId: arrRoom.id, userId: 1) // ユーザーIDは適切な値に置き換えてください
        }
    }
    
    func postNavi(depRoomId: Int, arrRoomId: Int, userId: Int) {
        APIClient.shared.postNavi(depRoomId: depRoomId, arrRoomId: arrRoomId, userId: userId) { result in
            switch result {
            case .success:
                self.fetchNavis()
            case .failure(let error):
                print("Failed to post navi: \(error.localizedDescription)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return navis.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NaviCell", for: indexPath)
        let navi = navis[indexPath.row]
        cell.textLabel?.text = "From Room \(navi.depRoom) to Room \(navi.arrRoom)"
        return cell
    }
}
