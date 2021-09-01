//
//  ViewController.swift
//  ADIC-News
//
//  Created by Edwin Wilson on 01/09/2021.
//

import UIKit

class NewsListingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if let url = NetworkManager.shared.URLForApi(path: "/viewed/1.json") {
            NetworkManager.shared.start(request: url) { [weak self] (response: Response<NYNews>) in

                print(response)
            }
        }
    }


}

