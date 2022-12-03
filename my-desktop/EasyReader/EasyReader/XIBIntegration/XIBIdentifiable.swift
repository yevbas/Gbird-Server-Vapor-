//
//  XIBIdentifiable.swift
//  EasyReader
//
//  Created by Jackson  on 30/08/2022.
//

import UIKit

protocol XIBIdentifiable: AnyObject {
    static var XIBIdentifier: String { get }
}

extension XIBIdentifiable {
    static var XIBIdentifier: String {
        String(describing: self)
    }
}
