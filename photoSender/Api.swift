//
//  Api.swift
//  photoSender
//
//  Created by macbook on 21.07.16.
//  Copyright © 2016 macbook. All rights reserved.
//

import Foundation
import Alamofire
import UIKit
class ServerOperations{
    //static var url=String("http://129/upload")
    static var defaults=NSUserDefaults.init(suiteName:"group.anjlab.flora.settings")
    static func uploadImage(data:NSData){
        Manager.sharedInstance.upload(
            .POST,
            (defaults?.stringForKey("url"))!,
            multipartFormData: { multipartFormData in
                multipartFormData.appendBodyPart(data: data, name: "file", fileName: "ads.jpeg", mimeType: "image/jpeg")
            },
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    debugPrint(upload)
                    upload.responseString { response in
                        debugPrint(response)
                    }
                case .Failure(let encodingError):
                    print(encodingError)
                }
            }
        )
    }
}
