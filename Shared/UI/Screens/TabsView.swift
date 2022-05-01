//
//  TabsView.swift
//  Gitlab
//
//  Created by a-pavlov on 24.04.22.
//

import SwiftUI
import Combine

struct TabsView: View {
    
    @ObservedObject private(set) var viewModel: ViewModel
    @Environment(\.locale) private var locale: Locale
    let inspection = Inspection<Self>()
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            NotificationsView()
                .tabItem {
                    Image(systemName: "bell")
                    Text("Notifications")
                }
            ExploreView()
                .tabItem {
                    Image(systemName: "binoculars")
                    Text("Explore")
                }
            ProfileView(viewModel: .init(container: viewModel.container))
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
        }
        .font(.headline).onReceive(inspection.notice) { self.inspection.visit(self, $0) }
        .modifier(viewModel.localeReader)
    }
    
    private var content: AnyView {
        switch viewModel.user {
        case .notRequested: return AnyView(notRequestedView)
        case let .isLoading(last, _): return AnyView(loadingView(last))
        case let .loaded(user): return AnyView(loadedView(user, showLoading: false))
        case let .failed(error): return AnyView(failedView(error))
        }
    }
}

// MARK: - Loading Content

private extension TabsView {
    var notRequestedView: some View {
        Text("").onAppear(perform: self.viewModel.reloadUser)
    }
    
    func loadingView(_ previouslyLoaded: UserModel?) -> some View {
        if let user = previouslyLoaded {
            return AnyView(loadedView(user,  showLoading: true))
        } else {
            return AnyView(ActivityIndicatorView().padding())
        }
    }
    
    func failedView(_ error: Error) -> some View {
        ErrorView(error: error, retryAction: {
            self.viewModel.reloadUser()
        })
    }
}

// MARK: - Displaying Content

private extension TabsView {
    func loadedView(_ user: UserModel, showLoading: Bool) -> some View {
        VStack {
            if showLoading {
                ActivityIndicatorView().padding()
            }
            Text(user.username)
        }
    }
}

// MARK: - Preview

#if DEBUG
struct TabsView_Previews: PreviewProvider {
    static var previews: some View {
        TabsView(viewModel: .init(container: .preview))
    }
}
#endif
