//
//  XIBViewController.swift
//  EasyReader
//
//  Created by Jackson  on 30/08/2022.
//

import UIKit

class XIBViewController: UIViewController, XIBIdentifiable {
    init() {
        super.init(nibName: Self.XIBIdentifier, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

