//
//  TabsViewModel.swift
//  Gitlab
//
//  Created by a-pavlov on 24.04.22.
//

import SwiftUI
import Combine

// MARK: - Routing

extension TabsView {
    struct Routing: Equatable {
    }
}


// MARK: - ViewModel

extension TabsView {
    class ViewModel: ObservableObject {
        
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
            _routingState = .init(initialValue: appState.value.routing.tabsView)
            _user = .init(initialValue: user)
            cancelBag.collect {
                $routingState
                    .sink { appState[\.routing.tabsView] = $0 }
                appState.map(\.routing.tabsView)
                    .removeDuplicates()
                    .weakAssign(to: \.routingState, on: self)
                appState.updates(for: AppState.permissionKeyPath(for: .pushNotifications))
                    .map { $0 == .notRequested || $0 == .denied }
                    .weakAssign(to: \.canRequestPushPermission, on: self)
            }
        }
        
        var localeReader: LocaleReader {
            LocaleReader(viewModel: self)
        }
        
        // MARK: - Side Effects
        
        func reloadUser() {
            container.services.userService
                .load(user: loadableSubject(\.user))
        }
        
        func requestPushPermission() {
            container.services.userPermissionsService
                .request(permission: .pushNotifications)
        }
    }
}

// MARK: - Locale Reader

extension TabsView {
    struct LocaleReader: EnvironmentalModifier {
        
        let viewModel: ViewModel
        
        func resolve(in environment: EnvironmentValues) -> some ViewModifier {
            return DummyViewModifier()
        }
        
        private struct DummyViewModifier: ViewModifier {
            func body(content: Content) -> some View {
                // Cannot return just `content` because SwiftUI
                // flattens modifiers that do nothing to the `content`
                content.onAppear()
            }
        }
    }
}

