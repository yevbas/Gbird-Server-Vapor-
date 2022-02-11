//
//  AnimatingBackgroundController.swift
//  SadaptizerUIKit
//
//  Created by Jackson  on 11.02.2022.
//

import Foundation
import UIKit
import SwiftUI

final class AnimatingBackgroundController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// INSERT SWIFT UI VIEW TO UIVIEWCONTROLLER
        let hostController = UIHostingController(rootView: AnimatedBackground())
        self.view.addSubview(hostController.view)
    }
    
}
