
import FirebaseCore
import FirebaseFirestore
import SwiftUI

final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_: UIApplication,
                     didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool
    {
        FirebaseApp.configure()
        return true
    }
}

@main
@MainActor
struct FastFormApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    @State private var mainViewModel = MainViewViewModel()

    var body: some Scene {
        WindowGroup {
            MainView(viewModel: mainViewModel)
        }
    }
}
