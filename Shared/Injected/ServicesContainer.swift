//
//  ServicesContainer.swift
//  Gitlab
//
//  Created by a-pavlov on 24.04.22.
//

extension DIContainer {
    struct Services {
        let userService: UserService
        let userPermissionsService: UserPermissionsService
        
        init(userService: UserService,
             userPermissionsService: UserPermissionsService
        ) {
            self.userService = userService
            self.userPermissionsService = userPermissionsService
        }
        
        static var stub: Self {
            .init(userService: StubUserService(),
                  userPermissionsService: StubUserPermissionsService()
            )
        }
    }
}

