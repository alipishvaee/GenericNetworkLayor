//
//  ApiService.swift
//  PNA
//
//  Created by AliPishvaee on 12/20/17.
//  Copyright © 2017 PNA. All rights reserved.
//

import Foundation
import UIKit
import SwiftyRSA

class ApiService: NSObject {
    
    static let shared = ApiService()
    var encryptedSTR = String()
    var decryptedSTR = String()
    var clearArray = [SwiftyRSA.ClearMessage]()
    let clearMSG = NSMutableData()
    private let publickKey = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwnu+gd09uIKQ+9D5vcBIQuhtz6xaECEmtBhY+vp+iqlI/VJBA8Oc18KWj6gHSi1ynFdzP2coGL+F9GpVmc4MdpNT3ILNP43YLfek3SpYeBJlW8cIZr6Wivy6en1J6wnM8p4ckdHh99r0jtES8TB7N35RTKhXTFfLqg6Etwt3lzHP4JOpgoExLxip0kQke8z2VIPgPhULHxM8UhepJh23jymv1qqJEobS6vMneyv9d8CnWN28ldfurawgptQh1D+guZ7cEH6NzomDeZj/11QfEfm8QPialy3gkJbkpd+Z5Pj5FmxvlF52DTLijXNjVxQcIMV0BBbbdx4QAvUagx+KMQIDAQAB"
    private let privateKey = try! PrivateKey(pemEncoded : "MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDCe76B3T24gpD70Pm9wEhC6G3PrFoQISa0GFj6+n6KqUj9UkEDw5zXwpaPqAdKLXKcV3M/ZygYv4X0alWZzgx2k1Pcgs0/jdgt96TdKlh4EmVbxwhmvpaK/Lp6fUnrCczynhyR0eH32vSO0RLxMHs3flFMqFdMV8uqDoS3C3eXMc/gk6mCgTEvGKnSRCR7zPZUg+A+FQsfEzxSF6kmHbePKa/WqokShtLq8yd7K/13wKdY3byV1+6trCCm1CHUP6C5ntwQfo3OiYN5mP/XVB8R+bxA+JqXLeCQluSl35nk+PkWbG+UXnYNMuKNc2NXFBwgxXQEFtt3HhAC9RqDH4oxAgMBAAECggEAWlBgvaniGab4cRgwgb+jTv7kz8X35PmgIY4U9CgTT40hihICgx753PBOPtQG3pmQWa36pPzgj+2Q5Vnj+pLHEuGD1ikf612RgHc6JkKd5tSUITSiYCQtgMmwR2WbR/y7IgfuuIDA8PrLCu9oXnznG3QbiP+72oYC3Cv10ZMPrDPz6K6xJejXFYH68koosL3HYBaWiykuAPzkVdmdBMrjPfSySSwLQ+w3+1NCKUO93kFxtlUrpnlnykPQwsWVwdqtTwg6pbjlg+eJKGuPf2jYgnBofoKHmB/HlBTnyTG5cFSsf7inxUjzmBjWFC2Zi6Oiczd+A4igS/TmBrOdInLRyQKBgQDRA7KLpB33+ECe1uKMrqqZbnM0T27xWM5z2mLrQqDJBvzOh5q5rWIrSvVC5DVbgFNkRpScJbtHec5wvJgpVuw5Sl/lSoFMWJcA7zB+k2CvvYAZ6MVhg1R7nQKlH/rq40do/TZSO5aqQTXpThlnDiDzyVYUjOfgk1hj73SXfs709wKBgQDuM9ErbFe1P9os9nWjWfDzr9xc2Rm78xhgEqYhv43jrH9P7E5n6lIYZTNlMwisrtcQXi9WNUnwb+le5+jkjwUuywEKRaGkedMb1bhVB2JZ/Lvkq8lRyRMvUeuHSlN+STEPQy0ALPu9L3XufSVqP5YOhwdTzGNaNKG0QXMN9bq4FwKBgCYw/cPkRhGUTAJ6E0VPeR61/tj1FrmE15x1sBN6xjRVUYZPYudAliqA9NW3K0S/6vzspKTvhAvoZt9Upp0PI/TH8UPNXFjd6yGhkwPd3BHgl3KkhMRvodVAeEZB1LBsvRSjB/T4rGwJpFcwDRY2j7Db/h2dLZVsdv8ztuMjqZ87AoGBAOVhlL2iGVv63xiJRYNGa1ffM+9dSQDK+eAaVU0Ob46dYAQQ5PgAl4nSeomreWEBBS1H5YG40zjsK+kungDrEOycpKXFpAEFJ5wYVOfcsoNBc5ajLrzJSuY4lvyzQG/N/6ZY5A7VQp5OA9zjOpJ0JQZcVVwG6G3HXSh+FlONHH+FAoGAfQSR4p/Am2h6uLkzXK5KODvCeqsBr9p4MtSZg4z6ZkwWGs6KqiSE8EekngnzSKGBmBbda1BCsTu0hNrn+axaGBKO0ZegHyq7H9VeKfoowyZPwq3xVJulIusIG1bJgLoUy7rwBMFRX1PDvcSsuA7Sp6khKsKObCs/7lLzW58zaK4=")
    
//    private let oldPrivateKey = try? PrivateKey(pemEncoded : "MIIEowIBAAKCAQBqYKiZYb/h+ILaDDv1BiMIsg7QCj2I72vaTPLz4k4YmFx6i7os+eJNmyEobUq7Wxnn0rbRt1EqP/KGfFvzWJa4H6GXP7blp2o1TY8vPKcuncDY5KRzUufJ3gCgeyh2OS9Fv/byZDNKXi7NtVTElpAx7tU2eHBsBV/204N/t6WlPxgHLrL05T4c/04CTbn7NZygkERFlLnFEdYZ7EhWhOBR4qI8TnL3WZesurksTuyD034SA5bbN2BVd34myE8t1ck69T3aBGSz0WJdU4kLj8saQgKmCneDAG4lkK+NEojZWfT1z6BTVaQdjNE8blM69eHAfHLVg2Q0ZoTOgnAL0VtFAgMBAAECggEACtHuFDvXEpr+ZENeTdvj8Fx8GTkRbT49ECVHiPr5ypKkxWo086IvHIms47nKIihwCB5srgQhY1TBzGAV0jiui+fbvdCjP9S5ftZ2u+1Fa/5rwSPwfjJulR/ZnHkqcmv6nPOboKgEd4oA5LeO+bf+zrVmRnYVqUcarbZx56m8VYRluTUmsAhpM2mV+ir/y1v2tj/pK4MQiU4ZJ3wAVMeJ4LsUtnzy/Mhy3m1LQRmGqejLxI4t6+X49utSPKF6kP2KoRFqeR40EKNVQ9V5R38QsjhI1UJZ6aJVtcq6p2mGIzYdNpMq39261vjJ/vpKhQywL1icYOr9CePX3WDbJcPsOQKBgQCx0MnmQVTbijuM5EJLFGdCcQusA6+OMVzBAsgZoXcB9DsLvDQRLROLUshe8F3hqzM3YaMniGYaZywEkL5ICmRoSZHkU2SYYXlr6UCSZ1hl8dNKI5L7doGXn7ppkjE9Hi1DaRSPeylQSE/v+Tchkd6/auZr5pPjQ/iIIwYSKVdZpwKBgQCZJrD/MgYpIMB5nm36mdqjh1ytUyr8jnXGdJJolxqrler4N2EQsQaKqpaoBnQV2fPa8+SGl98kaI/KFRcKCgPxPbuyN97P0o8JnEr9hFP10HM2Qua74GX6O8cMXmp927s7eEkHDNcLOQZ2gkOApOV4DOU586UnzvwDiSAGEdNpMwKBgQCBW5AV1z9he125MLFdp1k7h7vjBsdnXVfJ/jkOFF3caQ2vitoiCLXoLHAiSSEzM/XNe1VTRDJrUNU/+QDErfK/v43IGjbbeEX6EDVujIpNl7CLhfe+wkaixIu7k6QIf3SUTtSrUQEMK58jyByoalMu1BkPNC4wLlmWyEv5WGP4jwKBgQCDuz8VUr7v02cbdUWd/4aLkFwMDfR0pkjxucVRR1++ZUZl2KSaCdrZnV/XCS4CuaVCGPThPHLIS1Qa+0cE8JZxg6sV4W66jZ9RIely5MafMnxXGPaEdcDhm1db8T5iIYWL4qvV75ps4dEIUIWlerCSMW1eCo9tjWFB3Un5To3s9wKBgCQdzbeVMaZSMp0x53NdRmShqkoid07ds0a52XH1wiOgtKf/VftZvlv8GkrOqtX9VTmT1BB9MM9oijHyA6uKHwjV7eDWxqqRiJYWV2GbztO7g71ijDdCusqZPPIEpQ3w2E1UJuxxGTximV6WG27x1jeiYHnrCTd20G+wMSTXO6lu")
//    
//    private let oldPublicKey = try? PublicKey(pemEncoded : "MIIBITANBgkqhkiG9w0BAQEFAAOCAQ4AMIIBCQKCAQBz+hxBH7MxtWBVdlwyEUtEIM6rtLriwWfQmiWfMK2E6dydfrspPtFOmzCkN2lXYXm1OtUSxBTebuHY9xHlVFh0HKB3Ax5XS0v5zngCJRRemY3cxpGPcspd9LYh2EKNrdI48jmOAdooEnZD7JsdN8Al95kJTAGE1Dqs4jPP2iJa3LjFoCJzDv1lAzT5/WuC3AIuHdWjTch+09iLKgzhI9GqmwF/+iKPEpydv7xMMOVkuCgiVQv6fxEsnhquJxwdZkrIYN0lk5ZgYLtggQItX3CDaDL360XMJovu1+Oul7VR4zpFCvree8jySglTSeKLziQC7ocZsU2Mt0blN0F6goNLAgMBAAE=")
    
//    func Decrypt(EncryptedMSG : String) -> String {
//        do {
//
//            let keySize = 344
//            let strlength = EncryptedMSG.count
//            let iteration = strlength / keySize
//            var i = 0
//            while i < iteration
//            {
//                let STR = EncryptedMSG.stringSubstring(From: keySize * i, length: keySize)
//                let encrypted = try EncryptedMessage(base64Encoded: STR)
//                let clear = try encrypted.decrypted(with: privateKey, padding: .OAEP)
//                ClearArray.append(clear)
//                i += 1
//            }
//            if keySize * i < strlength && i == iteration
//            {
//                let STR = EncryptedMSG.stringSubstring(From: keySize * i, length: strlength-(keySize * i) )
//                let encrypted = try EncryptedMessage(base64Encoded: STR)
//                let clear = try encrypted.decrypted(with: privateKey, padding: .OAEP)
//                ClearArray.append(clear)
//            }
//            ClearArray.forEach({ClearMSG.append($0.data)})
//            let string = String(data: ClearMSG as Data, encoding: .utf8)!
//            return string
//        }
//        catch { debugPrint(error) ; return "" }
//    }
//
//
//    func Encrypt(MSG : String) -> String {
//        do {
//            let keysize = 214
//            let bytes : [UInt8] = Array(MSG.utf8)
//            let iteration = bytes.chunked(by: keysize).count
//            debugPrint(iteration)
//            var i = 0
//            while i < iteration
//            {
//                let TrimedByte = bytes.chunked(by: keysize)[i]
//                let nsdata = NSData(bytes: TrimedByte, length: TrimedByte.count)
//                let clear =  ClearMessage(data: nsdata as Data)
//                let encrypted = try clear.encrypted(with: publicKey, padding: .OAEP)
//                let base64String = encrypted.base64String
//                EncryptedSTR += base64String
//                i += 1
//            }
//
//            return EncryptedSTR
//        }
//        catch { debugPrint(error) ; return "" }
//    }
    
    func decrypt(message: String) -> String {
        do {
            
            let keySize = 344
            let strlength = message.count
            let iteration = strlength / keySize
            var i = 0
            while i < iteration
            {
                
                let STR = message.stringSubstring(From: keySize * i, length: keySize)
                let encrypted = try EncryptedMessage(base64Encoded: STR)
                let clear = try encrypted.decrypted(with: privateKey, padding: .OAEP)
                clearArray.append(clear)
                i += 1
            }
            if keySize * i < strlength && i == iteration
            {
                let STR = message.stringSubstring(From: keySize * i, length: strlength-(keySize * i) )
                let encrypted = try EncryptedMessage(base64Encoded: STR)
                let clear = try encrypted.decrypted(with: privateKey, padding: .OAEP)
                clearArray.append(clear)
            }
            clearArray.forEach({clearMSG.append($0.data)})
            let string = String(data: clearMSG as Data, encoding: .utf8)!
            return string
        }
        catch { debugPrint(error) ; return "" }
    }
    
    
    func encrypt(message: String) -> String {
        encryptedSTR = ""
        do {
            let publicKey = try PublicKey(pemEncoded : publickKey)
            
            let keysize = 214
            let bytes : [UInt8] = Array(message.utf8)
            let iteration = bytes.chunked(by: keysize).count
            debugPrint(iteration)
            var i = 0
            while i < iteration
            {
                let TrimedByte = bytes.chunked(by: keysize)[i]
                let nsdata = NSData(bytes: TrimedByte, length: TrimedByte.count)
                let clear =  ClearMessage(data: nsdata as Data)
                let encrypted = try clear.encrypted(with: publicKey, padding: .OAEP)
                let base64String = encrypted.base64String
                encryptedSTR += base64String
                i += 1
            }
            
            return encryptedSTR
        }
        catch { debugPrint(error) ; return "" }
    }
    
    func fetchGenericData <T: Decodable, S: Encodable>(url: String, bearerToken: String = "", encodedModel: S, completion : @escaping (T?,Error?) -> ()) {
        do {
            let jsonData = try JSONEncoder().encode(encodedModel.self)
            let url = URL(string: url)!
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.timeoutInterval = 60
            if bearerToken != "" {
                request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
                request.setValue("no-cache", forHTTPHeaderField: "cache-control")
            }
            request.httpMethod = "POST"
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) { (data , resp , error) in
                
                guard let data = data else { completion(nil,error); return }
                print(String(data: data, encoding: .utf8))
                do {
                    let obj = try JSONDecoder().decode(T.self, from: data)
                    completion(obj,nil)
                } catch let jsonError {
                    completion(nil,jsonError); return }
                }.resume()
        } catch { completion(nil,error); return}
    }
    
    
    
    func fetchData <T: Decodable, S: Encodable>(url: String, bearerToken: String = "", encodedModel: S, completion : @escaping (T?,Error?) -> ()) {
        do {
            let jsonData = try JSONEncoder().encode(encodedModel.self)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            let parentModel = ParentModel(body: ApiService.shared.encrypt(message: jsonString))
            let parentModelData = try JSONEncoder().encode(parentModel.self)
            let url = URL(string: url)!
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.timeoutInterval = 60
            if bearerToken != "" {
                request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
                request.setValue("no-cache", forHTTPHeaderField: "cache-control")
            }
            request.httpMethod = "POST"
            request.httpBody = parentModelData
            
            URLSession.shared.dataTask(with: request) { (data , resp , error) in
                guard let data = data else { completion(nil,error); return }
                do {
                    let obj = try JSONDecoder().decode(ParentModel.self, from: data)
                    let responseString = self.decrypt(message: obj.body)
                    print(responseString)
                    guard let responseData = responseString.data(using: .utf8) else { completion(nil,error); return}
                    let responseObj = try JSONDecoder().decode(T.self, from: responseData)
                    completion(responseObj,nil)
                } catch let jsonError {
                    completion(nil,jsonError); return }
                }.resume()
        } catch { completion(nil,error); return}
    }
}


struct ParentModel: Codable {
    var body: String
}
