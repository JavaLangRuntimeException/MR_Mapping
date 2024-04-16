//
//  LoginViewController.swift
//  MR_Mapping_iOS
//
//  Created by 棚橋柊太 on 2024/04/16.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        guard let username = usernameTextField.text,
              let password = passwordTextField.text else {
            return
        }
        
        APIClient.shared.login(username: username, password: password) { result in
            switch result {
            case .success(let token):
                UserDefaults.standard.set(token, forKey: "token")
                DispatchQueue.main.async {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let roomListViewController = storyboard.instantiateViewController(withIdentifier: "RoomListViewController")
                    self.navigationController?.pushViewController(roomListViewController, animated: true)
                }
            case .failure(let error):
                print("Login failed: \(error.localizedDescription)")
            }
        }
    }
}
