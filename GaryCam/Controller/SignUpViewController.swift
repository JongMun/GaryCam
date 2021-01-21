//
//  SignUpViewController.swift
//  GaryCam
//
//  Created by 정종문 on 2021/01/21.
//

import UIKit
import Alamofire

class SignUpViewController: UIViewController {

    // Outlet Definition
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwdField: UITextField!
    @IBOutlet weak var passwdcheckField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Keyboard Hiding When Other Field Tabbed
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Return to Login View
    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
