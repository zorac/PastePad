import AppKit

/**
 * NSFont extension for converting to/from names.
 *
 * - Author: Mark Rigby-Jones
 * - Copyright: © 2019 Mark Rigby-Jones. All rights reserved.
 */
extension NSFont {
    /// The maximum point size to allow.
    static let maxPoints = 288.0
    
    /// The name of this font.
    var name: String {
        return "\(self.pointSize)pt \(self.displayName!)"
    }
    
    /**
     * Create a font for a given name.
     *
     * - Parameter name: A font name.
     * - Parameter textMode: A text mode.
     * - Returns: The named font, or the default font for the given text mode
     */
    static func fromName(_ name: String, textMode: TextMode) -> NSFont {
        let scanner = Scanner(string:name)
        var points: Double = 0.0
        var face: NSString?
        
        scanner.scanDouble(&points)
        scanner.scanString("pt", into: nil);
        scanner.scanUpToCharacters(from: .newlines, into: &face)
        
        if points > maxPoints {
            points = maxPoints
        }
        
        if let font = NSFont(name: face! as String, size: CGFloat(points)) {
            return font
        } else {
            return textMode.userFontOfSize(CGFloat(points))
        }
    }
}
