//
//  Member.swift
//  GaryCam
//
//  Created by 정종문 on 2021/01/21.
//

import Foundation

struct SignIn : Codable {
    let email: String
    let passwd: String
}
struct SignUp : Codable {
    let email: String
    let name: String
    let passwd: String
}
struct MemberTempInfo : Codable {
    let tid: String?
    let name: String?
    
    init() {
        self.tid = ""
        self.name = ""
    }
    
    init(tid: String, name: String) {
        self.tid = tid
        self.name = name
    }
}
struct MemberInfomation : Codable {
    let tid: String?
//    let name: String
}
