//Copyright (c) 2021 pikachu987 <pikachu77769@gmail.com>
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in
//all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.

import Foundation
import Photos

extension Permission {
    public struct GalleryError: Error {
        public var status: PHAuthorizationStatus
    }
    
    private static func permission(_ handler: @escaping ((Result<PHAuthorizationStatus, GalleryError>) -> Void)) {
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .authorized {
            handler(.success(status))
        } else if status == .denied || status == .restricted {
            handler(.failure(.init(status: status)))
        } else {
            PHPhotoLibrary.requestAuthorization { (status) in
                DispatchQueue.main.async {
                    switch status {
                    case .authorized:
                        handler(.success(status))
                    default:
                        handler(.failure(.init(status: status)))
                    }
                }
            }
        }
    }
    
    @available(iOS 14, *)
    private static func permission(_ accessLevel: PHAccessLevel, handler: @escaping ((Result<PHAuthorizationStatus, GalleryError>) -> Void)) {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        if status == .authorized || status == .limited {
            handler(.success(status))
        } else if status == .denied || status == .restricted {
            handler(.failure(.init(status: status)))
        } else {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { (status) in
                DispatchQueue.main.async {
                    switch status {
                    case .authorized, .limited:
                        handler(.success(status))
                    default:
                        handler(.failure(.init(status: status)))
                    }
                }
            }
        }
    }
    
    
    public static func gallery(_ queue: DispatchQueue? = nil, handler: @escaping ((Result<PHAuthorizationStatus, GalleryError>) -> Void)) {
        if #available(iOS 14, *) {
            if let queue = queue {
                queue.async {
                    self.permission(.readWrite, handler: handler)
                }
            } else {
                self.permission(.readWrite, handler: handler)
            }
        } else {
            if let queue = queue {
                queue.async {
                    self.permission(handler)
                }
            } else {
                self.permission(handler)
            }
        }
    }
    
    @available(iOS 14, *)
    public static func gallery(_ queue: DispatchQueue? = nil, accessLevel: PHAccessLevel = .readWrite, handler: @escaping ((Result<PHAuthorizationStatus, GalleryError>) -> Void)) {
        if let queue = queue {
            queue.async {
                self.permission(accessLevel, handler: handler)
            }
        } else {
            self.permission(accessLevel, handler: handler)
        }
    }
}
