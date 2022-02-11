//
//  ViewController.swift
//  SadaptizerUIKit
//
//  Created by Jackson  on 10.02.2022.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Constraints
    
    @IBOutlet weak var animationViewTopConstraint: NSLayoutConstraint!
    
    //MARK: - @IBOutlets
    
    @IBOutlet weak var animationView: UIView!
    @IBOutlet weak var myView: UIView!
    
    //MARK: - Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //myView.addBlur(type: .systemUltraThinMaterialLight)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //someAnimation()
    }
    
    //MARK: - Animations
    
    func someAnimation() {
        UIView.animate(withDuration: 4) { [weak self] in
            self?.animationView.backgroundColor = .purple
            self?.animationViewTopConstraint.constant = 100
            self?.view.layoutIfNeeded()
        }
    }
    
    //MARK: - @IBActions
    
    @IBAction func buttonDidTap(_ sender: UIButton) {
        someAnimation()
    }
}
