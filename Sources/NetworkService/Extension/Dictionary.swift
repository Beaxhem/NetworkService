//
//  File.swift
//  
//
//  Created by Ilya Senchukov on 09.03.2021.
//

import Foundation

extension Dictionary {
    mutating func merge(with dict: [Key: Value]) {
        for (k, v) in dict {
            self[k] = v
        }
    }
}
