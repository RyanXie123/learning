//
//  String+Extensions.swift
//  仿AppStore
//
//  Created by 谢汝 on 2018/9/15.
//  Copyright © 2018年 谢汝. All rights reserved.
//

import Foundation


extension String {
    var uppercasedFirstLetter: String {
        guard !self.isEmpty  else { return self }
        return self.prefix(1).uppercased() + dropFirst()
    }
}
