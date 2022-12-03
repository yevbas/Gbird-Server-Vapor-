//
//  EventUsingStructs.swift
//  TestAppSwift
//
//  Created by Jackson  on 28/07/2022.
//

import UIKit

// MARK: - Events using structs

struct Input {
    var viewDidLoad: (() -> ())?
    var viewWillAppear: (() -> ())?
    
    var buttonDidTap: (() -> ())?
}

struct Output {
    var dummyClosure: (() -> ())?
}

protocol IStructViewModel: AnyObject {
    var output: Output { get set }
}

final class StructViewModel: IStructViewModel {
    
    var input: Input = Input()
    
    var output: Output = Output()
    
    init() {
        input.viewDidLoad = {}
        input.viewWillAppear = {}
        input.buttonDidTap = {}
    }
    
}

// MARK: - ViewController

final class SViewController: UIViewController {
    var viewModel: IStructViewModel?
}

extension SViewController {
    func registerOutputs() {
        viewModel?.output.dummyClosure = {
            
        }
    }
}
