//
//  UITableViewCell+Extension.swift
//  ADIC-News
//
//  Created by Edwin Wilson on 01/09/2021.
//

import UIKit

extension UITableViewCell {

    /// Class name as cell identifier string
    class var identifier: String { return String(describing: self) }

    /// Initialize xib using Class name
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
}

extension UICollectionReusableView {

    /// Class name as cell identifier string
    class var identifier: String { return String(describing: self) }

    /// Initialize xib using Class name
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
}
