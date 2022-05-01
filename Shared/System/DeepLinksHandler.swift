//
//  DeepLinksHandler.swift
//  Gitlab
//
//  Created by a-pavlov on 30.04.2022.
//

import Foundation

enum DeepLink: Equatable {
    
    case showProfile(username: UserModel.Username)
    
    init?(url: URL) {
        guard
            let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
            components.host == "https://www.gitlab.com",
            let query = components.queryItems
        else { return nil }
        if let item = query.first(where: { $0.name == "username" }),
           let username = item.value {
            self = .showProfile(username: UserModel.Username(username))
            return
        }
        return nil
    }
}

// MARK: - DeepLinksHandler

protocol DeepLinksHandler {
    func open(deepLink: DeepLink)
}

struct RealDeepLinksHandler: DeepLinksHandler {
    
    private let container: DIContainer
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func open(deepLink: DeepLink) {
        switch deepLink {
        case let .showProfile(username_):
            let routeToDestination = {
                self.container.appState.bulkUpdate {
                    $0.routing.profile.self
                }
            }
            /*
             SwiftUI is unable to perform complex navigation involving
             simultaneous dismissal or older screens and presenting new ones.
             A work around is to perform the navigation in two steps:
             */
            let defaultRouting = AppState.ViewRouting()
            if container.appState.value.routing != defaultRouting {
                self.container.appState[\.routing] = defaultRouting
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: routeToDestination)
            } else {
                routeToDestination()
            }
        }
    }
}

