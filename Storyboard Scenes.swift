// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

// swiftlint:disable sorted_imports
import Foundation
import UIKit

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length implicit_return

// MARK: - Storyboard Scenes

// swiftlint:disable explicit_type_interface identifier_name line_length type_body_length type_name
internal enum StoryboardScene {
  internal enum CaseStudy: StoryboardType {
    internal static let storyboardName = "CaseStudy"

    internal static let initialScene = InitialSceneType<UIKit.UINavigationController>(storyboard: CaseStudy.self)
  }
  internal enum Exam: StoryboardType {
    internal static let storyboardName = "Exam"

    internal static let initialScene = InitialSceneType<UIKit.UINavigationController>(storyboard: Exam.self)
  }
  internal enum LaunchScreen: StoryboardType {
    internal static let storyboardName = "LaunchScreen"

    internal static let initialScene = InitialSceneType<UIKit.UIViewController>(storyboard: LaunchScreen.self)
  }
  internal enum Login: StoryboardType {
    internal static let storyboardName = "Login"

    internal static let initialScene = InitialSceneType<PetHospital_iOS.LoginViewController>(storyboard: Login.self)

    internal static let loginPasswordViewController = SceneType<PetHospital_iOS.LoginPasswordViewController>(storyboard: Login.self, identifier: "loginPasswordViewController")

    internal static let loginViewController = SceneType<PetHospital_iOS.LoginViewController>(storyboard: Login.self, identifier: "loginViewController")

    internal static let registerPasswordViewController = SceneType<PetHospital_iOS.RegisterPasswordViewController>(storyboard: Login.self, identifier: "registerPasswordViewController")
  }
  internal enum Main: StoryboardType {
    internal static let storyboardName = "Main"

    internal static let initialScene = InitialSceneType<PetHospital_iOS.MainTabBarController>(storyboard: Main.self)

    internal static let mainTabBarController = SceneType<PetHospital_iOS.MainTabBarController>(storyboard: Main.self, identifier: "mainTabBarController")
  }
  internal enum RolePlaying: StoryboardType {
    internal static let storyboardName = "RolePlaying"

    internal static let initialScene = InitialSceneType<UIKit.UINavigationController>(storyboard: RolePlaying.self)
  }
  internal enum Touring: StoryboardType {
    internal static let storyboardName = "Touring"

    internal static let initialScene = InitialSceneType<UIKit.UINavigationController>(storyboard: Touring.self)
  }
}
// swiftlint:enable explicit_type_interface identifier_name line_length type_body_length type_name

// MARK: - Implementation Details

internal protocol StoryboardType {
  static var storyboardName: String { get }
}

internal extension StoryboardType {
  static var storyboard: UIStoryboard {
    let name = self.storyboardName
    return UIStoryboard(name: name, bundle: BundleToken.bundle)
  }
}

internal struct SceneType<T: UIViewController> {
  internal let storyboard: StoryboardType.Type
  internal let identifier: String

  internal func instantiate() -> T {
    let identifier = self.identifier
    guard let controller = storyboard.storyboard.instantiateViewController(withIdentifier: identifier) as? T else {
      fatalError("ViewController '\(identifier)' is not of the expected class \(T.self).")
    }
    return controller
  }

  @available(iOS 13.0, tvOS 13.0, *)
  internal func instantiate(creator block: @escaping (NSCoder) -> T?) -> T {
    return storyboard.storyboard.instantiateViewController(identifier: identifier, creator: block)
  }
}

internal struct InitialSceneType<T: UIViewController> {
  internal let storyboard: StoryboardType.Type

  internal func instantiate() -> T {
    guard let controller = storyboard.storyboard.instantiateInitialViewController() as? T else {
      fatalError("ViewController is not of the expected class \(T.self).")
    }
    return controller
  }

  @available(iOS 13.0, tvOS 13.0, *)
  internal func instantiate(creator block: @escaping (NSCoder) -> T?) -> T {
    guard let controller = storyboard.storyboard.instantiateInitialViewController(creator: block) else {
      fatalError("Storyboard \(storyboard.storyboardName) does not have an initial scene.")
    }
    return controller
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
