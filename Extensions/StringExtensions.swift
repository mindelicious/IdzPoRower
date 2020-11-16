//
//  StringExtensions.swift
//  IdzPoRower
//
//  Created by Mateusz Danieluk on 13/11/2020.
//

import UIKit

extension String {
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
