import Foundation

//struct Foo {
//    let i64: Int64
//    let i8: Int8
//}
//let layout = MemoryLayout<Foo>.self
//print(layout.size) // розмір враховуючи вирівнювання
//print(layout.alignment) // найближче більше кратне
//print(layout.stride) // вирівнювання ( )

class TreeNode {
    var val: Int
    var left: TreeNode?
    var right: TreeNode?
    
    init() {
        self.val = 0
        self.left = nil
        self.right = nil
    }
    
    init(_ val: Int) {
        self.val = val
        self.left = nil
        self.right = nil
    }
    
    init(_ val: Int, _ left: TreeNode?, _ right: TreeNode?) {
        self.val = val
        self.left = left
        self.right = right
    }
}

class Solution {
    func maxDepth(_ root: TreeNode?) -> Int {
        guard let root = root else {
            return 0
        }

        let right = maxDepth(root.left)
        let left = maxDepth(root.right)
        
        return (right > left ? right : left) + 1
    }
    
    func hasPathSum(_ root: TreeNode?, _ targetSum: Int) -> Bool {
        guard let root = root else {
            return false
        }
        
        let currentValue = targetSum - root.val
        let hasSum = currentValue == 0 && root.isLeaf
        return hasSum || hasPathSum(root.right, currentValue) || hasPathSum(root.left, currentValue)
    }
    
    func isSameTree(_ p: TreeNode?, _ q: TreeNode?) -> Bool {
        if p == nil && q == nil {
            return true
        }
        
        guard let p = p, let q = q else {
            return false
        }
        
        var array1: [Int?] = []
        var array2: [Int?] = []
        
        p.toArray(&array1)
        q.toArray(&array2)
        
        return array1 == array2
    }
    
    func isBalanced(_ root: TreeNode?) -> Bool {
        guard let root = root else {
            return false
        }
              
        guard let rightVal = root.right?.val,
              let leftVal = root.left?.val else {
            
            return false
        }
        
        let foo = rightVal + 1 != leftVal && rightVal - 1 != leftVal
        
        if foo && root.isLeaf {
            return true
        }
                
        return foo ? (isBalanced(root.right) || isBalanced(root.left)) : false
    }
        
}

extension TreeNode {
    func toArray(_ array: inout [Int?]) {
        guard !isLeaf else {
            array.append(self.val)
            return
        }
        
        array.append(contentsOf: [val, self.left?.val, self.right?.val])
        
        self.left?.toArray(&array)
        self.right?.toArray(&array)
    }
    
    var isLeaf: Bool {
        self.right == nil && self.left == nil
    }
}

let node = TreeNode(1, TreeNode(2), TreeNode(7, TreeNode(5), TreeNode(3)))

let solution = Solution()
print(solution.isBalanced(node))
