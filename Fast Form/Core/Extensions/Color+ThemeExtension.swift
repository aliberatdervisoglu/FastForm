
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
