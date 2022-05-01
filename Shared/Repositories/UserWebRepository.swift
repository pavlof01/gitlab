//
//  UserWebRepository.swift
//  Gitlab
//
//  Created by a-pavlov on 23.04.22.
//

import Combine
import Foundation

protocol UserWebRepository: WebRepository {
    func loadUser() -> AnyPublisher<UserModel, Error>
}

struct RealUserWebRepository: UserWebRepository {
    
    let session: URLSession
    let baseURL: String
    let bgQueue = DispatchQueue(label: "bg_parse_queue")
    
    init(session: URLSession, baseURL: String) {
        self.session = session
        self.baseURL = baseURL
    }
    
    func loadUser() -> AnyPublisher<UserModel, Error> {
        return call(endpoint: API.user)
    }
}

// MARK: - Endpoints

extension RealUserWebRepository {
    enum API {
        case user
    }
}

extension RealUserWebRepository.API: APICall {
    var path: String {
        switch self {
        case .user:
            return "/user"
        }
    }
    var method: String {
        switch self {
        case .user:
            return "GET"
        }
    }
    var headers: [String: String]? {
        return [
            "Accept": "application/json",
            // TODO: create authorization flow
            "Authorization": "Bearer YOUR TOKEN",
        ]
    }
    func body() throws -> Data? {
        return nil
    }
}

