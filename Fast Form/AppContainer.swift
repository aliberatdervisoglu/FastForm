
import FactoryKit
import Foundation

@MainActor
extension Container {
    var authService: Factory<AuthManager> {
        self { AuthManagerImpl() }
    }

    var formService: Factory<FormManager> {
        self { FormManagerImpl() }
    }

    var responseService: Factory<ResponseManager> {
        self { ResponseManagerImpl() }
    }
}
