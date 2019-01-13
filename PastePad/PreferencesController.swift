import AppKit

/**
 * Preferences view controller.
 *
 * - Author: Mark Rigby-Jones
 * - Copyright: © 2014-2019 Mark Rigby-Jones. All rights reserved.
 */
class PreferencesController : NSWindowController, NSFontChanging {
    /// The shared font manager.
    let fontManager = NSFontManager.shared
    /// The text mode of the most recently clicked font select button.
    var textMode: TextMode?
    
    /// Action to display the font pane for a font-select button.
    @IBAction func displayFontPanel(_ sender: NSView) {
        textMode = TextMode(rawValue: sender.tag)
        
        if let mode = textMode {
            let font = NSFont.fromName(mode.fontKey.stringValue(), textMode: mode)
            
            fontManager.setSelectedFont(font, isMultiple: false)
            fontManager.orderFrontFontPanel(self)
        }
    }
    
    func validModesForFontPanel(_ fontPanel: NSFontPanel) -> NSFontPanel.ModeMask {
        return [ .face, .size, .collection ]
    }
    
    func changeFont(_ sender: NSFontManager?) {
        if let mode = textMode {
            let oldFont = NSFont.fromName(mode.fontKey.stringValue(), textMode: mode)
            let newFont = fontManager.convert(oldFont)
            let name = newFont.name
            
            mode.fontKey.set(value: name)
        }
    }
}
