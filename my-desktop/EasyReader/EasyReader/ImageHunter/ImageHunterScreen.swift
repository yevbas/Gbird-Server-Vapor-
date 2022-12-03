//
//  ViewController.swift
//  EasyReader
//
//  Created by Jackson  on 30/08/2022.
//

import UIKit
import VisionKit

class ImageHunterScreen: XIBViewController {
    let interaction = ImageAnalysisInteraction()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interaction.delegate = self
        
    }
}

extension ImageHunterScreen: ImageAnalysisInteractionDelegate {
    
}

