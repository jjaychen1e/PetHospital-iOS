//
//  RegisterPasswordViewController.swift
//  PetHospital-iOS
//
//  Created by jjaychen on 2021/3/22.
//

import UIKit
import SwiftUI

class RegisterPasswordViewController: UIViewController {
    
    @IBOutlet weak var passwordTextField: UITextField!
    private var continueBarButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTransparentNavigationBarWith(backgroundColor: Asset.dynamicLightGrayBackground.color)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "继续", style: .done, target: self, action: #selector(tryToContinue))
        
        let doneButtonAppearance = UIBarButtonItemAppearance()
        doneButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.systemBlue,
                                                           .font: UIFont.systemFont(ofSize: 16, weight: .semibold)]
        navigationItem.standardAppearance?.doneButtonAppearance = doneButtonAppearance
        navigationItem.compactAppearance?.doneButtonAppearance = doneButtonAppearance
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        self.passwordTextField.delegate = self
        self.passwordTextField.becomeFirstResponder()
    }
    
    @objc
    func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        passwordTextField.resignFirstResponder()
    }
    
    private func checkPasswordInLocal(password: String?) -> Bool {
        guard let password = password else { return false }
        
        return password.count >= 8 && password.count <= 20 && password.allSatisfy({ (character) -> Bool in
            character.isASCII
        })
    }
    
    private func checkRegisterWith(username: String, password: String?, completionHandler: @escaping (Bool) -> ()) {
        guard checkPasswordInLocal(password: password) else {
            ToastHelper.show(emoji: "🙅", title: "密码格式不正确", subtitle: "请保证密码至少包含8个字符，且不超过20个字符。")
            return
        }
        // ... Ask the server
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: UIHostingController(rootView: CircularLoadingView()).view!)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.navigationItem.rightBarButtonItem = self.continueBarButtonItem
            completionHandler(true)
        }
    }
    
    @objc
    private func tryToContinue() {
        checkRegisterWith(username: "", password: passwordTextField.text) { (success) in
            if success {
                self.navigationController?.setViewControllers([StoryboardScene.Main.mainTabBarController.instantiate()], animated: true)
                self.navigationController?.setNavigationBarHidden(true, animated: true)
            } else {
                ToastHelper.show(emoji: "🙅", title: "密码错误", subtitle: "请检查你的密码。")
            }
        }
    }
    
}

extension RegisterPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        tryToContinue()
        return true
    }
}

