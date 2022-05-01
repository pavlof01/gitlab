//
//  PushTokenWebRepository.swift
//  Gitlab
//
//  Created by a-pavlov on 30.04.2022.
//

import Combine
import Foundation

protocol PushTokenWebRepository: WebRepository {
    func register(devicePushToken: Data) -> AnyPublisher<Void, Error>
}

struct RealPushTokenWebRepository: PushTokenWebRepository {
    
    let session: URLSession
    let baseURL: String
    let bgQueue = DispatchQueue(label: "bg_parse_queue")
    
    init(session: URLSession, baseURL: String) {
        self.session = session
        self.baseURL = baseURL
    }
    
    func register(devicePushToken: Data) -> AnyPublisher<Void, Error> {
        //TODO: upload the push token to server
        return Just<Void>.withErrorType(Error.self)
    }
}

