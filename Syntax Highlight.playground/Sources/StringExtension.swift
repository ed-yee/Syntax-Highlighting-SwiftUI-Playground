import Foundation
import UIKit

extension String {
    /// Solution from: https://stackoverflow.com/a/58782429
    ///
    /// Get the width of the current String instance with respect to the given font.
    /// - Parameter font: Specific font
    /// - Returns: The width of the current String instance in points
    public func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    public func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }
}
