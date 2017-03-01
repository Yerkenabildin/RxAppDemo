//
//  LoginModelView.swift
//  NativeSpeaker
//
//  Created by  on 12/20/16.
//  Copyright © 2016 801kz. All rights reserved.
//

import Foundation
import FirebaseAuth
import RxSwift

class LoginViewModel {
    
    let validatedEmail: Observable<Bool>
    let validatedPassword: Observable<Bool>
    let loginEnabled: Observable<Bool>
    let loginObservable: Observable<(FIRUser?, Error?)>

    init(input: (username: Observable<String>,
        password: Observable<String>,
        loginTap: Observable<Void>)) {
        
        self.validatedEmail = input.username
            .map { $0.characters.count >= 5 }
            .shareReplay(1)
        
        self.validatedPassword = input.password
            .map { $0.characters.count >= 4 }
            .shareReplay(1)
        
        self.loginEnabled = Observable.combineLatest(validatedEmail, validatedPassword ) { $0 && $1 }
        let userAndPassword = Observable.combineLatest(input.username, input.password) {($0,$1)}
        
        self.loginObservable = input.loginTap.withLatestFrom(userAndPassword).flatMapLatest{ (username, password) in
            return LoginViewModel.login(username: username, password: password).observeOn(MainScheduler.instance)
        }
    }

    private class func login(username: String?, password: String?) -> Observable<(FIRUser?, Error?)> {
        return  Observable.create { observer in
            if let username = username, let password = password {
                FIRAuth.auth()?.signIn(withEmail: username, password: password) { user, error in
                    observer.onNext((user, error))
                }
            } else {
                // TODO: - add error
                observer.onNext((nil, AError.General("ok")))
            }
            return Disposables.create()
        }
    }
}
