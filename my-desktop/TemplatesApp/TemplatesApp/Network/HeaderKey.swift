//
//  HeaderKey.swift
//  TemplatesApp
//
//  Created by Jackson  on 04.05.2022.
//

import Foundation

enum HeaderKey: String {
    case contentType = "Content-Type"
    case accessToken = "Authorization"
}


enum HeaderValue: String {
    case contentType = "application/json"
    case multiformData = "multipart/form-data"
}
