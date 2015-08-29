//
//  AppDelegate.swift
//  PastePad
//
//  Created by Mark Rigby-Jones on 13/07/2014.
//  Copyright (c) 2014 Mark Rigby-Jones. All rights reserved.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    var windows = NSMutableSet()
    var preferences: PreferencesController?

    func applicationDidFinishLaunching(notification: NSNotification) {
        NSUserDefaults.standardUserDefaults().registerDefaults([
            TextModeKey: TextModeDefault.rawValue,
            InspectorKey: InspectorDefault,
            RulerKey: RulerDefault,
            TextMode.Rich.fontKey: fontToName(TextMode.Rich.userFontOfSize(0.0)),
            TextMode.Plain.fontKey: fontToName(TextMode.Plain.userFontOfSize(0.0))
        ])
        
        self.newWindow(self)
    }
    
    @IBAction func newWindow(_: AnyObject) {
        let controller = PadController(window: nil)
        
        controller.showWindow(self)
        controller.window!.makeKeyAndOrderFront(self)

        windows.addObject(controller)
    }
    
    func windowWillClose(controller: PadController) {
        windows.removeObject(controller)
        
        if (windows.count == 0) {
            preferences?.close()
        }
    }

    @IBAction func showPreferences(_: AnyObject) {
        if (preferences == nil) {
            preferences = PreferencesController(window: nil)
            preferences!.showWindow(self)
        }
        
        preferences!.window!.makeKeyAndOrderFront(self)
    }
    
    func preferencesWillClose() {
        NSUserDefaults.standardUserDefaults().synchronize()
        preferences = nil
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool {
        return true
    }
}

