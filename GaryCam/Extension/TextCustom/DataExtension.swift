//
//  EncryptData.swift
//  GaryCam
//
//  Created by 정종문 on 2021/01/21.
//
import UIKit
import CryptoKit
import Foundation

class DataExtension {
    public func createJSONParam(parameterArray params: [String:String]) -> String {
        // 전달받은 Dictionary 매개변수를 JSON 형식으로 변환
        let jsonString:String? = convertJsonString(dictionaryObject: params)
        
        return jsonString ?? ""
    }
    
    private func convertJsonString(dictionaryObject: [String:String]) -> String {
        // 실질적으로 Dictionary 객체를 JSON String으로 변환
        do {
            let jsonData: Data = try JSONSerialization.data(withJSONObject: dictionaryObject, options: .prettyPrinted)
            
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            }
        } catch let error as NSError {
            print("Converting Error : \(error.description)")
        }
        
        return ""
    }
    
    public func passwordSHA256Enc(passwd: String) -> String {
        let encyptoData: Data = Data(passwd.utf8)
        let hashedData = SHA256.hash(data: encyptoData)
        
        return hashedData.hexString
    }
}
 
extension Digest {
    var bytes: [UInt8] { Array(makeIterator()) }
    var hexString: String {
        bytes.map { String(format: "%02X", $0) }.joined()
    }
}

extension String {
    var braketText: String? {
        return "(\(self))"
    }
}
