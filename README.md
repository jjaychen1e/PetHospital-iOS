# PetHospital-iOS

Just a course project. For more information: [Click here](https://github.com/Onion12138/petHospital).

## Deployment

This is an iOS project, therefore, if you want to deploy it in your iPhone, or run it in an iOS simulator, you need to:

- Get a Mac that runs macOS 10.15.4 or later(Xcode 12 requires macOS 10.15.4 or later).
- Using Xcode 12.4 or later.
- iPhone(or iOS simulator) that runs iOS 14 or later.

We are using [CocoaPods](https://cocoapods.org) to manage dependencies. Considering the size of the repository, we don't upload the dependencies directly. So, first, install CocoaPods if you haven't installed it yet. After installation(or if it's already installed), Run:

`pod install`

to install pod dependencies. After installation, Open `PetHospital-iOS.xcworkspace`(rather than `PetHospital-iOS.xcodeproj`) with Xcode. Note that if you want to install an app into iPhone using Xcode, you need a developer account(free). There's no limitation when installing into iOS simulators.



Now you can choose an iOS simulator(or a real iPhone) and click run in Xcode to install this app.



Note that we support the google sign-in feature, and the client-id we provided should be invalid after the final course presentation. If you want to test the google sign-in feature, you should apply for your client-id. For more information about how the google sign-in SDK works, click [here](https://developers.google.com/identity/sign-in/ios/sdk). We register the google sign-in SDK in `AppDelegate` file, `application(_:didFinishLaunchingWithOptions:)` method. You should replace `GoogleSignIn.plist` with your own, and change `URL types` setting in Xcode project setting(TARGETS-->PetHospital-iOS-->Info-->URL Types).

