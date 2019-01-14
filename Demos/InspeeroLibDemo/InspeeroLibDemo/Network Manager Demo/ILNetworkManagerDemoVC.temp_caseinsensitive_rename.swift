//
//  IlNetworkManagerDemoVC.swift
//  InspeeroLibDemo
//
//  Created by Bhavesh Sarwar on 14/01/19.
//  Copyright © 2019 Bhavesh Sarwar. All rights reserved.
//

import UIKit
import InspeeroLibs
class ILNetworkManagerDemoVC: UIViewController {

    @IBOutlet weak var verticalStackView: UIStackView!
    @IBOutlet weak var serverURLTextField: UITextField!
    @IBOutlet weak var requestTypeSegment: UISegmentedControl!
    @IBOutlet weak var apiNameTextField: UITextField!
    
    
    @IBOutlet weak var verticalStackViewHeightConstraint: NSLayoutConstraint!
    
    
//    let keyValueView:UIStackView = {
//       let
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        serverURLTextField.text = "http://vps3.inspeero.com:2020/api/"
        apiNameTextField.text = "login"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addKeyValuePairAction(_ sender: Any) {
        
        verticalStackView.addArrangedSubview(keyValueView())
        verticalStackViewHeightConstraint.constant += 30
        
    }
    
    @IBAction func sendRequestAction(_ sender: Any) {
        
//        let requestType = requestTypeSegment.selectedSegmentIndex == 0 ? HTTPMethod.get : HTTPMethods.post
        let parameters = NSMutableDictionary()
        
        for subview in verticalStackView.arrangedSubviews as! [keyValueView]{
            parameters.setValue(subview.valueTextField.text, forKey: subview.keyTextField.text!)
        }
        ILNetworkManager.shared.serverURL = ""
        
        ILNetworkManager.shared.sendRequest(baseUrl:serverURLTextField.text!,
                                            methodType: requestTypeSegment.selectedSegmentIndex == 0 ? .get : .post,
                                            apiName: apiNameTextField.text!,
                                            parameters: (parameters.copy() as! NSDictionary), headers: nil) { (response, error) in
                                                
                                                
                                                
                                                let alertController = UIAlertController()
                                                let alertAction = UIAlertAction.init(title: "Ok", style: .cancel, handler: nil)
                                                alertController.addAction(alertAction)
                                                
                                                if response != nil && error == nil{
                                                    alertController.title = "Response"
                                                    alertController.message = String(describing: response!)
                                                }else{
                                                    alertController.title = "Error"
                                                    alertController.message = error?.localizedDescription
                                                }
                                                
                                                self.present(alertController, animated: true, completion: nil)
        }
    }
    
//    func getKeyValueView()->UIStackView{
//        let keyTextField = UITextField()
//        keyTextField.placeholder = ""
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

class keyValueView:UIStackView{
    let keyTextField = UITextField()
    let valueTextField = UITextField()
    
    let deleteButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        keyTextField.placeholder = "Key"
        valueTextField.placeholder = "Value"
        keyTextField.borderStyle = .bezel
        valueTextField.borderStyle = .bezel
        
        keyTextField.font = UIFont.systemFont(ofSize: 14)
        valueTextField.font = UIFont.systemFont(ofSize: 14)
        
        keyTextField.textColor = UIColor.darkGray
        valueTextField.textColor = UIColor.darkGray
        
        keyTextField.autocapitalizationType = .none
        valueTextField.autocapitalizationType = .none
        
        self.distribution = .fillEqually
        self.addArrangedSubview(keyTextField)
        self.addArrangedSubview(valueTextField)
        
        deleteButton.setTitle("-", for: .normal)
        deleteButton.backgroundColor = UIColor.darkGray
        deleteButton.frame = CGRect(x: CGFloat(valueTextField.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        deleteButton.addTarget(self, action: #selector(self.deleteAction), for: .touchUpInside)
        valueTextField.rightView = deleteButton
        valueTextField.rightViewMode = .always
        
        
//        let keyTextField = UITextField
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func deleteAction(){
        let superStackView = self.superview as! UIStackView
        (self.viewController() as! ILNetworkManagerDemoVC).verticalStackViewHeightConstraint.constant -= 30
        
        superStackView.removeArrangedSubview(self)
        self.removeFromSuperview()
    }
}
extension UIView {
    public func viewController()->UIViewController? {
        
        var nextResponder: UIResponder? = self
        
        repeat {
            nextResponder = nextResponder?.next
            
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
            
        } while nextResponder != nil
        
        return nil
    }
}
