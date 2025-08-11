//
//  JSONCodable.swift
//  Coco
//
//  Created by Jackie Leonardy on 30/06/25.
//

import Foundation

typealias JSONObject = [String: Any]
typealias JSONCodable = JSONEncodable & JSONDecodable

protocol JSONDecodable: Decodable {
    init(json: JSONObject) throws
}

protocol JSONEncodable: Encodable {
    func toDictionary() -> JSONObject?
}

extension JSONDecodable {
    init(json: JSONObject) throws {
        let data: Data = try JSONSerialization.data(withJSONObject: json, options: .init())
        
        self = try JSONDecoder().decode(Self.self, from: data)
    }
}

extension JSONEncodable {
    func toDictionary() -> JSONObject? {
        guard let data: Data = try? JSONEncoder().encode(self) else {
            return nil
        }
        
        guard let serializedObject: Any = try?
            JSONSerialization.jsonObject(with: data, options: .init()) else {
            return nil
        }
        
        guard let jsonObject: JSONObject = serializedObject as? JSONObject else {
            return nil
        }
        
        return jsonObject
    }
}
