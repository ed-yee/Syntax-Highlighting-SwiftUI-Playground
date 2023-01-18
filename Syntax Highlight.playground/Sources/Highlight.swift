import Foundation

public struct Highlight: Identifiable {
    public let id = UUID()
    private var lines: [Int] = []
    
    public var values: [Int] {
        lines
    }
    
    public init(_ lineNumber: Int) {
        self.lines.append(lineNumber)
    }
    
    public init(rangeOf: ClosedRange<Int>) {
        for i in rangeOf {
            self.lines.append(i)
        }
    }
}
