//
//  EmptyViewViewController.swift
//  EmptyViewDemo
//
//  Created by 刘岭 on 17/5/11.
//  Copyright © 2017年 刘岭. All rights reserved.
//

import UIKit

class EmptyViewViewController: UITableViewController, EmptyViewProtocol {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureTableView() {
        self.tableView.needEmptyView = true
//        self.tableView.needEmptyView = false
        self.tableView.tableFooterView = UIView()
        self.tableView.setEmptyViewType(with: 4)
        
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    var testDataCount = 0
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testDataCount
    }
    
    deinit {
        print("detail deinit")
    }
    
    func emptyViewNoNetRetry() {
        print("empty button tap")
        testDataCount += 1
        tableView.reloadData()
    }
    
    func emptyViewToastWhenDataSourceNotEmpty(_ emptyViewType: EmptyViewType, text: String) {
        print("empty view don't display, need toast")
    }
    
}

