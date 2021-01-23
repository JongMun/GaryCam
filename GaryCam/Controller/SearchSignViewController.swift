//
//  SearchSignViewController.swift
//  GaryCam
//
//  Created by 정종문 on 2021/01/21.
//

import UIKit
import Alamofire

class SearchSignViewController: UIViewController {

    // Outlet Definition
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var validation: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Keyboard Setting
        self.emailField.keyboardType = .emailAddress
        
        self.nameField.text = "정종문"
        self.emailField.text = "wjdwhdans91@gmail.com"
        
        self.validation.isHidden = true
        
        self.emailField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    // Keyboard Hiding When Other Field Tabbed
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    // Email TextField Event and Validation Check
    @objc func textFieldDidChange(field: UITextField) {
        guard let text = field.text else {
            return
        }
        if text.isValidEmail {
            DispatchQueue.main.async {
                self.validation.isHidden = true
            }
            return
        } else {
            DispatchQueue.main.async {
                self.emailField.becomeFirstResponder()
                self.validation.isHidden = false
            }
        }
    }
    // Return to Login View
    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
