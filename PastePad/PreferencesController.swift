//
//  PreferencesController.swift
//  PastePad
//
//  Created by Mark Rigby-Jones on 13/07/2014.
//  Copyright (c) 2014 Mark Rigby-Jones. All rights reserved.
//

import Cocoa

class PreferencesController: NSWindowController, NSWindowDelegate {
    let defaults = NSUserDefaults.standardUserDefaults()
    let fontManager = NSFontManager.sharedFontManager()

    var textMode: TextMode?;
    
    override var windowNibName: String! {
        return "Preferences"
    }

    @IBAction func displayFontPanel(sender: NSView) {
        textMode = TextMode(rawValue: sender.tag)
        
        if let mode = textMode {
            let font = nameToFont(defaults.stringForKey(mode.fontKey)!, mode)
    
            fontManager.setSelectedFont(font, isMultiple: false)
            fontManager.orderFrontFontPanel(self)
        }
    }
    
    override func validModesForFontPanel(fontPanel: NSFontPanel) -> Int {
        return Int(NSFontPanelFaceModeMask | NSFontPanelSizeModeMask | NSFontPanelCollectionModeMask)
    }
    
    override func changeFont(sender: AnyObject!) {
        if let mode = textMode {
            let oldFont = nameToFont(defaults.stringForKey(mode.fontKey)!, mode)
            let newFont = fontManager.convertFont(oldFont)
            let name = fontToName(newFont)
                
            defaults.setObject(name, forKey:mode.fontKey)
        }
    }

    func windowWillClose(notification: NSNotification!) {
        let appDelegate = NSApplication.sharedApplication().delegate as AppDelegate
        
        appDelegate.preferencesWillClose()
    }
}
