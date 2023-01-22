import Foundation

public struct SampleDataSet {
    public let rows: [Highlight]
    public let code: String
    
    public init(code: String, rowsToHighlight: [Highlight]? = nil) {
        self.rows = rowsToHighlight ?? []
        self.code = code
    }
}

public struct Sample {
    static let dataset1 = SampleDataSet(code: #"""
struct FormattedCodeView: View {
    var sampleCode: String
    var additionalKeywords: [String] = []
    var additionalClasses: [String] = []
    @State private var height: CGFloat = .zero
    
    private let bgColor = Color(red: 0.9, green: 0.9, blue: 0.9)
    private let borderColor = Color(red: 0.5, green: 0.5, blue: 0.5)

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5, style: .continuous)
                .fill(bgColor)
            RoundedRectangle(cornerRadius: 5, style: .continuous)
                .stroke(borderColor, lineWidth: 1)
            ScrollView(.horizontal, showsIndicators: true) {
                FormattedText(string: sampleCode,
                              additionalKeywords: additionalKeywords,
                              dynamicHeight: $height)
                .frame(maxHeight: height)
            }
            .padding(10)
        }
    }
}
"""#, rowsToHighlight: [Highlight(5), Highlight(rangeOf: 16...19)])
    
    static let dataset2 = SampleDataSet(code: #"""
func makeUIView(context: Context) -> UILabel {
    let lbl = UILabel()
    lbl.numberOfLines = 0
    lbl.lineBreakMode = .byWordWrapping
    lbl.setContentCompressionResistancePriority(.defaultLow,
                                                for: .horizontal)
    lbl.font = UIFont(name: "Menlo", size: 15)

    var a = 15 - 3
    var b = 3 * 2
    var c = 15 / 3
    var d = 3 + 4
    
    return lbl
}
"""#, rowsToHighlight: [Highlight(rangeOf: 5...6)])
    
    static let dataset3 = SampleDataSet(code: "var a = String(\"Hello\")",
                                        rowsToHighlight: [Highlight(1)])
    
    static let dataset4 = SampleDataSet(code: #"""
guard let regex = try? Regex<Substring>(searchSet.regexPattern(word)) else {
    fatalError("Failed to create regular expession")
}
"""#,
                                        rowsToHighlight: [Highlight(2)])
    
    static public let data = dataset2
}
