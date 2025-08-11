//
//  JSONArray.swift
//  Coco
//
//  Created by Jackie Leonardy on 01/07/25.
//

import Foundation

protocol JSONArrayProtocol {
    init(jsonArray: [JSONObject]) throws
}

extension JSONArray: JSONArrayProtocol {}

struct JSONArray<T: JSONDecodable>: JSONDecodable {
    let values: [T]

    init(json: JSONObject) throws {
        throw NSError(domain: "JSONArray init expects a top-level array, not an object", code: -1)
    }

    init(jsonArray: [JSONObject]) throws {
        self.values = try jsonArray.map { try T(json: $0) }
    }
}
