//: [Previous](@previous)

import SwiftUI
import UIKit
import PlaygroundSupport

struct FormattedText: UIViewRepresentable, SearchSetData {
    typealias UIViewType = UILabel
    let rawText: String
    private var dynamicHeight: Binding<CGFloat>
    
    init(code: String,
         dynamicHeight: Binding<CGFloat>) {
        self.rawText = code
        self.dynamicHeight = dynamicHeight
    }
    
    /// Apply style for each matching word
    /// - Parameters:
    ///   - attributedText: Source code as attributed string
    ///   - regex: Compiled regular expression
    ///   - color: Applicable text color
    private func processMatches(attributedText: inout NSMutableAttributedString,
                                regex: NSRegularExpression,
                                color: Color) {
        let originalText = attributedText.string
        
        let ofRange = NSRange(originalText.startIndex..<originalText.endIndex, in: originalText)
        
        regex.enumerateMatches(in: originalText, range: ofRange) { (match, _, stop) in
            guard let match = match else { return }

            attributedText.addAttributes([
                .foregroundColor: UIColor(color)
            ], range: match.range)
        }

    }
        
    func makeUIView(context: Context) -> UILabel {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        lbl.setContentCompressionResistancePriority(.defaultLow,
                                                    for: .horizontal)
        lbl.font = UIFont(name: "Menlo", size: 12)
        
        return lbl
    }
    
    func updateUIView(_ uiView: UILabel, context: Context) {
        var attrSource = NSMutableAttributedString(string: rawText)
        
        // Go through each search set and format the code
        searchSets.forEach { searchSet in
            searchSet.words?.forEach({ word in
                // Compile regular expression
                guard let regex = try? NSRegularExpression(pattern: searchSet.regexPattern(word)) else {
                    fatalError("Failed to create regular expression: \(word)")
                }
                
                processMatches(attributedText: &attrSource,
                               regex: regex,
                               color: searchSet.color)
            })
        }

        uiView.attributedText = attrSource
        
        // Gets the final height of this control, and set the binding value.
        DispatchQueue.main.async {
            dynamicHeight.wrappedValue = uiView.sizeThatFits(
                CGSize(width: uiView.bounds.width,
                       height: CGFloat.greatestFiniteMagnitude)
            ).height
        }
    }
}

struct CodeBlockView: View {
    private let codeLines: Array<Substring>
    private let highlightRows: Set<Int>
    private let showLineNumber: Bool
    @State private var height: CGFloat = .zero
    
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
                            FormattedText(code: String(codeLines[idx]),
                                          dynamicHeight: $height)
                            .frame(maxHeight: height)
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
    var a = [Highlight(5), Highlight(rangeOf: 11...14), Highlight(16)]
    
    var body: some View {
        VStack {
            CodeBlockView(code: Sample.data.code)
            CodeBlockView(code: Sample.data.code, showLineNumbers: true)
            CodeBlockView(code: Sample.data.code, highlightAt: Sample.data.rows)
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
