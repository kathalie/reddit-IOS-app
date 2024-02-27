//
//  ui-utils.swift
//  IOS_App
//
//  Created by Kathryn Verkhogliad on 27.02.2024.
//

import Foundation
import UIKit

func setSaveButtonImage(for button: UIButton, isSaved: Bool) {
    button.setImage(
        isSaved ? UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark"),
        for: .normal
    )
}
