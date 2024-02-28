//
//  array-extension.swift
//  IOS_App
//
//  Created by Kathryn Verkhogliad on 28.02.2024.
//

import Foundation
extension Array {
    mutating func insert(_ elem: Element, by insertionPredicate: (Element, Element) -> Bool) {
        if let index = self.firstIndex(where: {e in insertionPredicate(e, elem)}) {
            self.insert(elem, at: index)
        } else {
            self.append(elem)
        }
    }
}
