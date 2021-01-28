//
//  Permisstion.swift
//  GaryCam
//
//  Created by 정종문 on 2021/01/27.
//

import Photos
import Foundation
import AVFoundation

// Permission List : Photos, Camera, Location Service, Microphone
class CameraPermission {
    private var _isAccess: Bool = false
    
    var isAccess: Bool {
        get {
            AVCaptureDevice.requestAccess(for: .video) {
                ( response: Bool ) in
                self._isAccess = response
            }
            return _isAccess
        }
    }
}

class AudioPermission {
    private var _isAccess: Bool = false
    
    var isAccess: Bool {
        get {
            return _isAccess
        }
    }
    
    init() {
        AVAudioSession.sharedInstance().requestRecordPermission {
            ( response: Bool ) in
            self._isAccess = response
        }
    }
}

class PhotosPermission {
    private var _isAccess: Bool = false
    
    var isAccess: Bool {
        get {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) {
                (status) in
                switch status {
                case .authorized:
                    self._isAccess = true
                case .denied:
                    self._isAccess = false
                default:
                    self._isAccess = false
                }
            }
            return _isAccess
        }
    }
}
