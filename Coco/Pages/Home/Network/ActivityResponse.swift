//
//  Activity.swift
//  Coco
//
//  Created by Jackie Leonardy on 01/07/25.
//

import Foundation

struct Activity: JSONDecodable {
    let id: Int
    let title: String
    let images: [ActivityImage]
    let pricing: Double
    let category: ActivityCategory
    let packages: [ActivityPackage]
    let cancelable: String
    let createdAt: String
    let accessories: [Accessory]
    let description: String
    let destination: Destination
    let durationMinutes: Int

    enum CodingKeys: String, CodingKey {
        case id, title, images, pricing, category, packages, cancelable, accessories, description, destination
        case createdAt = "created_at"
        case durationMinutes = "duration_minutes"
    }
}

struct ActivityImage: JSONDecodable {
    let id: Int
    let imageUrl: String
    let imageType: ImageType
    let activityId: Int

    enum CodingKeys: String, CodingKey {
        case id
        case imageUrl = "image_url"
        case imageType = "image_type"
        case activityId = "activity_id"
    }
    
    enum ImageType: String, Decodable {
        case thumbnail
        case banner
        case gallery
    }
}

struct ActivityCategory: JSONDecodable {
    let id: Int
    let name: String
    let description: String
}

struct ActivityPackage: JSONDecodable {
    let id: Int
    let name: String
    let endTime: String
    let startTime: String
    let activityId: Int
    let description: String
    let maxParticipants: Int
    let minParticipants: Int
    let pricePerPerson: Double
    let host: Host
    let imageUrl: String

    enum CodingKeys: String, CodingKey {
        case id, name, description, host
        case endTime = "end_time"
        case startTime = "start_time"
        case activityId = "activity_id"
        case maxParticipants = "max_participants"
        case minParticipants = "min_participants"
        case pricePerPerson = "price_per_person"
        case imageUrl = "image_url"
    }
    
    struct Host: JSONDecodable {
        let bio: String
        let name: String
        let profileImageUrl: String
        
        enum CodingKeys: String, CodingKey {
            case profileImageUrl = "profile_image_url"
            case bio, name
        }
    }
}

struct Accessory: JSONDecodable {
    let id: Int
    let name: String
}

struct Destination: JSONDecodable {
    let id: Int
    let name: String
    let imageUrl: String?
    let description: String

    enum CodingKeys: String, CodingKey {
        case id, name, description
        case imageUrl = "image_url"
    }
}

typealias ActivityModelArray = JSONArray<Activity>
