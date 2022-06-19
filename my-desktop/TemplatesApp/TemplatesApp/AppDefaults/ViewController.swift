//
//  ViewController.swift
//  TemplatesApp
//
//  Created by Jackson  on 04.05.2022.
//

import UIKit

class ChangeableObject: NSObject {
    
}


class ViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

}

protocol ObservableObject: NSObject {
    func subscribe(_ block: (ObservableObject) -> ()) -> Self
}
