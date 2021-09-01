//
//  NewsListingPresentation.swift
//  ADIC-News
//
//  Created by Edwin Wilson on 01/09/2021.
//

import Foundation

enum NewsListingSection: CaseIterable {

    case main
}

struct NewsListingPresentation {


    var cellPresentation: [NewsListingCellPresentation]?

    mutating func update(news: [News]?) {

        guard let news = news else {
            return
        }
        cellPresentation = news.map({NewsListingCellPresentation(news: $0) })
    }
}
