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
    public struct CameraError: Error {
        public var status: AVAuthorizationStatus
    }
    
    private static func permission(_ handler: @escaping ((Result<AVAuthorizationStatus, CameraError>) -> Void)) {
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        if status == .authorized {
            handler(.success(status))
        } else if status == .denied {
            handler(.failure(.init(status: status)))
        } else {
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { (isAccess) in
                DispatchQueue.main.async {
                    if isAccess {
                        handler(.success(.authorized))
                    } else {
                        handler(.failure(.init(status: .denied)))
                    }
                }
                
            }
        }
    }
    
    public static func camera(_ queue: DispatchQueue? = nil, handler: @escaping ((Result<AVAuthorizationStatus, CameraError>) -> Void)) {
        if let queue = queue {
            queue.async {
                self.permission(handler)
            }
        } else {
            self.permission(handler)
        }
    }
}
