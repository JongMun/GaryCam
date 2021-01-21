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
struct MemberInfomation : Codable {
    let email: String
    let name: String
}
