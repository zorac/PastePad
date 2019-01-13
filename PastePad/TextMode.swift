import AppKit

/**
 * Enumerates text modes.
 *
 * - Author: Mark Rigby-Jones
 * - Copyright: © 2019 Mark Rigby-Jones. All rights reserved.
 */
enum TextMode : Int {
    case rich = 0
    case plain = 1
    
    /// If this text mode is rich text.
    var isRich: Bool {
        return self == .rich
    }
    
    /// If this text mode is plain text.
    var isPlain: Bool {
        return self == .plain
    }
    
    /// The file extension for files of this type.
    var fileExtension: String {
        return isRich ? "rtf" : "txt"
    }
    
    /// The file type identifier for this text mode.
    var fileType: String {
        return isRich ? kUTTypeRTF as String : kUTTypePlainText as String
    }
    
    /// The codument type for this text mode.
    var documentType: NSAttributedString.DocumentType {
        return isRich ? .rtf : .plain
    }
    
    /// The defaults key for this mode's default font.
    var fontKey: DefaultsKey {
        return isRich ? .richFont : .plainFont
    }

    /// The other text mode.
    var other: TextMode {
        return isRich ? .plain : .rich
    }
    
    /**
     * Create a user font appropriate to this text mode.
     *
     * - Parameter points: The size of the font to create.
     * - Returns: A font.
     */
    func userFontOfSize(_ points: CGFloat) -> NSFont! {
        return isPlain ? NSFont.userFixedPitchFont(ofSize: points) : NSFont.userFont(ofSize: points)
    }
}
