//
//  PropertyService.swift
//  MultithreadingTask
//
//  Created by Jackson  on 30.01.2022.
//

import Foundation

struct DataNode {
    var data: [Int]
    var nodeIndex: Int
}

final class PropertyService {
    
    var array = [1,2,3]

    var semaphore = DispatchSemaphore(value: 1)
    
    func mutateData() {
        semaphore.wait() // -1

        if array.count > 3 { array.removeLast() }
        else { array.append(3) }
        print(array)

        semaphore.signal() // +1
    }
    
}
