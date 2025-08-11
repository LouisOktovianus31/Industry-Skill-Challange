//
//  JSONReader.swift
//  CocoTests
//
//  Created by Jackie Leonardy on 26/07/25.
//

import Foundation

@testable import Coco

final class JSONReader {
    enum ReadError: Error {
        case fileNotFound(String)
        case invalidFormat(String)
        case invalidData(String)
    }
    
    static func readJSONFile(_ fileName: String) throws -> Any {
        guard let path: String = Bundle(for: self).path(forResource: fileName, ofType: "json") else {
            throw ReadError.fileNotFound("\(fileName) path not found")
        }
        
        do {
            let data: Data = try Data(contentsOf: URL(filePath: path), options: .mappedIfSafe)
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            return jsonResult
        } catch {
            throw ReadError.invalidFormat("\(fileName) json format error: \(error)")
        }
    }
    
    static func getObjectFromJSON<T: JSONDecodable>(with jsonPath: String) throws -> T {
        do {
            let jsonResult = try Self.readJSONFile(jsonPath)
            
            if let jsonObject = jsonResult as? JSONObject {
                return try T(json: jsonObject)
            }
            else if let jsonArray = jsonResult as? [JSONObject],
                    let arrayResult = T.self as? JSONArrayProtocol.Type {
                return try arrayResult.init(jsonArray: jsonArray) as! T
            }
            else {
                throw ReadError.invalidData("Unexpected JSON format in \(jsonPath)")
            }
        } catch {
            throw error
        }
    }
}
