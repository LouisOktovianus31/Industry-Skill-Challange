//
//  ActivityTopDestination.swift
//  Coco
//
//  Created by Jackie Leonardy on 08/07/25.
//

import Foundation

struct ActivityTopDestination: JSONDecodable {
    let id: Int
    let name: String
}

typealias ActivityTopDestinationModelArray = JSONArray<ActivityTopDestination>
