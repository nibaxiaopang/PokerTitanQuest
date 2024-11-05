//
//  feedback.swift
//  PokerTitanQuest
//
//  Created by jin fu on 2024/11/5.
//

import UIKit
import IQKeyboardManagerSwift

class TitanFeedbackViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        IQKeyboardManager.shared.enable = true
    }
    
    @IBAction func btn(_ sender: Any) {
        let alert:UIAlertController = UIAlertController(title: "Message", message: "successfully", preferredStyle: UIAlertController.Style.alert)
        
        let Ok = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default)
        alert.addAction(Ok)
        
       present(alert, animated: false)
    }
    
    
    @IBAction func back(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    

}
