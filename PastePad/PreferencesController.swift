//
//  PreferencesController.swift
//  PastePad
//
//  Created by Mark Rigby-Jones on 13/07/2014.
//  Copyright (c) 2014 Mark Rigby-Jones. All rights reserved.
//

import Cocoa

class PreferencesController: NSWindowController, NSWindowDelegate {
    let defaults = UserDefaults.standard
    let fontManager = NSFontManager.shared()

    var textMode: TextMode?;
    
    override var windowNibName: String! {
        return "Preferences"
    }

    @IBAction func displayFontPanel(_ sender: NSView) {
        textMode = TextMode(rawValue: sender.tag)
        
        if let mode = textMode {
            let font = nameToFont(defaults.string(forKey: mode.fontKey)!, textMode: mode)
    
            fontManager.setSelectedFont(font, isMultiple: false)
            fontManager.orderFrontFontPanel(self)
        }
    }
    
    override func validModesForFontPanel(_ fontPanel: NSFontPanel) -> Int {
        return Int(NSFontPanelFaceModeMask | NSFontPanelSizeModeMask | NSFontPanelCollectionModeMask)
    }
    
    override func changeFont(_ sender: Any!) {
        if let mode = textMode {
            let oldFont = nameToFont(defaults.string(forKey: mode.fontKey)!, textMode: mode)
            let newFont = fontManager.convert(oldFont)
            let name = fontToName(newFont)
                
            defaults.set(name, forKey:mode.fontKey)
        }
    }

    func windowWillClose(_ notification: Notification) {
        let appDelegate = NSApplication.shared().delegate as! AppDelegate
        
        appDelegate.preferencesWillClose()
    }
}
