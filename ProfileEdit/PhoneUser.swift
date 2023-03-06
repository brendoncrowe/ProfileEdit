//
//  UserInfo.swift
//  ProfileEdit
//
//  Created by Brendon Crowe on 2/10/23.
//

import Foundation

struct PhoneUser: Codable {
    let name: String
    let photo: Data
    let job: String
    let phoneNumber: String
    let email: String
    var website: String? = "www.example123.com"
    
    
    // TODO: Create Persistence for save and update
    
    
}
