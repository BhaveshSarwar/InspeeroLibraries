# Inspeero Libraries for iOS

Inspeero Libraries for iOS helps developers execute **inspeero custom components**. Developed by a core team of engineers, these components enable a reliable development workflow to build beautiful and functional iOS apps.

Inspeero Libraries for iOS are written in Objective-C and support Swift and Interface Builder.

## Status
| Component      | StartDate   | EndDate     | Status         | DemoApplication |
|----------------|-------------|-------------|----------------|-----------------|
| InAppPurchase  | 9-JAN-2019  | 10-JAN-2019 | Ready For Test | Done            |
| XMPPClient     | 10-JAN-2019 | 11-JAN-2019 | Ready For Test | Done            |
| NetworkManager | 14-JAN-2019 |             | In Progress    |                 |

## Libraries

- [InAppPurchase](Components/InAppPurchase)
- [XMPPClient](Components/XMPPClient)

## Trying out Inspeero Components

[CocoaPods](https://cocoapods.org/) is the easiest way to get started (if you're new to CocoaPods,
check out their [getting started documentation](https://guides.cocoapods.org/using/getting-started.html).)

To install CocoaPods, run the following commands:

```bash
sudo gem install cocoapods
```

Our [catalog](catalog/) showcases Material Components. You can use the `pod try` command from anywhere on your machine to try the components, even if you haven't checked out the repo yet:

``` bash
pod try InspeeroLibs
```

## Requirements

- Xcode 9 or higher
- Minimum iOS deployment target of 8.0 or higher
- CocoaPods 1.5 or higher
