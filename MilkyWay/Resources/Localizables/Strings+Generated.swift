// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum LS {
  internal enum Common {
    /// Please check your internet connection and try again
    internal static let checkInternetConnection = LS.tr("Localizable", "common.checkInternetConnection", fallback: "Please check your internet connection and try again")
    /// Error
    internal static let error = LS.tr("Localizable", "common.error", fallback: "Error")
    /// No internet connection
    internal static let noInternetConnection = LS.tr("Localizable", "common.noInternetConnection", fallback: "No internet connection")
    /// OK
    internal static let ok = LS.tr("Localizable", "common.ok", fallback: "OK")
  }
  internal enum Explore {
    /// Explore
    internal static let navTitle = LS.tr("Localizable", "explore.nav_title", fallback: "Explore")
  }
  internal enum Map {
    /// Log Out
    internal static let logOut = LS.tr("Localizable", "map.logOut", fallback: "Log Out")
    /// Map
    internal static let navTitle = LS.tr("Localizable", "map.nav_title", fallback: "Map")
    /// Try Modal
    internal static let tryModal = LS.tr("Localizable", "map.tryModal", fallback: "Try Modal")
  }
  internal enum Profile {
    /// Profile
    internal static let navTitle = LS.tr("Localizable", "profile.nav_title", fallback: "Profile")
  }
  internal enum Routes {
    /// Routes
    internal static let navTitle = LS.tr("Localizable", "routes.nav_title", fallback: "Routes")
  }
  internal enum SignIn {
    /// Tap to Sign in
    internal static let tapToSignIn = LS.tr("Localizable", "signIn.tapToSignIn", fallback: "Tap to Sign in")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension LS {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
