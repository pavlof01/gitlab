//
//  UserDBRepository.swift
//  Gitlab
//
//  Created by a-pavlov on 23.04.22.
//

import CoreData
import Combine

protocol UserDBRepository {
    func hasLoadedUser() -> AnyPublisher<Bool, Error>
    
    func store(user: UserModel) -> AnyPublisher<Void, Error>
    func user() -> AnyPublisher<UserModel, Error>
}

struct RealUserDBRepository: UserDBRepository {
    
    let persistentStore: PersistentStore
    
    func hasLoadedUser() -> AnyPublisher<Bool, Error> {
        let fetchRequest = UserModelMO.hasLoadedUser()
        return persistentStore
            .count(fetchRequest)
            .map { $0 > 0 }
            .eraseToAnyPublisher()
    }

    func store(user: UserModel) -> AnyPublisher<Void, Error> {
        return persistentStore
            .update { context in
                user.store(in: context)
            }
    }

    func user() -> AnyPublisher<UserModel, Error> {
        let fetchRequest = UserModelMO.user()
        return persistentStore
            .fetch(fetchRequest) {
                UserModel(managedObject: $0)
            }
            .eraseToAnyPublisher()
    }
}

// MARK: - Fetch Requests

extension UserModelMO {

    static func hasLoadedUser() -> NSFetchRequest<UserModelMO> {
        let request = newFetchRequest()
        request.fetchLimit = 1
        return request
    }

    static func user() -> NSFetchRequest<UserModelMO> {
        let request = newFetchRequest()
        request.fetchLimit = 1
        return request
    }
}

