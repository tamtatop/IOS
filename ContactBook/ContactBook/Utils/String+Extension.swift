//
//  String+Extension.swift
//  ContactBook
//
//  Created by Tamta Topuria on 1/7/21.
//

import UIKit

extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}
