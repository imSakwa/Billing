//
//  UITextFieldExtension.swift
//  MyBill
//
//  Created by ChangMin on 2022/08/21.
//

import Foundation
import UIKit

extension UITextField {
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
       doneToolbar.barStyle = .default
        
       let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
       let done: UIBarButtonItem = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(doneButtonAction))
        
       let items = [flexSpace, done]
       doneToolbar.items = items
       doneToolbar.sizeToFit()
       self.inputAccessoryView = doneToolbar
   }
    
   @objc func doneButtonAction() {
       self.resignFirstResponder()
   }
    
    func checkMaxLength(textField: UITextField!, maxLength: Int) {
        if (textField.text?.count ?? 0 > maxLength) {
            textField.deleteBackward()
        }
    }
}
