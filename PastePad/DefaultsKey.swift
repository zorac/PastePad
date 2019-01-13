import Foundation

/**
 * Enumerates user defaults keys.
 *
 * - Author: Mark Rigby-Jones
 * - Copyright: © 2019 Mark Rigby-Jones. All rights reserved.
 */
enum DefaultsKey : String {
    case inspector = "PPInspector"
    case plainFont = "PPPlainFont"
    case richFont = "PPRichFont"
    case ruler = "PPRuler"
    case textMode = "PPTextMode"
    
    /**
     * Fetch the boolean defaults value for this key.
     *
     * - Returns: The value.
     */
    func boolValue() -> Bool {
        return UserDefaults.standard.bool(forKey: rawValue)
    }
    
    /**
     * Fetch the integer defaults value for this key.
     *
     * - Returns: The value.
     */
    func intValue() -> Int {
        return UserDefaults.standard.integer(forKey: rawValue)
    }
    
    /**
     * Fetch the string defaults value for this key.
     *
     * - Returns: The value.
     */
    func stringValue() -> String {
        return UserDefaults.standard.string(forKey: rawValue) ?? ""
    }
    
    /**
     * Set a boolean defaults value for this key.
     *
     * - Parameter value: The value.
     */
    func set(value: Bool) {
        UserDefaults.standard.set(value, forKey: rawValue)
    }
    
    /**
     * Set an integer defaults value for this key.
     *
     * - Parameter value: The value.
     */
    func set(value: Int) {
        UserDefaults.standard.set(value, forKey: rawValue)
    }
    
    /**
     * Set a string defaults value for this key.
     *
     * - Parameter value: The value.
     */
    func set(value: String) {
        UserDefaults.standard.set(value, forKey: rawValue)
    }
}
