//
//  Permission+audio.swift
//  PALPermission
//
//  Created by Apple on 2021/01/17.
//

import Foundation
import Photos

extension Permission {
    public struct CameraError: Error {
        public var status: AVAuthorizationStatus
    }
    
    private static func permission(_ handler: @escaping ((Result<Void, CameraError>) -> Void)) {
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        if status == .authorized {
            handler(.success(()))
        } else if status == .denied {
            handler(.failure(.init(status: status)))
        } else {
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { (isAccess) in
                DispatchQueue.main.async {
                    if isAccess {
                        handler(.success(()))
                    } else {
                        handler(.failure(.init(status: .denied)))
                    }
                }
                
            }
        }
    }
    
    public static func camera(_ queue: DispatchQueue? = nil, handler: @escaping ((Result<Void, CameraError>) -> Void)) {
        if let queue = queue {
            queue.async {
                self.permission(handler)
            }
        } else {
            self.permission(handler)
        }
    }
}
