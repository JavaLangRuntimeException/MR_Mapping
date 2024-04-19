//
//  NaviModelContoroller.swift
//  MR_Mapping_iOS
//
//  Created by 棚橋柊太 on 2024/04/19.
//

import Foundation
import UIKit

class NaviListViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var navis: [Navi] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        PostRooms()
    }
    
    func PostVavis() {
        APIClient.shared.PostVavis { result in
            switch result {
            case .success(let navis):
                self.navis = navis
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print("Failed to post navis: \(error.localizedDescription)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return navis.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomCell", for: indexPath)
        let navi = navis[indexPath.row]
        cell.textLabel?.text = navi.name
        return cell
    }
    

}
