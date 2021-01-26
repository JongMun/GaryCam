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
    
    override var prefersStatusBarHidden: Bool { return true }
    
    var fetchResult: PHFetchResult<PHAssetCollection>!
    let cachingImageManager: PHCachingImageManager = PHCachingImageManager()
}

extension CameraViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        styleCaptureButton()
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
    func styleCaptureButton() {
        self.captureButton.layer.borderColor = UIColor.black.cgColor
        self.captureButton.layer.borderWidth = 2
        self.captureButton.layer.cornerRadius = min(self.captureButton.frame.width, self.captureButton.frame.height) / 2
        
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
        print("Tapped Image View")
        requestPhotosPermissionCheck()
        let tappedImage = tapGestureRecognizer.view as! UIImageView

        // Your action
    }
    func showLibrary () {
//        imageController.delegate = ImageViewController() as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
//        imageController.allowsEditing = false
//        imageController.sourceType = .photoLibrary
//        imageController.mediaTypes = UIImagePickerController.availableMediaTypes (for : .photoLibrary)!
//        present(ImageViewController(), animated : true, 완료 : nil)
        
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

extension CameraViewController: UIImagePickerControllerDelegate {
    func requestPhotosPermissionCheck() {
        let photoAuthorizationStatusStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatusStatus {
        case .authorized:
            print("권한이 승인되었습니다.")
            self.getPhoto()
        case .denied:
            print("권한이 거부되었습니다.")
        case .notDetermined:
            print("권한에 대한 승인을 아직 안하셨습니다.")
            PHPhotoLibrary.requestAuthorization() {
                (status) in
                switch status {
                case .authorized:
                    print("권한이 승인되었습니다.")
                    self.getPhoto()
                case .denied:
                    print("권한이 거부되었습니다.")
                    break
                default:
                    break
                }
            }
        case .restricted:
            print("권한을 부여할 수 없습니다.")
        default:
            break
        }
    }
    func getPhoto() {
        let albums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .smartAlbumTimelapses, options: .none)
        let a = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumRecentlyAdded, options: nil)
        let collection = albums.object(at: 0)
        let imageManager = PHImageManager()
        let options = PHFetchOptions()
        
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let allPhotos = PHAsset.fetchAssets(in: collection, options: options)
        
        if let asset = allPhotos.firstObject {
            print("Photo : \(asset)")
        } else {
            print("FUCK")
        }
    }
}
