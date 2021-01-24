//
//  LoginController.swift
//  GaryCam
//
//  Created by 정종문 on 2021/01/21.
//

import UIKit
import Alamofire

class SignInViewController: UIViewController, UITextFieldDelegate {

    // Outlet Definition
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwdField: UITextField!
    @IBOutlet weak var searchPWButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var validation: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Keyboard Setting
        self.emailField.keyboardType = .emailAddress
        
        self.emailField.text = "smat91@naver.com"
        self.passwdField.text = "wjdwhdans"
        
        self.validation.isHidden = true
        
        self.emailField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    // Prepare to Seguement to use Data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mainViewSegue" {
            let vc = segue.destination as? MainViewController
            vc?.info = sender as? MemberTempInfo
        }
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
    // Search to Password Action
    @IBAction func searchPWAction(_ sender: Any) {
        self.emailField.text = ""
        self.passwdField.text = ""
    }
    // Sign In Action
    @IBAction func signInAction(_ sender: Any) {
        // 이메일 공백 체크
        guard let email: String = self.emailField.text,
              email.isEmpty == false else {
            self.view.messageShow(self, message: "이메일이 공백입니다.")
            self.emailField.becomeFirstResponder()
            return
        }
        if !self.validation.isHidden {
            self.view.messageShow(self, message: "이메일 형식을 확인해주세요.")
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
        // 비밀번호 암호화
        let encryptPW = DataExtension().passwordSHA256Enc(passwd: passwd)
        // 통신 파라미터 정의
        let param: [String:String] = ["email":email, "passwd":encryptPW]
        // Alamofire를 통해 통신
        HttpRequest().getUserTempInfo(param: param) {
            (completion) in
            guard let data = completion else {
                return
            }
            self.view.messageShow(self, message: "로그인되었습니다.")
            self.performSegue(withIdentifier: "mainViewSegue", sender: data)
        }
        self.view.endEditing(true)
    }
    // Sign Up Action
    @IBAction func signUpAction(_ sender: Any) {
        self.emailField.text = ""
        self.passwdField.text = ""
    }

}
