//
//  Secrets.swift
//  Coco
//
//  Created by Jackie Leonardy on 30/06/25.
//

import Foundation

final class Secrets {
    static let shared = Secrets()

    private var secrets: [String: Any] = [:]

    private init() {
        if let path: String = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
           let dict: JSONObject = NSDictionary(contentsOfFile: path) as? JSONObject {
            secrets = dict
        }
    }

    var apiKey: String? {
        secrets["API_KEY"] as? String
    }
}
