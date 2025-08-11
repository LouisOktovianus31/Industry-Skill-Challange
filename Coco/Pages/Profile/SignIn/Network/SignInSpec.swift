//
//  SignInSpec.swift
//  Coco
//
//  Created by Jackie Leonardy on 16/07/25.
//

import Foundation

struct SignInSpec: JSONEncodable {
    let email: String
    let password: String
    
    private enum CodingKeys: String, CodingKey {
        case email = "p_email"
        case password = "p_password"
    }
}
