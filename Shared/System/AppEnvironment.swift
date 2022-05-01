//
//  AppEnvironment.swift
//  Gitlab
//
//  Created by a-pavlov on 23.04.22.
//

import UIKit
import Combine

struct AppEnvironment {
    let container: DIContainer
    let systemEventsHandler: SystemEventsHandler
}

extension AppEnvironment {
    
    static func bootstrap() -> AppEnvironment {
        let appState = Store<AppState>(AppState())
        /*
         To see the deep linking in action:
         
         1. Launch the app in iOS 13.4 simulator (or newer)
         2. Subscribe on Push Notifications with "Allow Push" button
         3. Minimize the app
         4. Drag & drop "push_with_deeplink.apns" into the Simulator window
         5. Tap on the push notification
         
         Alternatively, just copy the code below before the "return" and launch:
         
         DispatchQueue.main.async {
         deepLinksHandler.open(deepLink: .showProfile())
         }
         */
        let session = configuredURLSession()
        let webRepositories = configuredWebRepositories(session: session)
        let dbRepositories = configuredDBRepositories(appState: appState)
        let services = configuredServices(appState: appState,
                                          dbRepositories: dbRepositories,
                                          webRepositories: webRepositories)
        let diContainer = DIContainer(appState: appState, services: services)
        let deepLinksHandler = RealDeepLinksHandler(container: diContainer)
        let pushNotificationsHandler = RealPushNotificationsHandler(deepLinksHandler: deepLinksHandler)
        let systemEventsHandler = RealSystemEventsHandler(
            container: diContainer,
            deepLinksHandler: deepLinksHandler,
            pushNotificationsHandler: pushNotificationsHandler,
            pushTokenWebRepository: webRepositories.pushTokenWebRepository
        )
        
        return AppEnvironment(container: diContainer,
                              systemEventsHandler: systemEventsHandler)
    }
    
    private static func configuredURLSession() -> URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 120
        configuration.waitsForConnectivity = true
        configuration.httpMaximumConnectionsPerHost = 5
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        configuration.urlCache = .shared
        return URLSession(configuration: configuration)
    }
    
    private static func configuredWebRepositories(session: URLSession) -> DIContainer.WebRepositories {
        let userWebRepository = RealUserWebRepository(
            session: session,
            baseURL: "https://gitlab.com/api/v4")
        let pushTokenWebRepository = RealPushTokenWebRepository(
            session: session,
            baseURL: "https://gitlab.com/api/v4")
        return .init(userRepository: userWebRepository, pushTokenWebRepository: pushTokenWebRepository)
    }
    
    private static func configuredDBRepositories(appState: Store<AppState>) -> DIContainer.DBRepositories {
        let persistentStore = CoreDataStack(version: CoreDataStack.Version.actual)
        let userDBRepository = RealUserDBRepository(persistentStore: persistentStore)
        return .init(userRepository: userDBRepository)
    }
    
    private static func configuredServices(appState: Store<AppState>,
                                           dbRepositories: DIContainer.DBRepositories,
                                           webRepositories: DIContainer.WebRepositories
    ) -> DIContainer.Services {
        
        let userService = RealUserService(
            webRepository: webRepositories.userRepository,
            dbRepository: dbRepositories.userRepository,
            appState: appState)
        
        let userPermissionsService = RealUserPermissionsService(
            appState: appState, openAppSettings: {
                URL(string: UIApplication.openSettingsURLString).flatMap {
                    UIApplication.shared.open($0, options: [:], completionHandler: nil)
                }
            })
        
        return .init(userService: userService, userPermissionsService: userPermissionsService)
    }
}

extension DIContainer {
    struct WebRepositories {
        let userRepository: UserWebRepository
        let pushTokenWebRepository: PushTokenWebRepository
    }
    
    struct DBRepositories {
        let userRepository: UserDBRepository
    }
}

