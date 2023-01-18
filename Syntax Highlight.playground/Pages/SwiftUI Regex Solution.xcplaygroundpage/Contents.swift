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
            codeLines = [Substring(code)]
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
                                regex: Regex<Substring>,
                                color: Color) {
        
        // Get raw source code
        let originalText: String = (
            attributedText.characters.compactMap { c in
                String(c)
            } as [String]).joined()
        
        originalText.matches(of: regex).forEach { match in
            if let swiftRange = Range(match.range, in: attributedText) {
                attributedText[swiftRange][
                    AttributeScopes
                        .SwiftUIAttributes.ForegroundColorAttribute.self
                ] = color
            }
        }
    }
    
    /// Syntax highlight the source  code
    /// - Parameter code: Raw source code
    /// - Returns: Syntax highlighted source code
    func syntaxHighlight(_ code: String) -> AttributedString {
        var attrInText: AttributedString = AttributedString(code)
        
        searchSets.forEach { searchSet in
            searchSet.words?.forEach({ word in
                guard let regex = try? Regex<Substring>(searchSet.regexPattern(word)) else {
                    fatalError("Failed to create regular expession")
                }
                processMatches(attributedText: &attrInText,
                               regex: regex,
                               color: searchSet.color)
            })
        }
        

        return attrInText
    }

    let borderColor = Color(red: 0.5, green: 0.5, blue: 0.5)
    let bgColor = Color(red: 0.9, green: 0.9, blue: 0.9)
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 5) {
                if (self.showLineNumber) {
                    VStack(alignment: .trailing) {
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
        .background(bgColor)
        .cornerRadius(5)
        .overlay(
            RoundedRectangle(cornerRadius: 5, style: .continuous)
                .stroke(borderColor, lineWidth: 2)
        )
    }
}

struct MasterPageView: View {
    var body: some View {
        VStack(alignment: .leading) {
            CodeBlockView(code: Sample.data.code)
            CodeBlockView(code: Sample.data.code,
                          showLineNumbers: true)
            CodeBlockView(code: Sample.data.code,
                          highlightAt: Sample.data.rows)
            CodeBlockView(code: Sample.data.code,
                          highlightAt: Sample.data.rows,
                          showLineNumbers: true)
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

//let view = MasterPageView()
//PlaygroundPage.current.setLiveView(view)

PlaygroundPage.current.setLiveView(MasterPageView_Previews.previews)

//: [Next](@next)
