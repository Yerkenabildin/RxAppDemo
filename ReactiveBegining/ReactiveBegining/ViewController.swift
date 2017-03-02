//
//  ViewController.swift
//  ReactiveBegining
//
//  Created by  on 3/1/17.
//  Copyright © 2017 801kz. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        exampleOfObservable()
        exampleOfVariable()
        guaranteesObservable()
        exampleOfDispose()
        exampleOfDisposeCreate()
        exampleShareReplay()
    }
    
    private func exampleOfObservable() {
        print("===== Example Of Observable =====")
        let justObservable = Observable<String> // 1
            .create { observer in // 2
            let random = Int(arc4random_uniform(2)) // 3
            if random == 0 {
                observer.onNext("next element") // 4
                observer.onCompleted() // 5
            } else {
                let error = AError.General("error")
                observer.onError(error) // 6
            }
            return Disposables.create() // 7
        }
        
        justObservable.subscribe { event in // 1
            switch (event) { // 2
            case .next(let element):
                print(element)
            case .error(let error):
                print(error.localizedDescription)
            case .completed():
                break
            }
        }.addDisposableTo(self.disposeBag) // 3
    }
    
    private func exampleOfVariable() {
        print("====== Example Of Variable ======")
        let demoVariable = Variable<Int>(0) // 1
        
        demoVariable.asObservable().subscribe(onNext: { value in
            print(value) // 2
        }).addDisposableTo(self.disposeBag)
        
        for i in 0...4 {
            demoVariable.value = i // 3
        }
    }
    
    private func guaranteesObservable() {
        print("===== Guarantees Observable =====")
        let observable = Observable<String>.create { observer in
            for i in 0...4 {
                observer.onNext("element \(i)")
            }
            
            observer.onCompleted()
            return Disposables.create()
        }
        
        observable.subscribe { event in
            print("Started")
            // any processing
            print("Ended")
        }.addDisposableTo(self.disposeBag)
    }
    
    
    private func exampleOfDispose() {
        print("======= Example Of Dispose ======")
        let scheduler = SerialDispatchQueueScheduler.init(internalSerialQueueName: "scheduler")
        let subscription = Observable<Int>.interval(0.3, scheduler: scheduler)
            .subscribe { event in
                print(event)
        }
        
        Thread.sleep(forTimeInterval: 2.0)
        
        subscription.dispose()
    }
    
    private func exampleOfDisposeCreate() {
        print("=== Example Of Dispose Create ===")
        let observable = Observable<String>.create { observer in
            print("Started")
            for i in 0...4 {
                observer.onNext("element \(i)")
            }
            
            observer.onCompleted()
            print("Ended")
            return Disposables.create {
                print("Dispose")
            }
        }

        observable.subscribe { event in
            print(event)
            }.addDisposableTo(self.disposeBag)
    }
    
    private func exampleShareReplay() {
        print("==== Example Of Share Replay ====")
        let scheduler = SerialDispatchQueueScheduler.init(internalSerialQueueName: "scheduler")
        let observable = Observable<Int>.interval(0.3, scheduler: scheduler)//.shareReplay(1)
        
        let subscription1 = observable
            .subscribe(onNext: { n in
                print("[First]  -> \(n)")
            })
        
        Thread.sleep(forTimeInterval: 2.0)
        
        let subscription2 = observable
            .subscribe(onNext: { n in
                print("[Second] -> \(n)")
            })
        
        Thread.sleep(forTimeInterval: 1.0)
        
        subscription1.dispose()
        
        Thread.sleep(forTimeInterval: 1.0)
        
        subscription2.dispose()
    }
}
