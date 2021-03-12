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
import AVFoundation

extension Permission {
    public struct MicrophoneError: Error {
        public var status: AVAudioSession.RecordPermission
    }

    private static func permission(_ handler: @escaping ((Result<AVAudioSession.RecordPermission, MicrophoneError>) -> Void)) {
        let status = AVAudioSession.sharedInstance().recordPermission
        if status == .granted {
            handler(.success(status))
        } else if status == .denied {
            handler(.failure(.init(status: status)))
        } else {
            AVAudioSession.sharedInstance().requestRecordPermission { (isGranted) in
                DispatchQueue.main.async {
                    if isGranted {
                        handler(.success(.granted))
                    } else {
                        handler(.failure(.init(status: status)))
                    }
                }
            }
        }
    }

    public static func microphone(_ queue: DispatchQueue? = nil, handler: @escaping ((Result<AVAudioSession.RecordPermission, MicrophoneError>) -> Void)) {
        if let queue = queue {
            queue.async {
                self.permission(handler)
            }
        } else {
            self.permission(handler)
        }
    }
}
