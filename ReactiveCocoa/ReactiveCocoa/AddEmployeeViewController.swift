//
//  AddEmployeeViewController.swift
//  ReactiveCocoa
//
//  Created by  on 3/3/17.
//  Copyright © 2017 801kz. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AddEmployeeViewController: UIViewController {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var slider: UISlider!
    @IBOutlet private weak var button: UIButton!
    
    private let disposeBag = DisposeBag()
    private let images = [UIImage(named: "superman"), UIImage(named: "supergirl")]
    
    var employees: Variable<[Employee]>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGenderBinding()
        setupSalaryBinding()
        setupButtonObserver()
    }
    
    private var nameObservable: Observable<String> {
        return self.textField
            .rx // 1
            .text // 2
            .map { text in
                return text ?? "" // 3
        }
    }
    
    private var salaryObservable: Observable<String> {
        return self.slider
            .rx // 1
            .value // 2
            .map{ value -> String in
                "\(Int(value * 2000)) $" // 3
            }
            .shareReplay(1)
    }
    
    private var genderObservable: Observable<Int> {
        return self.segmentedControl
            .rx // 1
            .selectedSegmentIndex // 2
            .asObservable()
    }
    
    private func setupSalaryBinding() {
        self.salaryObservable
            .bindTo( self.label.rx.text) // 1
            .addDisposableTo(self.disposeBag) // 2
    }

    private func setupGenderBinding() {
        self.genderObservable
            .map{ index -> UIImage in
                self.images[index]! // 1
            }
            .bindTo( self.imageView.rx.image) // 2
            .addDisposableTo(self.disposeBag) // 3
    }
    
    private func setupButtonObserver() {
        let params = Observable.combineLatest(self.nameObservable, self.genderObservable, self.salaryObservable) {($0, $1, $2)} // 1
        self.button
            .rx // 2
            .tap // 3
            .asObservable() // 4
            .withLatestFrom(params) // 5
            .subscribe(onNext: { name, gender, salary in
                let employee = Employee(name, gender, salary)
                self.employees?.value.append(employee) // 6
                _ = self.navigationController?.popViewController(animated: true)
            })
            .addDisposableTo(self.disposeBag) // 7
    }
}
