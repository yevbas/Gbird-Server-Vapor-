//
//  Closures.swift
//  TemplatesApp
//
//  Created by Jackson  on 04.05.2022.
//

import Foundation

typealias BoolResultClosure = (Result<Bool, Error>) -> ()
typealias ResultClosure<T> = (Result<T, Error>) -> ()
typealias ErrorClosure = (Error?) -> ()
