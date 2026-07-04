
import SwiftUI

@MainActor
struct MainView: View {
    @State private var draftForm: FormModel = .init(
        id: UUID().uuidString,
        title: "",
        ownerId: "",
        explanation: "",
        questionList: [],
        createDate: Date().timeIntervalSince1970,
        isAnonymus: false
    )

    @State var viewModel: MainViewViewModel
    @State private var selectedTab: Int = 0
    var body: some View {
        Group {
            if viewModel.isLoading {
                LoadingPlaygroundView()
                    .transition(.opacity)
            } else if !viewModel.currentUserID.isEmpty {
                mainTabView
                    .transition(.opacity.combined(with: .scale(scale: 0.98)))
            } else {
                LoginView()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 1.5), value: viewModel.isLoading)
//        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: viewModel.isLoading)
    }

    var mainTabView: some View {
        TabView(selection: $selectedTab) {
            FormListView(userId: viewModel.currentUserID)
                .tabItem {
                    Label("Form List", systemImage: "list.dash")
                }
                .tag(0)
            ResponseFormView()
                .tabItem {
                    Label("Responses", systemImage: "list.bullet.clipboard")
                }
                .tag(1)
            FormBuilderView(formToEdit: draftForm, tabselection: $selectedTab)
                .tabItem {
                    Label("Form Builder", systemImage: "clipboard")
                }
                .tag(2)
            ProfileView(takenUserID: "uBTFyEMizhYmsjIZBGYkkRhPNy63")
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
                .tag(3)
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(4)
        }
        .animation(.interactiveSpring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.5), value: selectedTab)
        .onAppear {
            selectedTab = 0
        }
        .tint(Color("BrandGradientStart"))
    }
}

#Preview {
    MainView(viewModel: MainViewViewModel())
}
