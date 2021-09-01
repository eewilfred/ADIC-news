//
//  ImageView+Extension.swift
//  ADIC-News
//
//  Created by Edwin Wilson on 01/09/2021.
//

import UIKit

extension UIImageView {

    func setImage(from url: URL) -> URLSessionDataTask? {

        if let cached = NetworkManager.shared.imageCache.object(
            forKey: url as NSURL
        ) as? UIImage {
            self.image = cached
            return nil
        }
        let task = NetworkManager.shared.downloadImage(with: url, imageView: self)
        return task
    }
}
