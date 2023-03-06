//
//  UserInfo.swift
//  ProfileEdit
//
//  Created by Brendon Crowe on 2/10/23.
//

import UIKit

struct PhoneUser: Codable & CustomStringConvertible{
    let name: String
    let photo: Data
    let job: String
    let phoneNumber: String
    let email: String
    var website: String? = "www.example123.com"
    
    var description: String {
        return "\(name) \n \(job) \n \(phoneNumber)"
    }
    
    
    // TODO: Create Persistence for save and update
    
    static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    static let userInfoFile = documentsDirectory.appending(path: "userInfo").appendingPathExtension(".plist")
    
    static func saveUserInfo(_ user: PhoneUser) {
        let propertyListEncoder = PropertyListEncoder()
        let savedUserInfo = try? propertyListEncoder.encode(user)
        try? savedUserInfo?.write(to: userInfoFile)
    }
    
    static func loadUserInfo() -> PhoneUser? {
        guard let savedUserInfo = try? Data(contentsOf: userInfoFile) else { return nil }
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(PhoneUser.self, from: savedUserInfo)
    }
    
}
