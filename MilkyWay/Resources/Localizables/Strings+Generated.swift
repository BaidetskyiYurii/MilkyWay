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
  internal enum Home {
    /// Log Out
    internal static let logOut = LS.tr("Localizable", "home.logOut", fallback: "Log Out")
    /// Home
    internal static let title = LS.tr("Localizable", "home.title", fallback: "Home")
    /// Try Modal
    internal static let tryModal = LS.tr("Localizable", "home.tryModal", fallback: "Try Modal")
  }
  internal enum Profile {
    /// Profile
    internal static let title = LS.tr("Localizable", "profile.title", fallback: "Profile")
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
