//
//  UserInfo.swift
//  ProfileEdit
//
//  Created by Brendon Crowe on 2/10/23.
//

import Foundation

struct User: Codable {
    let name: String
    let job: String
    let phoneNumber: String
    let email: String
    var website: String
}
