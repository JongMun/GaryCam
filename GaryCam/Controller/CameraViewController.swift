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
    let imageController = UIImagePickerController()

    @IBOutlet fileprivate var previewView: UIView!
    @IBOutlet fileprivate var captureButton: UIButton!
    @IBOutlet fileprivate var toggleCameraButton: UIButton!
    @IBOutlet fileprivate var toggleFlashButton: UIButton!
    @IBOutlet fileprivate var albumImage: UIImageView!
    @IBOutlet fileprivate var videoModeButton: UIButton!
    
    @IBOutlet fileprivate var etc: UIButton!
    
    override var prefersStatusBarHidden: Bool { return true }
    
    var imageArray = [UIImage]()
}

extension CameraViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 추후 기능 추가
        etc.isHidden = true
        
        getOnePhoto()
        styleButton()
        styleAlbumImageView() 
        configureCameraController()
        addTapGetureAction()
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
    func styleButton() {
        self.toggleCameraButton.tintColor = UIColor.init(hexString: "#cc66ff")
        self.toggleFlashButton.tintColor = UIColor.init(hexString: "#cc66ff")
    }
    // 앨범 이미지뷰 스타일링
    func styleAlbumImageView() {
        self.albumImage.layer.borderColor = UIColor.init(hexString: "#cc66ff").cgColor
        self.albumImage.layer.borderWidth = 2
        self.albumImage.layer.cornerRadius = min(self.albumImage.frame.width, self.albumImage.frame.height) / 2
    }
    // 버튼 외 탭 액션 연결
    func addTapGetureAction() {
        // 이미지뷰 탭 액션 연결
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showLibrary(tapGestureRecognizer:)))
        albumImage.isUserInteractionEnabled = true
        albumImage.addGestureRecognizer(tapGestureRecognizer)
    }
    // 앨범 이미지 뷰 클릭 액션
    @objc func showLibrary(tapGestureRecognizer: UITapGestureRecognizer)
    {
        guard let cameraView = self.storyboard?.instantiateViewController(identifier: "PhotoCollection") else {
            return
        }
        self.present(cameraView, animated: true)
    }
    func getOnePhoto() {
        let manager = PHImageManager.default()
        
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        options.deliveryMode = .opportunistic
                
        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: nil)
        
        if fetchResult.count > 0 {
            for i in 0..<fetchResult.count {
                manager.requestImage(for: fetchResult.object(at: i), targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: options) {
                    (image, error) in
                    self.imageArray.append(image!)
                }
            }
            imageArray.reverse()
            
            DispatchQueue.main.async {
                self.albumImage.image = self.imageArray[0]
            }
        } else {
            print("You got no photos!")
        }
    }
}

extension CameraViewController {
    // 플래시 모드 액션
    @IBAction func toggleFlashAction(_ sender: UIButton) {
        if cameraController.flashMode == .on {
            cameraController.flashMode = .off
            toggleFlashButton.setImage(#imageLiteral(resourceName: "Flash Off Icon"), for: .normal)
        } else {
            cameraController.flashMode = .on
            toggleFlashButton.setImage(#imageLiteral(resourceName: "Flash On Icon"), for: .normal)
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
            toggleCameraButton.setImage(#imageLiteral(resourceName: "Camera Front Icon"), for: .normal)
        case .some(.back):
            toggleCameraButton.setImage(#imageLiteral(resourceName: "Camera Back Icon"), for: .normal)
        case .none:
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
            // Photokit 사용 이미지 저장
            try? PHPhotoLibrary.shared().performChangesAndWait {
                PHAssetChangeRequest.creationRequestForAsset(from: image)
                // 앨범 뷰 이미지 수시로 교체
                self.albumImage.image = image
            }
        })
    }
}
