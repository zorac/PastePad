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

    var textMode:TextMode?;

    @IBAction func displayFontPanel(sender:NSView) {
        textMode = TextMode.fromRaw(sender.tag)
        
        if textMode {
            let font = nameToFont(defaults.stringForKey(textMode!.fontKey), textMode!)
    
            fontManager.setSelectedFont(font, isMultiple:false)
            fontManager.orderFrontFontPanel(self)
        }
    }
    
    override func validModesForFontPanel(fontPanel:NSFontPanel!) -> Int {
        return Int(NSFontPanelFaceModeMask | NSFontPanelSizeModeMask | NSFontPanelCollectionModeMask)
    }
    
    override func changeFont(sender:AnyObject!) {
        if textMode {
            let oldFont = nameToFont(defaults.stringForKey(textMode!.fontKey), textMode!)
            let newFont = fontManager.convertFont(oldFont)
            
            if newFont {
                let name = fontToName(newFont)
                
                defaults.setObject(name, forKey:textMode!.fontKey)
            }
        }
    }

    func windowWillClose(notification:NSNotification!) {
        let appDelegate = NSApp.delegate as AppDelegate
        
        appDelegate.preferencesWillClose()
    }
}
