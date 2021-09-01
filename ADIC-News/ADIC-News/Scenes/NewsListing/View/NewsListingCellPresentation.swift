//
//  NewsListingCellPresentation.swift
//  ADIC-News
//
//  Created by Edwin Wilson on 01/09/2021.
//

import Foundation

struct NewsListingCellPresentation: Hashable {

    var title: String?
    var reporter: String?
    var publishedOn: String?
    var imageURLString: String?

    init(news: News) {

        title = news.title
        reporter = news.byline
        publishedOn = news.publishedDate

        imageURLString = news.media?.first?.mediaMetadata?.first(
            where: {$0.format == .thumbnail}
        )?.url
    }
}
