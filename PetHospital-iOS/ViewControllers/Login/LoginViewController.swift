//
//  LoginViewController.swift
//  PetHospital-iOS
//
//  Created by jjaychen on 2021/3/22.
//

import UIKit
import SwiftUI
import GoogleSignIn

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var continueWithGoogle: UIView!
    private var continueBarButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Asset.dynamicLightGrayBackground.color
        setTransparentNavigationBarWith(backgroundColor: Asset.dynamicLightGrayBackground.color)
        continueBarButtonItem = UIBarButtonItem(title: "继续", style: .done, target: self, action: #selector(tryToContinue))
        navigationItem.rightBarButtonItem = continueBarButtonItem
        
        let doneButtonAppearance = UIBarButtonItemAppearance()
        doneButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.systemBlue,
                                                           .font: UIFont.systemFont(ofSize: 16, weight: .semibold)]
        navigationItem.standardAppearance?.doneButtonAppearance = doneButtonAppearance
        navigationItem.compactAppearance?.doneButtonAppearance = doneButtonAppearance
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        let continueWithGoogleTapGesture = UITapGestureRecognizer(target: self, action: #selector(continueWithGoogle(_:)))
        self.continueWithGoogle.addGestureRecognizer(continueWithGoogleTapGesture)
        
        self.usernameTextField.delegate = self
        //        self.usernameTextField.becomeFirstResponder()
    }
    
    @objc
    private func continueWithGoogle (_ sender: UITapGestureRecognizer) {
        print("continue with google")
        GIDSignIn.sharedInstance().presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    @objc
    private func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        usernameTextField.resignFirstResponder()
    }
    
    private func checkUsernameInLocal(username: String?) -> Bool {
        guard let username = username else { return false }
        
        return username.count == 11 && username.allSatisfy({ (character) -> Bool in
            character.isNumber
        })
    }
    
    /// Check whether `username` is used or not. If the `username` doesn't conform to the stipulation,
    /// `completionHandler` is not called.
    private func check(username: String?, completionHandler: @escaping (Bool) -> ()) {
        guard checkUsernameInLocal(username: username) else {
            ToastHelper.show(emoji: "🙅", title: "用户名格式不正确", subtitle: "请保证用户名为十一位数字。")
            return
        }
        
        // ... Ask the server
        NetworkManager.shared.fetch(endPoint: .loginCheck, parameters: ["stuId": username]) { (result: ResultEntity<Bool>?) in
            self.navigationItem.rightBarButtonItem = self.continueBarButtonItem
            if let result = result {
                if result.code == .success, let data = result.data {
                    completionHandler(data)
                    return
                }
                print(result)
                
                // 请求出错时不应该跳转
            }
            
            // 请求出错时不应该跳转
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: UIHostingController(rootView: CircularLoadingView().background(Color(Asset.dynamicLightGrayBackground.color))).view!)
    }
    
    @objc
    private func tryToContinue() {
        check(username: usernameTextField.text) { (unused) in
            unused ? self.goRegiter() : self.goLogin()
        }
    }
    
    private func goRegiter() {
        let vc = StoryboardScene.Login.registerPasswordViewController.instantiate()
        vc.username = usernameTextField.text!
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func goLogin() {
        let vc = StoryboardScene.Login.loginPasswordViewController.instantiate()
        vc.username = usernameTextField.text!
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        tryToContinue()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 11
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
}

// MARK: - Google SignIn Delegate

extension LoginViewController: GIDSignInDelegate {
    
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
                       withError error: Error!) {
        if (error == nil) {
            let googleUser = GoogleUser(userID: user.userID,
                                        nickname: user.profile.givenName + " " + user.profile.familyName,
                                        email: user.profile.email,
                                        accessToken: user.authentication.accessToken,
                                        avatar: user.profile.hasImage ? user.profile.imageURL(withDimension: 256)?.absoluteString : nil)
            
            LoginHelper.googleLogin(with: googleUser) { (success) in
                if success {
                    ToastHelper.show(emoji: "🎉", title: "登录成功", subtitle: "使用 Google 账号登录成功。欢迎来到宠物医院。")
                    self.navigationController?.setViewControllers([StoryboardScene.Main.mainTabBarController.instantiate()], animated: true)
                    self.navigationController?.setNavigationBarHidden(true, animated: true)
                } else {
                    ToastHelper.show(emoji: "⚠️", title: "验证失败", subtitle: "服务器验证失败。")
                }
            }
        } else {
            print(error)
        }
    }
}
