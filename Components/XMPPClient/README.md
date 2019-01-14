# XMPPClient
## Installation

```bash
pod 'InspeeroLibs/XMPPClient'
```

## Usage

```swift
import InspeeroLibs


// Connect to XMPP server and autheticate the user
XmppManager.shared.streamDelegate = self // Setting stream delegates to self will allow to implement stream delegates to be trigger on current view controller 

try! XmppManager.shared.createConnection(hostName: "SERVER URL",
userJIDString: "USERNAME",
password: "PASSWORD")

// For receive purchase Call back first you have to observe the following notification
NotificationCenter.default.addObserver(self, selector: #selector(MasterViewController.handlePurchaseNotification(_:)),
name: .IAPHelperPurchaseNotification,
object: nil)

//Stream Delegates

func xmppStreamDidConnect(_ sender: XMPPStream) {
print("Stream : Connected")
}
func xmppStreamDidAuthenticate(_ sender: XMPPStream) {
print("Stream : Authenticated")
}

func xmppStreamWasTold(toDisconnect sender: XMPPStream) {
print("Stream : Disconnected")
}


func xmppStream(_ sender: XMPPStream, didReceiveError error: DDXMLElement) {
print("Stream : Error occured")
}
func xmppStream(_ sender: XMPPStream, didSend presence: XMPPPresence) {
print("Stream : Presence sent")
}
func xmppStream(_ sender: XMPPStream, didReceive iq: XMPPIQ) -> Bool {
print("Stream : Did receive IQ")
return true
}
func xmppStream(_ sender: XMPPStream, didSend message: XMPPMessage) {
print("Stream : Message Sent)
}

func xmppStream(_ sender: XMPPStream, didReceive message: XMPPMessage) {
print("Stream : Message Received)
}


```
## License
[MIT](https://choosealicense.com/licenses/mit/)
