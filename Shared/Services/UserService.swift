//
//  UserService.swift
//  Gitlab
//
//  Created by a-pavlov on 24.04.22.
//

import Combine
import Foundation
import SwiftUI

protocol UserService {
    func refreshUser() -> AnyPublisher<Void, Error>
    func load(user: LoadableSubject<UserModel>)
}

struct RealUserService: UserService {
    
    let webRepository: UserWebRepository
    let dbRepository: UserDBRepository
    let appState: Store<AppState>
    
    init(webRepository: UserWebRepository, dbRepository: UserDBRepository, appState: Store<AppState>) {
        self.webRepository = webRepository
        self.dbRepository = dbRepository
        self.appState = appState
    }

    func load(user: LoadableSubject<UserModel>) {
        
        let cancelBag = CancelBag()
        user.wrappedValue.setIsLoading(cancelBag: cancelBag)

        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [dbRepository] _ -> AnyPublisher<Bool, Error> in
                dbRepository.hasLoadedUser()
            }
            .flatMap { hasLoaded -> AnyPublisher<Void, Error> in
                if hasLoaded {
                    return Just<Void>.withErrorType(Error.self)
                } else {
                    return self.refreshUser()
                }
            }
            .flatMap { [dbRepository] in
                dbRepository.user()
            }
            .sinkToLoadable { user.wrappedValue = $0 }
            .store(in: cancelBag)
    }
    
    func refreshUser() -> AnyPublisher<Void, Error> {
        return webRepository
            .loadUser()
            .ensureTimeSpan(requestHoldBackTimeInterval)
            .flatMap { [dbRepository] in
                dbRepository.store(user: $0)
            }
            .eraseToAnyPublisher()
    }
    
    private var requestHoldBackTimeInterval: TimeInterval {
        return ProcessInfo.processInfo.isRunningTests ? 0 : 0.5
    }
}

struct StubUserService: UserService {
    
    func refreshUser() -> AnyPublisher<Void, Error> {
        return Just<Void>.withErrorType(Error.self)
    }
    
    func load(user: LoadableSubject<UserModel>) {
    }
}

