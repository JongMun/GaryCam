//
//  SearchSignViewController.swift
//  GaryCam
//
//  Created by 정종문 on 2021/01/21.
//

import UIKit
import Alamofire

class SearchSignViewController: UIViewController {
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var validation: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 키보드 세팅
        self.emailField.keyboardType = .emailAddress
        self.nameField.text = "정종문"
        self.emailField.text = "wjdwhdans91@gmail.com"
        
        self.validation.isHidden = true
        
        self.emailField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    // 다른 뷰 터치 시 키보드 숨김
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    // 이메일 형식 확인
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
    // 로그인 화면으로 이동
    @IBAction func closeButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    // 비밀번호 찾기 액션
    @IBAction func searchAction(_ sender: UIButton) {
        // 이름 공백 체크
        guard let name: String = self.nameField.text,
              name.isEmpty == false else {
            self.view.messageShow(self, message: "이름이 공백입니다.")
            self.nameField.becomeFirstResponder()
            return
        }
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
    }
}
