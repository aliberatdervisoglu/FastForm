
import SwiftUI

struct BigButtonView: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(LinearGradient.brandGradient)
                Text(title)
                    .font(Font.system(size: 20, weight: .bold, design: .default))
                    .foregroundStyle(Color.white)
            }
        }
        .frame(height: 50)
        .padding(.horizontal)
    }
}

#Preview {
    BigButtonView(title: "Sample button title", action: {})
}
