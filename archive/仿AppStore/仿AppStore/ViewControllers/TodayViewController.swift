//
//  TodayViewController.swift
//  仿AppStore
//
//  Created by 谢汝 on 2018/9/14.
//  Copyright © 2018年 谢汝. All rights reserved.
//

import UIKit

class TodayViewController: UIViewController {

    let tableView = UITableView()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
    }
    
    
    private func setupViews() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    

    

}


// MARK: UITableViewDelegate, UITableViewDataSource


extension TodayViewController: UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 450
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cardCell
    }
    
    
    
}
