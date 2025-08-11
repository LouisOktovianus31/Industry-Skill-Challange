//
//  ActivityRequest.swift
//  Coco
//
//  Created by Jackie Leonardy on 08/07/25.
//

import Foundation

struct ActivitySearchRequest: JSONEncodable {
    let pSearchText: String

    enum CodingKeys: String, CodingKey {
        case pSearchText = "p_search_text"
    }
}
