//
//  LoginController.swift
//  GaryCam
//
//  Created by 정종문 on 2021/01/21.
//

import UIKit
import Alamofire

class SignInViewController: UIViewController {

    // Outlet Definition
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwdField: UITextField!
    @IBOutlet weak var searchPWButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        guard let url = URL(string: "http://ec2-54-180-147-251.ap-northeast-2.compute.amazonaws.com/") else {return}
//        let req = AF.request(url)
    }
    
    // Prepare to Seguement to use Data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mainViewSegue" {
            let vc = segue.destination as? MainViewController
            vc?.userTID = sender as? String
        }
    }
    
    // Keyboard Hiding When Other Field Tabbed
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    // Search to Password Action
    @IBAction func searchPWAction(_ sender: Any) {
        self.emailField.text = ""
        self.passwdField.text = ""
    }
    // Sign In Action
    @IBAction func signInAction(_ sender: Any) {
        // 이메일 공백 체크
        guard let userid: String = self.emailField.text,
              userid.isEmpty == false else {
            self.view.messageShow(self, message: "이메일이 공백입니다.")
            self.emailField.becomeFirstResponder()
            return
        }
        // 비밀번호 공백 체크
        guard let passwd: String = self.passwdField.text,
              passwd.isEmpty == false else {
            self.view.messageShow(self, message: "비밀번호가 공백입니다.")
            self.passwdField.becomeFirstResponder()
            return
        }
        
        
    }
    // Sign Up Action
    @IBAction func signUpAction(_ sender: Any) {
        self.emailField.text = ""
        self.passwdField.text = ""
    }

}
