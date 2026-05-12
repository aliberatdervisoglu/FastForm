//
//  Color+Theme.swift
//  Fast Form
//
//  Created by Ali Berat Dervişoğlu on 21.02.2026.
//

import Foundation
import SwiftUI

extension LinearGradient { //  new characteristic: use as: Lineargradient.brandGradient to use everywhere
    static var brandGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [Color("BrandGradientStart"), Color("BrandGradientEnd")]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
