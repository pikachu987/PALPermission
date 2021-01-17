//
//  Permission+audio.swift
//  PALPermission
//
//  Created by Apple on 2021/01/17.
//

import Foundation
import AVKit

extension Permission {
    public struct AudioError: Error {
        public var status: AVAudioSession.RecordPermission
    }

    private static func permission(_ handler: @escaping ((Result<Void, AudioError>) -> Void)) {
        let status = AVAudioSession.sharedInstance().recordPermission
        switch status {
        case .granted:
            handler(.success(()))
        case .denied:
            handler(.failure(.init(status: status)))
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission { (granted) in
                DispatchQueue.main.async {
                    if granted {
                        handler(.success(()))
                    } else {
                        handler(.failure(.init(status: .denied)))
                    }
                }
            }
        default:
            handler(.failure(.init(status: .denied)))
        }
    }

    public static func audio(_ queue: DispatchQueue? = nil, handler: @escaping ((Result<Void, AudioError>) -> Void)) {
        if let queue = queue {
            queue.async {
                self.permission(handler)
            }
        } else {
            self.permission(handler)
        }
    }
}
