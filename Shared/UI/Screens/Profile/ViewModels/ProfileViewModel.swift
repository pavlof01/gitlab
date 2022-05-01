//
//  ProfileViewModel.swift
//  Gitlab
//
//  Created by a-pavlov on 23.04.22.
//

import SwiftUI
import Foundation
import Combine

// MARK: - Routing

extension ProfileView {
    struct Routing: Equatable {
    }
}
extension ProfileView {
    final class ViewModel: ObservableObject {
        
        // State
        @Published var routingState: Routing
        @Published var user: Loadable<UserModel>
        @Published var canRequestPushPermission: Bool = false

        // Misc
        let container: DIContainer
        private var cancelBag = CancelBag()
        
        init(container: DIContainer, user: Loadable<UserModel> = .notRequested) {
            self.container = container
            let appState = container.appState
            _routingState = .init(initialValue: appState.value.routing.profile)
            _user = .init(initialValue: user)
            cancelBag.collect {
                $routingState
                    .sink { appState[\.routing.profile] = $0 }
                appState.map(\.routing.profile)
                    .removeDuplicates()
                    .weakAssign(to: \.routingState, on: self)
                appState.updates(for: AppState.permissionKeyPath(for: .pushNotifications))
                    .map { $0 == .notRequested || $0 == .denied }
                    .weakAssign(to: \.canRequestPushPermission, on: self)
            }
        }
        
        
        // MARK: - Side Effects
        
        func reloadUser() {
            container.services.userService
                .load(user: loadableSubject(\.user))
        }
        
    }
}
