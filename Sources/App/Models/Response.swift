//
//  File.swift
//  
//
//  Created by Basistyi, Yevhen on 24/10/2022.
//

import Fluent
import Vapor

struct Response: Content {
    var success: String? = nil
    var error: String? = nil
}
