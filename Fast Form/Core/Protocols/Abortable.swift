//
//  Abortable.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 11.05.2026.
//

import Foundation

protocol Abortable {
    func cancel()
}

struct AnyAbortable: Abortable {
    private let _cancel: () -> Void

    init(cancel: @escaping () -> Void) {
        _cancel = cancel
    }

    func cancel() {
        _cancel()
    }
}
