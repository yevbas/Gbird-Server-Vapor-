//
//  ViewController.swift
//  TestAppSwift
//
//  Created by Jackson  on 24/07/2022.
//

import UIKit

enum ViewModelInputEvent {
    case foo
}

enum ViewModelOutputEvent: Hashable {
    case boo
}

protocol IViewModel: AnyObject {
    typealias EventHandler = (Self) -> ()
    
    func handle(_ event: ViewModelInputEvent)
    
    @discardableResult
    func register(_ event: ViewModelOutputEvent, action: @escaping EventHandler) -> Self
}

final class ViewModel: IViewModel {
    
    private var eventHandlers: [ViewModelOutputEvent : EventHandler] = [:]
    
    func register(_ event: ViewModelOutputEvent, action: @escaping EventHandler) -> Self {
        eventHandlers[event] = action
        
        return self
    }
    
    func handle(_ event: ViewModelInputEvent) {
        switch event {
        case .foo: eventHandlers[.boo]?(self)
        }
    }
}


// MARK: -

final class ViewController: UIViewController {
    
    var viewMOdel: IViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewMOdel = ViewModel()
        
        registetOutputs()
        
        viewMOdel?.handle(.foo)
        
    }
    
    
    func registetOutputs() {
        viewMOdel?
            .register(.boo) { viewModel in
                print("Boo")
            }
    }
}







class Controller: UIViewController {
   
    
    
    
    @IBAction func buttonDidTap(_ sender: UIButton) {
        
        var name : String = "Sofi"
        
        print(name)
        
    }
}
