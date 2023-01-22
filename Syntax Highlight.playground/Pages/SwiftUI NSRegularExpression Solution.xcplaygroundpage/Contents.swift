//: [Previous](@previous)

import SwiftUI
import PlaygroundSupport

struct CodeBlockView: View, SearchSetData {
    private let codeLines: Array<Substring>
    private let highlightRows: Set<Int>
    private let showLineNumber: Bool
    
    init(code: String,
         highlightAt: [Highlight]? = nil,
         showLineNumbers: Bool = false) {
        
        // Collect all highlight row numbers
        var rows: Set<Int> = []
        if let lineNumbers = highlightAt {
            lineNumbers.forEach { group in
                group.values.forEach { row in
                    rows.insert(row)
                }
            }
        }
        self.highlightRows = rows
        
        self.showLineNumber = showLineNumbers
        
        if !showLineNumbers && rows.count == 0 {
            // Create a single element array
            self.codeLines = [Substring(code)]
        } else {
            // Split the codes into individual lines
            self.codeLines = code.split(separator: /\n/)
        }
    }
    
    /// Apply text color against each matching results
    /// - Parameters:
    ///   - attributedText: Source code as attributed string
    ///   - regex: Compiled regular expression
    ///   - color: Applicable text color
    private func processMatches(attributedText: inout AttributedString,
                                regex: NSRegularExpression,
                                color: Color) {
        // Get raw source code
        var originalText: String = (
            attributedText.characters.compactMap { c in
                String(c)
            } as [String]).joined()

        let ofRange = NSRange(location: 0, length: originalText.count)

        // Same as ...
        //        let ofRange = NSMakeRange(0, originalText.count)
        //
        //        or
        //
        //        let ofRange = NSRange(originalText.startIndex..<originalText.endIndex,
        //          in: originalText)

        regex.enumerateMatches(in: originalText, range: ofRange) { (match, _, stop) in
            guard let match = match else { return }
            
            if let swiftRange = Range(match.range, in: attributedText) {
                attributedText[swiftRange].foregroundColor = UIColor(color)
            }
        }

    }
    
    /// Syntax highlight source code
    /// - Parameter code: Raw source code
    /// - Returns: Syntax highlighted source code
    func syntaxHighlight(_ code: String) -> AttributedString {
        var attrInText: AttributedString = AttributedString(code)
        
        searchSets.forEach { searchSet in
            searchSet.words?.forEach({ word in
                guard let regex = try? NSRegularExpression(pattern: searchSet.regexPattern(word)) else {
                    fatalError("Failed to create regular expression: \(word)")
                }
                
                processMatches(attributedText: &attrInText,
                               regex: regex,
                               color: searchSet.color)
            })
        }
        
        return attrInText
    }
    
    private let bgColor = Color(red: 0.9, green: 0.9, blue: 0.9)
    private let borderColor = Color(red: 0.5, green: 0.5, blue: 0.5)

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5, style: .continuous)
                .fill(bgColor)
            RoundedRectangle(cornerRadius: 5, style: .continuous)
                .stroke(borderColor, lineWidth: 1)
            HStack(spacing: 5) {
                if (self.showLineNumber) {
                    VStack(alignment: .trailing, spacing: 0) {
                        ForEach(codeLines.indices, id: \.self) { idx in
                            Text("\(idx+1)")
                                .font(.custom("Menlo", size: 12))
                                .foregroundColor(.white)
                                .padding(EdgeInsets(top: 0, leading: 2, bottom: 0, trailing: 2))
                        }
                    }
                    .background(.blue)
                }
                ScrollView(.horizontal) {
                    VStack(spacing: 0) {
                        ForEach(codeLines.indices, id: \.self) { idx in
                            Text(syntaxHighlight(String(codeLines[idx])))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.custom("Menlo", size: 12))
                                .background(highlightRows.contains(idx+1) ? .yellow : Color.clear)
                        }
                    }
                }
            }
            .padding(10)

        }
    }
}

struct MasterPageView: View {
    var body: some View {
        VStack {
            CodeBlockView(code: Sample.data.code)
            CodeBlockView(code: Sample.data.code, highlightAt: Sample.data.rows)
            CodeBlockView(code: Sample.data.code, showLineNumbers: true)
        }
    }
}

struct MasterPageView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            MasterPageView()
        }
        .padding(10)
        .frame(width: 390, height: 844) // iPhone 14 dimension
        .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
    }
}

PlaygroundPage.current.setLiveView(MasterPageView_Previews.previews)

//: [Next](@next)
