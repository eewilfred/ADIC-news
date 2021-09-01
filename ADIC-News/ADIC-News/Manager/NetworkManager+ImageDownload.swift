//
//  NetworkManager+ImageDownload.swift
//  ADIC-News
//
//  Created by Edwin Wilson on 01/09/2021.
//

import UIKit

extension NetworkManager {

    func downloadImage(with url: URL, imageView: UIImageView) -> URLSessionDataTask {

        let task = URLSession.shared.dataTask(with: url)  { (data, _, _) in
            if let data = data, let image = UIImage(data: data) {
                self.imageCache.setObject(image, forKey: url as NSURL)
                DispatchQueue.main.async {
                    imageView.image = image
                }
            }
        }
        task.resume()
        return task
    }
}
