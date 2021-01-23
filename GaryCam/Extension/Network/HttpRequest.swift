//
//  HttpRequest.swift
//  GaryCam
//
//  Created by 정종문 on 2021/01/21.
//

import Foundation
import Alamofire

class HttpRequest {
    private let baseURL = "http://ec2-15-164-224-237.ap-northeast-2.compute.amazonaws.com"

    // 로그인 로직
    // 로그인 -> Response로 MID와 이름을 가져옴 -> 가져오기 성공은 로그인
    func getUserTempInfo(param: [String:String], completionHandler: @escaping (MemberTempInfo?) -> ()) {
        AF.request("\(self.baseURL)/member/login", method: .get, parameters: param, encoding: URLEncoding.default, headers: nil)
            .responseJSON {
                (response) in
                switch response.result {
                case .success(let JSON):
                    do {
                        let responseData = try JSONSerialization.data(withJSONObject: JSON, options: .prettyPrinted)
                        let decodeData = try JSONDecoder().decode(MemberTempInfo.self, from: responseData)
                        completionHandler(decodeData)
                    } catch {
                        print("Doesn't Convert to JSON Data")
                    }
                case .failure(let error):
                    print("Network Error : \(error)")
                    completionHandler(nil)
                }
            }
    }
}
