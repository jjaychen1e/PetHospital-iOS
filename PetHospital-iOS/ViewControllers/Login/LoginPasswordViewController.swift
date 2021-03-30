//
//  LoginPasswordViewController.swift
//  PetHospital-iOS
//
//  Created by jjaychen on 2021/3/22.
//

import UIKit
import SwiftUI

class LoginPasswordViewController: UIViewController {
    
    @IBOutlet weak var passwordTextField: UITextField!
    private var continueBarButtonItem: UIBarButtonItem!
    
    var username: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Asset.dynamicLightGrayBackground.color
        setTransparentNavigationBarWith(backgroundColor: Asset.dynamicLightGrayBackground.color)
        self.continueBarButtonItem = UIBarButtonItem(title: "继续", style: .done, target: self, action: #selector(tryToContinue))
        navigationItem.rightBarButtonItem = continueBarButtonItem
        
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
    
    private func checkLoginWith(username: String, password: String, completionHandler: @escaping (Bool) -> ()) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: UIHostingController(rootView: CircularLoadingView().background(Color(Asset.dynamicLightGrayBackground.color))).view!)
        
        LoginHelper.login(with: LoginParameter(username: username, password: password)) { (result) in
            self.navigationItem.rightBarButtonItem = self.continueBarButtonItem
            completionHandler(result)
            return
        }
    }
    
    @objc
    private func tryToContinue() {
        checkLoginWith(username: username, password: passwordTextField.text ?? "") { (success) in
            if success {
                ToastHelper.show(emoji: "🎉", title: "登录成功", subtitle: "使用账号密码登录成功。欢迎来到宠物医院。")
                self.navigationController?.setViewControllers([StoryboardScene.Main.mainTabBarController.instantiate()], animated: true)
                self.navigationController?.setNavigationBarHidden(true, animated: true)
            } else {
                ToastHelper.show(emoji: "🙅", title: "密码错误", subtitle: "请检查你的密码。")
            }
        }
    }

}

extension LoginPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        tryToContinue()
        return true
    }
}

