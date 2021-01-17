//
//  Permission+audio.swift
//  PALPermission
//
//  Created by Apple on 2021/01/17.
//

import Foundation
import Contacts

extension Permission {
    public struct ContactError: Error {
        public var status: CNAuthorizationStatus
    }

    private static func permission(_ handler: @escaping ((Result<Void, ContactError>) -> Void)) {
        let status = CNContactStore.authorizationStatus(for: .contacts)
        if status == .authorized {
            handler(.success(()))
        } else if status == .denied {
            handler(.failure(.init(status: status)))
        } else {
            let store = CNContactStore()
            store.requestAccess(for: .contacts) { (isGranted, error) in
                DispatchQueue.main.async {
                    if isGranted {
                        handler(.success(()))
                    } else {
                        handler(.failure(.init(status: status)))
                    }
                }
            }
        }
    }

    public static func contact(_ queue: DispatchQueue? = nil, handler: @escaping ((Result<Void, ContactError>) -> Void)) {
        if let queue = queue {
            queue.async {
                self.permission(handler)
            }
        } else {
            self.permission(handler)
        }
    }
}
