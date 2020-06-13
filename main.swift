import Foundation
import Glibc
 
public class TrieNode {
    
    var key: String?
    var children: [[TrieNode]]
    var isLeaf: Bool
    init() {
        self.children = [[TrieNode]]()
        for _ in 1...26 {
            let subArray = Array<TrieNode>()
            children.append(subArray)
        }
        self.isLeaf = false
    }
}
var root = TrieNode()
let a = "A"
var x: Int = 0
for ascii in a.utf8 {
    x = Int(ascii)
}
func insert(_ keyword: String) {
    var current: TrieNode = root
    for ascii in keyword.utf8 {
        var index = Int(ascii) - x
        if current.children[index].count == 0 {
            var newNode = TrieNode()
            current.children[index].append(newNode)
        }
        current = current.children[index][0]
    }
    current.isLeaf = true
}
let firstLine = readLine()?
.split {$0 == " "}
.map (String.init)
var m = 0
var n = 0
if let words = firstLine {
    for word in words {
        insert(word)
    }
}
let secondLine = readLine()?
.split {$0 == " "}
.map (String.init)

if let sizes = secondLine {
    m = Int(sizes[0])!
    n = Int(sizes[1])!
}
var boggle = [[String]]()
for _ in 1...m {
    let line = readLine()?
    .split {$0 == " "}
    .map (String.init)
    if let newLine = line {
        boggle.append(newLine)
    } 
}
var visited = [[Bool]]()
for _ in 1...m {
    var subArr = [Bool]()
    for _ in 1...n {
        subArr.append(false)
    }
    visited.append(subArr)
}
var output = Set<String>()
func searchWord(_ boggle: [[String]], _ m: Int, _ n: Int, _ i: Int, _ j: Int, _ str: String, _ node: TrieNode) {
    if node.isLeaf {
        output.insert(str)
    } 
    if(i >= 0 && i < m && j >= 0 && j < n && !visited[i][j]) {
        visited[i][j] = true
        for k in 65...90 {
            if node.children[k - 65].count != 0 {
                var ch = String(UnicodeScalar(UInt8(k)))
                if(i + 1 >= 0 && i + 1 < m && j + 1 >= 0 && j + 1 < n && !visited[i + 1][j + 1] && boggle[i + 1][j + 1] == ch) {
                    searchWord(boggle, m, n, i + 1, j + 1, str + ch, node.children[k - 65][0])
                } 
                if(i + 1 >= 0 && i + 1 < m && j >= 0 && j < n && !visited[i + 1][j] && boggle[i + 1][j] == ch) {
                    searchWord(boggle, m, n, i + 1, j, str + ch, node.children[k - 65][0])
                } 
                if(i + 1 >= 0 && i + 1 < m && j - 1 >= 0 && j - 1 < n && !visited[i + 1][j - 1] && boggle[i + 1][j - 1] == ch) {
                    searchWord(boggle, m, n, i + 1, j - 1, str + ch, node.children[k - 65][0])
                } 
                if(i >= 0 && i < m && j - 1 >= 0 && j - 1 < n && !visited[i][j - 1] && boggle[i][j - 1] == ch) {
                    searchWord(boggle, m, n, i, j - 1, str + ch, node.children[k - 65][0])
                } 
                if(i - 1 >= 0 && i - 1 < m && j - 1 >= 0 && j - 1 < n && !visited[i - 1][j - 1] && boggle[i - 1][j - 1] == ch) {
                    searchWord(boggle, m, n, i - 1, j - 1, str + ch, node.children[k - 65][0])
                } 
                if(i - 1 >= 0 && i - 1 < m && j >= 0 && j < n && !visited[i - 1][j] && boggle[i - 1][j] == ch) {
                    searchWord(boggle, m, n, i - 1, j, str + ch, node.children[k - 65][0])
                } 
                if(i - 1 >= 0 && i - 1 < m && j + 1 >= 0 && j + 1 < n && !visited[i - 1][j + 1] && boggle[i - 1][j + 1] == ch) {
                    searchWord(boggle, m, n, i - 1, j + 1, str + ch, node.children[k - 65][0])
                } 
                if(i >= 0 && i < m && j + 1 >= 0 && j + 1 < n && !visited[i][j + 1] && boggle[i][j + 1] == ch) {
                    searchWord(boggle, m, n, i, j + 1, str + ch, node.children[k - 65][0])
                } 
            }
        }
        visited[i][j] = false
    }
}

func findInBoggle(_ boggle: [[String]], _ m: Int, _ n: Int) {
    var parent: TrieNode = root
    var str = ""
    for i in 1...m {
        for j in 1...n {
            var startPoint: String = boggle[i - 1][j - 1]
            var temp = 0
            for ascii in startPoint.utf8 {
                temp = Int(ascii) - x
            }
            if root.children[temp].count != 0 {
                str += startPoint
                searchWord(boggle, m, n, i - 1, j - 1, str, root.children[temp][0])
                str = ""
            }
        }
    }
}
findInBoggle(boggle, m, n)
for item in output {
    print(item)
}
