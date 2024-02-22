//
//  Ext.swift
//  MyFinalProject
//
//  Created by Ankita Mondal on 12/02/24.
//

import Foundation

class converstion{
    
    func convertToDictionaryValue(text: String) -> Dictionary<String, Any>? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any>
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}

extension Encodable {
    
    var convertToString: String? {
        
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        do {
            let jsonData = try jsonEncoder.encode(self)
            return String(data: jsonData, encoding: .utf8)
        } catch {
            return nil
        }
    }
}
