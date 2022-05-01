//
//  UserModel.swift
//  Gitlab
//
//  Created by a-pavlov on 23.04.22.
//

import Foundation

struct UserModel: Codable, Identifiable, Equatable {
    let id: Int
    let username: Username
    let name: String
    let avatar_url: URL
    
    typealias Username = String
    //        "state": "active",
    //        "web_url": "https://gitlab.com/pavlof01",
    //        "created_at": "2018-11-07T08:44:10.047Z",
    //        "bio": "",
    //        "location": "",
    //        "public_email": "",
    //        "skype": "",
    //        "linkedin": "",
    //        "twitter": "",
    //        "website_url": "",
    //        "organization": "",
    //        "job_title": "",
    //        "pronouns": null,
    //        "bot": false,
    //        "work_information": null,
    //        "followers": 0,
    //        "following": 0,
    //        "local_time": null,
    //        "last_sign_in_at": "2022-04-22T18:13:45.158Z",
    //        "confirmed_at": "2018-11-07T08:44:08.989Z",
    //        "last_activity_on": "2022-04-23",
    //        "email": "pavlof01@gmail.com",
    //        "theme_id": 11,
    //        "color_scheme_id": 2,
    //        "projects_limit": 100000,
    //        "current_sign_in_at": "2022-04-23T08:13:17.036Z",
    //        "identities": [
    //            {
    //                "provider": "google_oauth2",
    //                "extern_uid": "117778121028585480044",
    //                "saml_provider_id": null
    //            }
    //        ],
    //        "can_create_group": true,
    //        "can_create_project": true,
    //        "two_factor_enabled": false,
    //        "external": false,
    //        "private_profile": false,
    //        "commit_email": "pavlof01@gmail.com",
    //        "shared_runners_minutes_limit": null,
    //        "extra_shared_runners_minutes_limit": null
}

