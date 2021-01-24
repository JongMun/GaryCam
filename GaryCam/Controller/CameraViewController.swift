//
//  CameraViewController.swift
//  GaryCam
//
//  Created by 정종문 on 2021/01/23.
//

import UIKit
import AVFoundation
import Photos

class CameraViewController: UIViewController {

    var info: MemberTempInfo?
    let cameraController = CameraController()
    
    @IBOutlet fileprivate var previewView: UIView!
    @IBOutlet fileprivate var captureButton: UIButton!
    @IBOutlet fileprivate var toggleCameraButton: UIButton!
    @IBOutlet fileprivate var toggleFlashButton: UIButton!
    @IBOutlet fileprivate var photoModeButton: UIButton!
    @IBOutlet fileprivate var videoModeButton: UIButton!
    
    override var prefersStatusBarHidden: Bool { return true }
}

extension CameraViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Screen : \(UIScreen.main.bounds)")
        styleCaptureButton()
        configureCameraController()
    }
    // 카메라 기능 정의, 시작
    func configureCameraController() {
        cameraController.prepare {
            (error) in
            if let error = error {
                print(error)
            }
            try? self.cameraController.displayPreview(on: self.previewView)
        }
    }
    // 촬영 버튼 스타일링
    func styleCaptureButton() {
        self.captureButton.layer.borderColor = UIColor.black.cgColor
        self.captureButton.layer.borderWidth = 2
        
        self.captureButton.layer.cornerRadius = min(self.captureButton.frame.width, self.captureButton.frame.height) / 2
    }
}

extension CameraViewController {
    // 플래시 모드 액션
    @IBAction func toggleFlashAction(_ sender: UIButton) {
        if cameraController.flashMode == .on {
            cameraController.flashMode = .off
//            toggleFlashButton.setImage(., for: .normal)
            print("Flash Action ON")
        } else {
            cameraController.flashMode = .on
//            toggleFlashButton.setImage(T##image: UIImage?##UIImage?, for: .normal)
            print("Flash Action Off")
        }
    }
    // 사용할 카메라 스위칭 액션
    @IBAction func switchCameraAction(_ sender: UIButton) {
        do {
            try cameraController.switchCameras()
        } catch {
            print(error)
        }
        
        switch cameraController.currentCameraPosition {
        case .some(.front):
//            toggleCameraButton.setImage(<#T##image: UIImage?##UIImage?#>, for: .normal)
            print("Front")
        case .some(.back):
//            toggleCameraButton.setImage(<#T##image: UIImage?##UIImage?#>, for: .normal)
            print("Back")
        case .none:
            print("Other")
            return
        }
    }
    // 사진 촬영 액션
    @IBAction func captureImage(_ sender: UIButton) {
        cameraController.captureImage(completion: {
            (image, error) in
            guard let image = image else {
                print(error ?? "Image Capture Error")
                return
            }
            
            try? PHPhotoLibrary.shared().performChangesAndWait {
                PHAssetChangeRequest.creationRequestForAsset(from: image)
                print("Captured Image")
            }
        })
    }
    
}
