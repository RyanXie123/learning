//
//  UITableView+Extension.swift
//  仿AppStore
//
//  Created by 谢汝 on 2018/9/14.
//  Copyright © 2018年 谢汝. All rights reserved.
//

import Foundation
import UIKit




extension UITableView {
    func registerCell<Cell: UITableViewCell>(_ cellClass:Cell.Type) {
        register(cellClass, forCellReuseIdentifier: String(describing: cellClass))
    }
    
    
    func dequeueResuableCell<Cell:UITableViewCell>(forIndexPath indexPath:IndexPath) -> Cell {
        let identify = String(describing: Cell.self)
        
        guard let cell = self.dequeueReusableCell(withIdentifier: identify, for: indexPath) as? Cell else { fatalError("Error for cell id: \(identify) at \(indexPath)") }
        
        return cell;
        
    }
    
    
}
