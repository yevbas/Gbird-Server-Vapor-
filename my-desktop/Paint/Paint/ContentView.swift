//
//  ContentView.swift
//  Paint
//
//  Created by Jackson  on 27/08/2022.
//

import SwiftUI
import UIKit

struct ContentView: View {
    var body: some View {
        Canvas { _, _ in
        }
        .frame(width: 300, height: 200)
        .border(Color.blue)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        
    }
}

func add(a: Int, b: Int) -> Int {
    return a + b
}

func devide(a: Int, b: Int) -> Int {
    return a / b
}

class Foo {
    init {
        let result = add(a: 5, b: 7)
        print(result)
    }
}
