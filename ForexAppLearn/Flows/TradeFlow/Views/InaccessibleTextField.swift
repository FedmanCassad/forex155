//
//  InaccessibleTextField.swift
//  Quotex
//

import UIKit

final class InaccessibleTextField: UITextField {
    override var canBecomeFirstResponder: Bool {
        false
    }
}
