# sestek-webchat-ios

## GIF animation

![sestek-webchat-ios](https://github.com/sestek/sestek-webchat-ios/blob/main/Gifs/sestek-webchat-ios.gif)

## CocoaPods Installation
For New Install Only
```ruby
pod repo update
```
```ruby
pod 'sestek-webchat-ios'
```

## Usage
In AppDelegate.swift, just import sestek_webchat_ios framework and initialize SestekWebChat.

```swift
import sestek_webchat_ios

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

      SestekWebChat.sharedInstance.initLibrary()

      return true
    }
}
```
Conversation can be start with startConversation method.
```swift
SestekWebChat.sharedInstance.startConversation(clientId: "", tenant: "", channel: "", project: "", fullName: "", UIViewController)
```

For other additional information, we have created a document that you can use in the table below.
| props                             | type       | description                                                                                                                  |
| ------------------------------    | ---------- | -------------                                                                                                                |
| startConversation                 | void       | Function that starts the chat for the user and automatically triggers the modal screen.                                      |
| endConversation                   | void       | Function that ends the chat for the user and automatically closes the modal screen.                                          |
| changeRoundedButtonVisibility     | void       | Function that changes visibility of rounded button. |