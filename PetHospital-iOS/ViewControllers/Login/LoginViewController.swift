//
//  LoginViewController.swift
//  PetHospital-iOS
//
//  Created by jjaychen on 2021/3/22.
//

import UIKit
import SwiftUI

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    private var continueBarButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTransparentNavigationBar()
        continueBarButtonItem = UIBarButtonItem(title: "继续", style: .done, target: self, action: #selector(tryToContinue))
        navigationItem.rightBarButtonItem = continueBarButtonItem
        
        let doneButtonAppearance = UIBarButtonItemAppearance()
        doneButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.systemBlue,
                                                           .font: UIFont.systemFont(ofSize: 16, weight: .semibold)]
        navigationItem.standardAppearance?.doneButtonAppearance = doneButtonAppearance
        navigationItem.compactAppearance?.doneButtonAppearance = doneButtonAppearance
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        self.usernameTextField.delegate = self
        self.usernameTextField.becomeFirstResponder()
    }

    @objc
    func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        usernameTextField.resignFirstResponder()
    }
    
    private func checkUsernameInLocal(username: String?) -> Bool {
        guard let username = username else { return false }
        
        return username.count >= 6 && username.count <= 10 && username.allSatisfy({ (character) -> Bool in
            character.isLetter || character.isNumber
        })
    }
    
    /// Check whether `username` is used or not. If the `username` doesn't conform to the stipulation,
    /// `completionHandler` is not called.
    private func check(username: String?, completionHandler: @escaping (Bool) -> ()) {
        guard checkUsernameInLocal(username: username) else {
            ToastHelper.show(emoji: "🙅", title: "用户名格式不正确", subtitle: "请保证用户名只包含数字和字母字符，且长度为6至10个字符。")
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
        check(username: usernameTextField.text) { (used) in
            used ? self.goLogin() : self.goRegiter()
        }
    }
    
    func goRegiter() {
        self.navigationController?.pushViewController(StoryboardScene.Login.registerPasswordViewController.instantiate(), animated: true)
    }
    
    func goLogin() {
        self.navigationController?.pushViewController(StoryboardScene.Login.loginPasswordViewController.instantiate(), animated: true)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        tryToContinue()
        return true
    }
}
