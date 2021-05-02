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
    
    var username: String!
    var socialUserID: Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Asset.dynamicBackground.color
        setTransparentNavigationBarWith(backgroundColor: Asset.dynamicBackground.color)
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
    
    private func checkPasswordInLocal(password: String?) -> Bool {
        guard let password = password else { return false }
        
        return password.count >= 8 && password.count <= 50 && password.allSatisfy({ (character) -> Bool in
            character.isASCII
        })
    }
    
    private func checkRegisterWith(username: String, password: String, completionHandler: @escaping (Bool) -> ()) {
        guard checkPasswordInLocal(password: password) else {
            ToastHelper.show(emoji: "🙅", title: "密码格式不正确", subtitle: "请保证密码至少包含8个字符，且不超过50个字符。")
            return
        }
        // ... Ask the server
        NetworkManager.shared.fetch(endPoint: .register, method: .POST,
                                    parameters: LoginParameter(username: username, password: password, socialUserID: socialUserID)) { (result: Result<ResultEntity<Bool>, Error>) in
            result.resolve { result in
                self.navigationItem.rightBarButtonItem = self.continueBarButtonItem
                if result.code == .success, let data = result.data, data == true {
                    LoginHelper.login(with: LoginParameter(username: username, password: password)) { (result) in
                        completionHandler(result)
                    }
                } else {
                    // 注册失败.. 可能是刚好被人注册了
                    print(result)
                    completionHandler(false)
                }
            } failureHandler: { error in
                print(error)
                completionHandler(false)
                return
            }
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: UIHostingController(rootView: CircularLoadingView().background(Color(Asset.dynamicBackground.color))).view!)
    }
    
    @objc
    private func tryToContinue() {
        checkRegisterWith(username: username, password: passwordTextField.text ?? "") { (success) in
            if success {
                ToastHelper.show(emoji: "🎉", title: "登录成功", subtitle: "使用账号密码登录成功。欢迎来到宠物医院。")
                self.navigationController?.setViewControllers([StoryboardScene.Main.mainTabBarController.instantiate()], animated: true)
                self.navigationController?.setNavigationBarHidden(true, animated: true)
            } else {
                ToastHelper.show(emoji: "🙅", title: "注册失败", subtitle: "可能是不小心被人注册了。")
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

