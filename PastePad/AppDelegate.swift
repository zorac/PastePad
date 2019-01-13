import AppKit

/**
 * Application delegate class for PastePad.
 *
 * - Author: Mark Rigby-Jones
 * - Copyright: © 2014-2019 Mark Rigby-Jones. All rights reserved.
 */
@NSApplicationMain
class AppDelegate : NSObject, NSApplicationDelegate {
    func applicationWillFinishLaunching(_ aNotification: Notification) {
        UserDefaults.standard.register(defaults: [
            DefaultsKey.textMode.rawValue: TextMode.rich.rawValue,
            DefaultsKey.inspector.rawValue: true,
            DefaultsKey.ruler.rawValue: false,
            TextMode.rich.fontKey.rawValue: TextMode.rich.userFontOfSize(0.0).name,
            TextMode.plain.fontKey.rawValue: TextMode.plain.userFontOfSize(0.0).name
        ])
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}
