# Entrupy SDK for iOS
The Entrupy SDK for iOS allows you to integrate Entrupy's sneaker authentication functionality into your Swift or Obj-C app with just a few lines of code.

## 1. Registering your application
Contact developer@entrupy.com to get your app’s bundle ID registered with entrupy. Include details about how you plan to use Entrupy in your app. If approved, you will be issued a License Key to use the SDK and credentials to run this app. 

## 2. Swift Package Manager (Recommended)
Integrating the Entrupy SDK with your app currently requires Swift Package Manager (SPM) or CocoaPods to handle dependencies and versioning. In this project we are using the SPM.
   To add the EntrupySDK package to your project:
   1. In Xcode, go to File → Add Package Dependencies...
   2. Enter: `https://github.com/entrupy/entrupy-sdk-iOS`
   3. Select your version rule and add to your target

### 2.1 How to use with CocoaPods 
Add the EntrupySDK pod in the app target of your Podfile and then run pod install to add the EntrupySDK framework to your application.
```
target 'app' do
  pod 'EntrupySDK'
end
```
Then run:
```
  pod install
```

After the first installation, in order to update to the latest SDK version later, run:
```
  pod update EntrupySDK
```

### SDK Versions
Refer to the [release page](https://github.com/entrupy/entrupy-sdk-iOS/releases) for version numbers and update the SPM/Podfile with the version you wish to download. You can also manually download and link the EntrupySDK framework.

## 3. Supported iOS Versions
The Entrupy SDK supports iOS 15.8 and up.

## 4. Importing the SDK
`import EntrupySDK`

## 5. Usage
[https://developer.entrupy.com/v1_2_entrupy_sdk.html](https://developer.entrupy.com/docs/mobile-sdks/ios/overview)


---
SDK Version: 2.3.0
