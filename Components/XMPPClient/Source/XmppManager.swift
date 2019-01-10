//
//  XmppManager.swift
//  XmppClient
//
//  Created by Bhavesh Sarwar on 12/12/18.
//  Copyright © 2018 Bhavesh Sarwar. All rights reserved.
//

import UIKit
import XMPPFramework

@objc protocol XMPPManagerDelegates {
    @objc optional func messageReceived(message:XMPPMessage)
    @objc optional func receivedIq(data: Data , iq : XMPPIQ)
    
    
}

class XmppManager: NSObject {

    
    static let shared = XmppManager()
    var xmppStream:XMPPStream?
    var delegate:XMPPManagerDelegates?
    var streamDelegate:XMPPStreamDelegate?
    var hostName: String = ""
    var userJID: XMPPJID?
    var hostPort: UInt16 = 5222
    var password: String = ""
    var presenceTimer:Timer?
    
    
    private override init() {
        super.init()
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(startPresenceTimer),
                                       name: UIApplication.willEnterForegroundNotification, object: nil)
        startPresenceTimer()
        
    }

    enum XMPPControllerError: Error {
        case wrongUserJID
    }

    /// Connection creation
    func createConnection(hostName: String, userJIDString: String, hostPort: UInt16 = 5222, password: String) throws{
        guard let userJID = XMPPJID(string: userJIDString) else {
            throw XMPPControllerError.wrongUserJID
        }
        
        self.hostName = hostName
        self.userJID = userJID
        self.hostPort = hostPort
        self.password = password
        
        // Stream Configuration
        self.xmppStream = XMPPStream()
        self.xmppStream!.hostName = hostName
        self.xmppStream!.hostPort = hostPort
        self.xmppStream!.startTLSPolicy = XMPPStreamStartTLSPolicy.allowed
        self.xmppStream!.myJID = userJID
        self.xmppStream!.addDelegate(self, delegateQueue: DispatchQueue.main)
        if streamDelegate != nil{
            self.xmppStream!.addDelegate(streamDelegate!, delegateQueue: DispatchQueue.main)
        }

        connect()
    }

    func connect() {
        if !self.xmppStream!.isDisconnected {
            return
        }
        try! self.xmppStream!.connect(withTimeout: XMPPStreamTimeoutNone)
    }
    
    func diconnect() {
        if xmppStream == nil{ return }
        if self.xmppStream!.isDisconnected {
            return
        }
        self.xmppStream!.disconnect()

    }
    
    
    
    // Presence should be countinues
    @objc func startPresenceTimer(){
        if presenceTimer != nil{
            presenceTimer?.invalidate()
            presenceTimer = nil
        }
        if self.xmppStream != nil{
            presenceTimer =  Timer.scheduledTimer(withTimeInterval: 5, repeats: true) {[unowned self] (timer) in
                let state = UIApplication.shared.applicationState
                if state == .background  || state == .inactive{
                    // background
                    timer.invalidate()
                    self.presenceTimer = nil
                    
                }else if state == .active {
                    // foreground
                    /// This will send user presence if he is online
                    self.xmppStream!.send(XMPPPresence())
                }
            }
        }
        
    }
    
    
    
    /// Messages
    
    func sendMessage(message:String,to:XMPPJID){
        let xmppMessage = XMPPMessage.init(type: message, to: to)
        xmppStream?.send(xmppMessage)
    }
    
    
    
}

extension XmppManager: XMPPStreamDelegate {
    
    
    /// Connections Authentication
    func xmppStreamDidConnect(_ stream: XMPPStream) {
        print("Stream: Connected")
        let auth = XMPPPlainAuthentication(stream: self.xmppStream!, username: self.userJID?.bare, password: self.password)
        try! stream.authenticate(auth)
        
    }
    func xmppStreamDidAuthenticate(_ sender: XMPPStream) {
        self.startPresenceTimer()
        print("Stream: Authenticated")
    }
    func xmppStream(_ sender: XMPPStream, didSend presence: XMPPPresence) {
        print("Stream: Presence sent")
    }
    
    ///Messages Delegates
    func xmppStream(_ sender: XMPPStream, didReceive message: XMPPMessage) {
        if delegate != nil {
            delegate?.messageReceived!(message: message)
            
        }
        print("Stream: Message received")
    }
    
    func xmppStream(_ sender: XMPPStream, willSend message: XMPPMessage) -> XMPPMessage? {
        
        return message
    }
    
    func xmppStream(_ sender: XMPPStream, didFailToSend message: XMPPMessage, error: Error) {
        
    }
    
    // Errors Delegates
    
    func xmppStreamConnectDidTimeout(_ sender: XMPPStream) {
        print("Stream : connection timeout")
        
 
    }
    
    func xmppStream(_ sender: XMPPStream, didReceiveError error: DDXMLElement) {
        print("Stream: Error ")
        print(error.description)
    }
    
    
    ///IQ
    
    func xmppStream(_ sender: XMPPStream, didReceive iq: XMPPIQ) -> Bool {
        
//        _ = GetGroupListXMLParser().self
        self.delegate?.receivedIq!(data: iq.xmlString.data(using: .utf8)!, iq: iq)
        print("Stream: iq recieved")
        return true
    }
    
    func xmppStream(_ sender: XMPPStream, didSend message: XMPPMessage) {
        print("msg sent")
    }
    
  
    func xmppStreamDidDisconnect(_ sender: XMPPStream, withError error: Error?) {
        
        print("Xmpp connection did disconnected")
    }
    func xmppStream(_ sender: XMPPStream, didSend iq: XMPPIQ) {
        
        print("iq sent")
        
    }
    
    
    
    

}



