//
//  AuthServiceError.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 11.05.2026.
//

import Foundation

enum AuthServiceError: Error, Equatable {
    case requiresRecentLogin
    case general(String)
}
