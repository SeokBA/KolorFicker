//
//  String+Regex.swift
//  KolorFicker
//
//  Created by tuna.can on 2022/06/12.
//

import Foundation

extension String {
    func regexMatch(regex: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: self, range: NSRange(self.startIndex..., in: self))
            return results.map { String(self[Range($0.range, in: self)!]) }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
}
