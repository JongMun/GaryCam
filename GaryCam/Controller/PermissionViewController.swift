//
//  PermissionViewController.swift
//  GaryCam
//
//  Created by 정종문 on 2021/01/27.
//

import UIKit
import Photos
import AVFoundation

class PermissionViewController: UIViewController {
    @IBOutlet weak var cameraSwitch: UISwitch!
    @IBOutlet weak var audioSwitch: UISwitch!
    @IBOutlet weak var photoSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 어플리케이션이 화면에 보여질때 무조건 호출.
        let notification = NotificationCenter.default
        notification.addObserver(self, selector: #selector(becomeApplication), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc func becomeApplication() {
        AVCaptureDevice.requestAccess(for: .video) {
            ( complete ) in
            DispatchQueue.main.async {
                self.cameraSwitch.isOn = complete
            }
        }
        
        AVAudioSession.sharedInstance().requestRecordPermission() {
            ( complete ) in
            DispatchQueue.main.async {
                self.audioSwitch.isOn = complete
            }
        }
        
        PHPhotoLibrary.requestAuthorization(for: .readWrite) {
            ( complete ) in
            switch complete {
            case .authorized:
                DispatchQueue.main.async {
                    self.photoSwitch.isOn = true
                }
                break;
            case .denied, .notDetermined, .restricted, .limited:
                DispatchQueue.main.async {
                    self.photoSwitch.isOn = false
                }
            @unknown default:
                DispatchQueue.main.async {
                    self.photoSwitch.isOn = false
                }
            }
        }
        
        if permissionCheckAudio() && permissionCheckPhoto() && permissionCheckPhoto() {
            print("AAA")
            guard let loginView = self.storyboard?.instantiateViewController(identifier: "Main") else {
                return
            }
            self.present(loginView, animated: true)
        }
    }
    
    @IBAction func accessRequestBtn(_ sender: UIButton) {
        if permissionCheckAudio() && permissionCheckPhoto() && permissionCheckPhoto() {
            DispatchQueue.main.async {
                guard let loginView = self.storyboard?.instantiateViewController(identifier: "Main") else {
                    return
                }
                self.present(loginView, animated: true)
            }
        } else {
            self.authAlertMessage(msg: "정상적인 작동 위해서는 권한에 대한 모든 요청을 허용해야합니다.")
        }
    }
    
    func permissionCheckVideo() -> Bool {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            print("authorized")
            return true
        case .denied, .notDetermined, .restricted:
            print("denied")
            return false
        @unknown default:
            print("default")
            return false
        }
    }
    func permissionCheckAudio() -> Bool {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .granted:
            print("authorized")
            return true
        case .denied, .undetermined:
            print("denied")
            return false
        @unknown default:
            print("default")
            return false
        }
    }
    func permissionCheckPhoto() -> Bool {
        switch PHPhotoLibrary.authorizationStatus(for: .readWrite) {
        case .authorized:
            print("authorized")
            return true
        case .denied, .notDetermined, .restricted, .limited:
            print("denied")
            return false
        @unknown default:
            print("default")
            return false
        }
    }
    
    func authAlertMessage(msg: String) {
        let alert = UIAlertController(title: "권한요청", message: msg, preferredStyle: UIAlertController.Style.alert)
        let allowAction = UIAlertAction(title: "이동", style: UIAlertAction.Style.default) {
            ( action ) in
            if let settings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settings, options: [:], completionHandler: nil)
            }
        }
        let deniedAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.default) {
            ( action ) in
            UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
        }
        
        alert.addAction(allowAction)
        alert.addAction(deniedAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}
