import Foundation
import SwiftUI

public struct SearchSet {
    public let words: [String]?
    public let regexPattern: (String) -> String
    public let color: Color
    
    public init(words: [String]? = nil,
         regexPattern: @escaping (String) -> String,
         color: Color) {
        self.words = words ?? [""]
        self.regexPattern = regexPattern
        self.color = color
    }
}

public protocol SearchSetData {}

public extension SearchSetData {
    var searchSets: [SearchSet] {
        // Combine all Swift keywords
        let declarations = [
            "associatedtype", "class", "deinit", "enum", "extension",
            "fileprivate", "func", "import", "init", "inout",
            "internal", "let", "open", "operator", "private",
            "precedencegroup", "protocol", "public", "rethrows", "static",
            "struct", "subscript", "typealias", "var"
        ]
        
        let statements = [
            "break", "case", "catch", "continue", "default",
            "defer", "do", "else", "fallthrough", "for",
            "guard", "if", "in", "repeat", "return",
            "throw", "switch", "where", "while"
        ]
        
        let types = [
            "Any", "as", "catch", "false", "is",
            "nil", "rethrows", "self", "Self", "super",
            "throw", "throws", "true", "try"
        ]
        
        let pattern = ["_"]
        
        let directives = [
            "#available", "#colorLiteral", "#column", "#dsohandle", "#elseif",
            "#else", "#endif", "#error", "#fileID", "#fileLiteral",
            "#filePath", "#file", "#function", "#if", "#imageLiteral",
            "#keyPath", "#line", "#selector", "#sourceLocation", "#warning"
        ]
        
        let others = [
            "associativity", "convenience", "didSet", "dynamic", "final",
            "get", "indirect", "infix", "lazy", "left",
            "mutating", "none", "nonmutating", "optional", "override",
            "postfix", "precedence", "prefix", "Protocol", "required",
            "right", "set", "some", "Type", "unowned",
            "weak", "willSet"
        ]

        let swiftKeywords = (declarations + statements + types + pattern + directives + others).map({ "\\b\($0)\\b"}).joined(separator: "|")

        return [
            SearchSet(regexPattern: { _ in "\(swiftKeywords)" },
                      color: Color(red: 0.615, green: 0.196, blue: 0.659)),
            SearchSet(regexPattern: { _ in "\\u0040?\\b[A-Z]\\w+\\b" },
                      color: Color(red: 0.196, green: 0.392, blue: 0.659)),
            
            // This highlights a small set of operators
//            SearchSet(regexPattern: { _ in "\\s[\\+\\-\\*\\/]\\s|\\s->\\s" },
//                      color: Color.orange)
        ]
    }
}
