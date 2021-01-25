//
//  CameraControllerError.swift
//  GaryCam
//
//  Created by 정종문 on 2021/01/25.
//

import Foundation

extension CameraController {
    // 예상할 수 있는 에러 정의
    enum CameraControllerError: Swift.Error {
        case captureSessionAlreadyRunning
        case captureSessionIsMissing
        case inputsAreInvalid
        case invalidOperation
        case noCameraAvailable
        case unknown
    }

    public enum CameraPosition {
        case front
        case back
    }
}
