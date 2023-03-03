//
//  RandomUser.swift
//  ProfileEdit
//
//  Created by Brendon Crowe on 3/1/23.
//

import Foundation


struct RandomUser: Decodable {
    let results: [User]
}

struct User: Decodable {
    let gender: String
    let name: UserName
    let location: UserLocation
    let email: String
    let phone: String
    let picture: UserPicture
}

struct UserName: Decodable {
    let first: String
    let last: String
}

struct UserLocation: Decodable {
    let state: String
}

struct UserPicture: Decodable {
    let large: String
}
