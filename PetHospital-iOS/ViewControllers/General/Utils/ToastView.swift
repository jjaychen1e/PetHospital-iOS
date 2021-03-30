//
//  ToastView.swift
//  PetHospital-iOS
//
//  Created by jjaychen on 2021/3/23.
//

import SwiftUI
import UIKit

fileprivate struct ToastView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var toastViewModel: ToastViewModel
    
    var body: some View {
        HStack(spacing: 16) {
            if toastViewModel.image != nil {
                Text(toastViewModel.image!)
                    .font(.system(size: 40))
            }
            
            VStack(alignment: .center) {
                Text(toastViewModel.title)
                    .lineLimit(1)
                    .font(.headline)
                
                if toastViewModel.subtitle != nil {
                    Text(toastViewModel.subtitle!)
                        .lineLimit(nil)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .padding(toastViewModel.image == nil ? .horizontal : .trailing)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(colorScheme == .dark ? UIColor.secondarySystemBackground : UIColor.systemBackground))
        .cornerRadius(28)
        .shadow(color: Color(UIColor.black.withAlphaComponent(0.08)), radius: 8, x: 0, y: 4)
    }
}

fileprivate class ToastViewModel: ObservableObject {
    @Published var image: String?
    @Published var title: String
    @Published var subtitle: String?
    
    init(image: String? = nil, title: String, subtitle: String? = nil) {
        self.image = image
        self.title = title
        self.subtitle = subtitle
    }
}

fileprivate class ToastViewController: UIViewController {
    private var toastViewModel: ToastViewModel!
    
    private var toastView: UIView!
    
    var dismissing = false
    
    init(emoji: String? = nil, title: String, subtitle: String? = nil) {
        self.toastViewModel = ToastViewModel(image: emoji, title: title, subtitle: subtitle)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        toastView.transform = CGAffineTransform(translationX: 0, y: -toastView.frame.height - UIApplication.shared.windows.first(where: { $0.isKeyWindow })!.safeAreaInsets.top)
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut) {
            self.toastView.transform = .identity
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.hide(animated: true, completionHandler: nil)
        }
    }
    
    override func viewDidLoad() {
        view.isUserInteractionEnabled = false
        toastView = UIHostingController(rootView: ToastView(toastViewModel: toastViewModel)).view!
        self.view.addSubview(toastView)
        toastView.backgroundColor = .clear
        toastView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(UIApplication.shared.windows.first(where: { $0.isKeyWindow })!.safeAreaInsets.top)
            make.width.lessThanOrEqualToSuperview().multipliedBy(0.8)
            make.width.lessThanOrEqualTo(300)
        }
    }
    
    func hide(animated: Bool, completionHandler: ((Bool) -> ())? = nil) {
        if animated {
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut) {
                self.toastView.transform = CGAffineTransform(translationX: 0, y: -self.toastView.frame.height - UIApplication.shared.windows.first(where: { $0.isKeyWindow })!.safeAreaInsets.top)
            } completion: { (result) in
                if result {
                    self.removeFromParent()
                    self.view.removeFromSuperview()
                    completionHandler?(result)
                }
            }
        } else {
            self.removeFromParent()
            self.view.removeFromSuperview()
        }
    }
}

class ToastHelper {
    private static var toastViewController: ToastViewController?
    
    private init () {
        
    }
    
    static func show(emoji: String? = nil, title: String, subtitle: String? = nil) {
        if let rootViewController = (UIApplication.shared.delegate as! AppDelegate).rootViewController {
            ToastHelper.toastViewController?.hide(animated: false)
            ToastHelper.toastViewController = ToastViewController(emoji: emoji, title: title, subtitle: subtitle)
            rootViewController.addChild(ToastHelper.toastViewController!)
            rootViewController.view.addSubview(ToastHelper.toastViewController!.view!)
            ToastHelper.toastViewController!.didMove(toParent: rootViewController)
        }
    }
}
