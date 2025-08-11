//
//  User.swift
//  Coco
//
//  Created by Jackie Leonardy on 01/07/25.
//

import Foundation

struct User: JSONDecodable {
    let id: String
    let groupId: String
    let name: String
    let email: String
    let passwordHash: String
    let createdAt: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case groupId = "group_id"
        case name
        case email
        case passwordHash = "password_hash"
        case createdAt = "created_at"
    }
}

typealias UserModelArray = JSONArray<User>
