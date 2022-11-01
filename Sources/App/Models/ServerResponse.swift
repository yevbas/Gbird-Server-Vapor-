//
//  File.swift
//  
//
//  Created by Basistyi, Yevhen on 01/11/2022.
//

import Vapor

struct ServerResponse<T: Content>: Content {
    let code: UInt
    let message: String?
    let data: T?
}
