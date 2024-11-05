//
//  Tool.swift
//  PokerTitanQuest
//
//  Created by jin fu on 2024/11/5.
//

import UIKit

func showAlert(ttl: String, msg: String, Button: String, VC: UIViewController) {
    
    let Alert = UIAlertController(title: ttl, message: msg, preferredStyle: .alert)
    let Action = UIAlertAction(title: Button, style: .default)
    Alert.addAction(Action)
    VC.present(Alert, animated: true)
    
}
