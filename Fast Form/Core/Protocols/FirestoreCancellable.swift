//
//  FirestoreCancellable.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 11.05.2026.
//

import Foundation
import FirebaseFirestore


class FirestoreCancellable: ServiceCancellable {
    private var listener: ListenerRegistration?
    
    init(_ listener: ListenerRegistration) {
        self.listener = listener
    }
    
    func cancel() {
        listener?.remove()
        listener = nil
    }
}
