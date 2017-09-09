//
//  AppDelegate.swift
//  PastePad
//
//  Copyright © 2017 Mark Rigby-Jones. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    /*
    var windows = NSMutableSet()
    var preferences: PreferencesController?
    */

    func applicationWillFinishLaunching(_ aNotification: Notification) {
        UserDefaults.standard.register(defaults: [
            TextModeKey: TextModeDefault.rawValue,
            InspectorKey: InspectorDefault,
            RulerKey: RulerDefault,
            TextMode.rich.fontKey: fontToName(TextMode.rich.userFontOfSize(0.0)),
            TextMode.plain.fontKey: fontToName(TextMode.plain.userFontOfSize(0.0))
        ])
    }
    
    /*
    // TODO is this needed?
    func windowWillClose(_ controller: PadController) {
        windows.remove(controller)
        
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
        UserDefaults.standard.synchronize()
        preferences = nil
    }
    */
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}
