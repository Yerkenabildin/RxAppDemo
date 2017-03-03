//
//  ViewController.swift
//  ReactiveCocoa
//
//  Created by  on 3/3/17.
//  Copyright © 2017 801kz. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class EmployeesViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var button: UIBarButtonItem!
    
    private static let kUserDefKey = "employee_key"
    var employees: Variable<[Employee]>?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableViewBinding()
        setupButtonBinding()
    }

    private func setupTableViewBinding() {
        self.employees?
            .asObservable() // 1
            .bindTo(self.tableView.rx.items(cellIdentifier: "cell")) // 2
            { row, element, cell in // 3
                cell.textLabel?.text = element.name
                cell.detailTextLabel?.text = element.salary
                let menColor = UIColor.blue.withAlphaComponent(0.1)
                let womenColor = UIColor.blue.withAlphaComponent(0.1)
                cell.backgroundColor = element.gender == 0 ? menColor : womenColor
            }.addDisposableTo(self.disposeBag) // 4
    }
    
    private func setupButtonBinding() {
        self.button
            .rx // 1
            .tap // 2
            .asObservable() // 3
            .subscribe(onNext: { // 4
                let controllerName = String(describing: AddEmployeeViewController.self)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = storyboard.instantiateViewController(withIdentifier: controllerName) as! AddEmployeeViewController
                viewController.employees = self.employees // 5
                self.navigationController?.pushViewController(viewController, animated: true)
            }).addDisposableTo(self.disposeBag) // 6
    }
}
