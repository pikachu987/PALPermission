//
//  Permission+audio.swift
//  PALPermission
//
//  Created by Apple on 2021/01/17.
//

import Foundation
import Photos

extension Permission {
    public struct GalleryError: Error {
        public var status: PHAuthorizationStatus
    }
    
    private static func permission(_ handler: @escaping ((Result<Void, GalleryError>) -> Void)) {
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .authorized {
            handler(.success(()))
        } else if status == .denied || status == .restricted {
            handler(.failure(.init(status: status)))
        } else {
            PHPhotoLibrary.requestAuthorization { (status) in
                DispatchQueue.main.async {
                    switch status {
                    case .authorized:
                        handler(.success(()))
                    default:
                        handler(.failure(.init(status: status)))
                    }
                }
            }
        }
    }
    
    @available(iOS 14, *)
    private static func permission(_ accessLevel: PHAccessLevel, handler: @escaping ((Result<Void, GalleryError>) -> Void)) {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        if status == .authorized || status == .limited {
            handler(.success(()))
        } else if status == .denied || status == .restricted {
            handler(.failure(.init(status: status)))
        } else {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { (status) in
                DispatchQueue.main.async {
                    switch status {
                    case .authorized, .limited:
                        handler(.success(()))
                    default:
                        handler(.failure(.init(status: status)))
                    }
                }
            }
        }
    }
    
    
    public static func gallery(_ queue: DispatchQueue? = nil, handler: @escaping ((Result<Void, GalleryError>) -> Void)) {
        if let queue = queue {
            queue.async {
                self.permission(handler)
            }
        } else {
            self.permission(handler)
        }
    }
    
    @available(iOS 14, *)
    public static func gallery(_ queue: DispatchQueue? = nil, accessLevel: PHAccessLevel = .readWrite, handler: @escaping ((Result<Void, GalleryError>) -> Void)) {
        if let queue = queue {
            queue.async {
                self.permission(accessLevel, handler: handler)
            }
        } else {
            self.permission(accessLevel, handler: handler)
        }
    }
}
