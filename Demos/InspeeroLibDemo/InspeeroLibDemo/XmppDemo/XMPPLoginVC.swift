//
//  XMPPLoginVC.swift
//  InspeeroLibDemo
//
//  Created by Bhavesh Sarwar on 10/01/19.
//  Copyright © 2019 Bhavesh Sarwar. All rights reserved.
//

import UIKit
import XMPPFramework
import InspeeroLibs

class XMPPLoginVC: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var serverURLTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passWordTextField: UITextField!
    @IBOutlet weak var logsTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        serverURLTextField.text = "vps3.inspeero.com"
        userNameTextField.text = "pranay"
        passWordTextField.text = "Qwerty123"
        
        // Do any additional setup after loading the view.
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        ILXmppManager.shared.disconnect()
    }
    
    @IBAction func loginAction(_ sender: Any) {
        loginButton.setTitle("Connecting", for: .normal)
        
        ILXmppManager.shared.streamDelegate = self
        try! ILXmppManager.shared.createConnection(hostName: serverURLTextField.text!,
                                                 userJIDString: userNameTextField.text!,
                                                 password: passWordTextField.text!)
        
        
    }
    
    @IBAction func sendIQAction(_ sender: Any) {
    
    
    }
    @IBAction func sendMessageAction(_ sender: Any) {
        
//        XmppManager.shared.sendMessage(message: "Dummy Message", to: XMPPJID.init(string: "akash")!)
    }
    @IBAction func clearLogsAction(_ sender: Any) {
        logsTextView.text = "LOGS >>"
    }
    @IBAction func disconnectAction(_ sender: Any) {
        ILXmppManager.shared.disconnect()
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func logTextView(message:String){
        logsTextView.text = "\(logsTextView.text!) \n >>> \(message) \n"
        let bottom = NSMakeRange(logsTextView.text.count - 1, 1)
        logsTextView.scrollRangeToVisible(bottom)

    }

}

extension XMPPLoginVC:XMPPStreamDelegate{
    func xmppStreamDidConnect(_ sender: XMPPStream) {
        DispatchQueue.main.async {
            self.loginButton.setTitle("Connected", for: .normal)
            self.logTextView(message: "Stream : Connected")
        }
        
    }
    func xmppStreamDidAuthenticate(_ sender: XMPPStream) {
        DispatchQueue.main.async {
            self.loginButton.setTitle("Autheticated", for: .normal)
            self.logTextView(message: "Stream : Autheticated")
        }
    }
    
    func xmppStreamWasTold(toDisconnect sender: XMPPStream) {
        self.logTextView(message: "Stream : Disconnected")
    }
    
    
    func xmppStream(_ sender: XMPPStream, didReceiveError error: DDXMLElement) {
        self.logTextView(message: "StreamError : \(error.description)")
    }
    func xmppStream(_ sender: XMPPStream, didSend presence: XMPPPresence) {
        self.logTextView(message: "Stream : presence sent")
    }
    func xmppStream(_ sender: XMPPStream, didReceive iq: XMPPIQ) -> Bool {
        self.logTextView(message: "Stream :  iq received \n \(iq.description)")
        return true
    }
    func xmppStream(_ sender: XMPPStream, didSend message: XMPPMessage) {
        self.logTextView(message: "Stream : message sent")
    }
    
    func xmppStream(_ sender: XMPPStream, didReceive message: XMPPMessage) {
        self.logTextView(message: "Stream : message received")
    }
    
}
