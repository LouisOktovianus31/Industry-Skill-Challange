//
//  NetworkLogger.swift
//  Coco
//
//  Created by Jackie Leonardy on 01/07/25.
//

import Foundation

/**
 Network Logger only used in staging / debug model, won't be commited to production release
 */
struct NetworkLogger {
    static func logResponse(data: Data?, response: URLResponse?, error: Error?) {
        #if DEBUG || STAGING
        print("📡 Network Response:")
        
        if let urlResponse: HTTPURLResponse = response as? HTTPURLResponse {
            print("🔗 URL: \(urlResponse.url?.absoluteString ?? "")")
            print("📥 Status: \(urlResponse.statusCode)")
            print("📄 Headers: \(urlResponse.allHeaderFields)")
        }

        if let data: Data = data {
            if let json: Any = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
                print("📦 Body: \(json)")
            }
            else if let text: String = String(data: data, encoding: .utf8) {
                print("📦 Raw Body: \(text)")
            }
        }
        
        if let error: Error = error {
            print("❗️Error: \(error.localizedDescription)")
        }
        print("───────────────────────")
        #endif
    }
}
