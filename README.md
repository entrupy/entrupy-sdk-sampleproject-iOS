# Entrupy SDK for iOS
The Entrupy SDK for iOS allows you to integrate Entrupy's sneaker authentication functionality into your Swift or Obj-C app with just a few lines of code.

## 1. Registering your application
Contact developer@entrupy.com to get your app’s bundle ID registered with entrupy. Include details about how you plan to use Entrupy in your app. If approved, you will be issued a License Key to use the SDK and credentials to run this app. 

## 2. CocoaPods
Integrating the Entrupy SDK with your app currently requires CocoaPods to handle dependencies and versioning.
Add the EntrupySDK pod in the app target of your Podfile and then run pod install to add the EntrupySDK framework to your application.
```
target 'app' do
  pod 'EntrupySDK' , '2.0.1'
end
```
Refer to the [release page](https://github.com/entrupy/entrupy-sdk-iOS/releases) for version numbers and update the Podfile with the version you wish to download. You can also manually download and link the EntrupySDK framework.

## 3. Supported iOS Versions
The Entrupy SDK supports iOS 15.8 and up.

## 4. Importing the SDK
`import EntrupySDK`

## 5. Usage
[https://developer.entrupy.com/v1_2_entrupy_sdk.html](https://developer.entrupy.com/docs/mobile-sdks/ios/overview)
