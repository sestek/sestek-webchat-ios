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
      let url = "https://nd-test-webchat.sestek.com/chathub"
        let defaultConfiguration = DefaultConfiguration(clientId: "mobile-testing", tenant: "ArabBank", channel: "NdaInfoBip", project: "ArabBank", fullName: "Ömer Sezer")
        let customConfiguration = CustomConfiguration(headerColor: .purple,
                                                      headerText: "Knovvu",
                                                      bottomColor: .black,
                                                      bottomInputText: "Bottom Input Text",
                                                      incomingIcon: .url(url: "https://upload.wikimedia.org/wikipedia/commons/7/70/User_icon_BLACK-01.png"),
                                                      incomingText: "User",
                                                      incomingTextColor: .black,
                                                      outgoingIcon: .image(image: UIImage()),
                                                      outgoingText: "Knovvu",
                                                      outgoingTextColor: .black,
                                                      messageColor: .black,
                                                      messageBoxColor: .white,
                                                      bodyColorOrImage: .color(color: .purple),
                                                      firstIcon: .image(image: UIImage()),
                                                      firstColor: .white,
                                                      firstSize: 70)
        SestekWebChat.shared.initLibrary(url: url, defaultConfiguration: defaultConfiguration, customConfiguration: customConfiguration)

      return true
    }
}
```
Conversation can be start with startConversation method.
```swift
SestekWebChat.shared.startConversation()
```

For other additional information, we have created a document that you can use in the table below.
| props                             | type       | description                                                                                                                  |
| ------------------------------    | ---------- | -------------                                                                                                                |
| startConversation                 | void       | Function that starts the chat for the user and automatically triggers the modal screen.                                      |
| endConversation                   | void       | Function that ends the chat for the user and automatically closes the modal screen.                                          |
| changeRoundedButtonVisibility     | void       | Function that changes visibility of rounded button. |
| triggerVisible                    | void       | Function that opens and closes the modal screen after the chat starts and continues the conversation from where it left off. |