//
//  Models+CoreData.swift
//  Gitlab
//
//  Created by a-pavlov on 24.04.22.
//

import Foundation
import CoreData

extension UserModelMO: ManagedEntity { }

extension Locale {
    static var backendDefault: Locale {
        return Locale(identifier: "en")
    }
    
    var shortIdentifier: String {
        return String(identifier.prefix(2))
    }
}

extension UserModel {
    
    @discardableResult
    func store(in context: NSManagedObjectContext) -> UserModelMO? {
        
        guard let user = UserModelMO.insertNew(in: context)
        else { return nil }
        user.name = name
        user.username = username
        user.avatar_url = avatar_url
        return user
    }
    
    init?(managedObject: UserModelMO) {
        let id = managedObject.id
        guard let name = managedObject.name,
              let username = managedObject.username,
              let avatar_url = managedObject.avatar_url
        else { return nil }
        
        self.init(id: Int(id), username: username, name: name, avatar_url: avatar_url)
    }
}

