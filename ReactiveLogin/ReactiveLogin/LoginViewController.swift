//
//  LoginViewController.swift
//  NativeSpeaker
//
//  Created by  on 12/19/16.
//  Copyright © 2016 801kz. All rights reserved.
//

import UIKit
import Firebase
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {

    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var forgotPasswordButton: UIButton!
    @IBOutlet private weak var registrationButton: UIButton!
    private var viewModel: LoginViewModel!
    private let disposeBag = DisposeBag()
    
    private let kLoginStoryboardName = "Login"
    
    private var usernameObservable: Observable<String> {
        return usernameTextField.rx.text.throttle(0.5, scheduler : MainScheduler.instance).map(){ text in
            return text ?? ""
        }
    }
    private var passwordObservable: Observable<String> {
        return passwordTextField.rx.text.throttle(0.5, scheduler : MainScheduler.instance).map(){ text in
            return text ?? ""
        }
    }
    private var loginButtonObservable: Observable<Void> {
        return self.loginButton.rx.tap.asObservable()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupModelView()
        
        self.viewModel.loginObservable.bindNext{ user, error in
            // TODO: - add logic for login
        }.addDisposableTo(disposeBag)
        
        self.viewModel.loginEnabled.bindNext{ valid  in
            self.loginButton.isEnabled = valid
            self.loginButton.alpha = valid ? 1 : 0.5
        }.addDisposableTo(disposeBag)
    }
    
    // MARK: - setup
    private func setupModelView() {
        self.viewModel = LoginViewModel(input: (username: self.usernameObservable,
            password: self.passwordObservable,
            loginTap: self.loginButtonObservable))
    }
}
