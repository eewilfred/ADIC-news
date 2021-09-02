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
    var identifier: String

    init(news: News) {

        title = news.title
        reporter = news.byline
        publishedOn = news.publishedDate
        identifier = "\(news.id ?? 0)"

        imageURLString = news.media?.first?.mediaMetadata?.first(
            where: {$0.format == .thumbnail}
        )?.url
    }

    func hash(into hasher: inout Hasher) {
            hasher.combine(identifier + (title ?? ""))
        }

    static func == (lhs: NewsListingCellPresentation,
                    rhs: NewsListingCellPresentation) -> Bool {
        lhs.title == rhs.title &&
            lhs.identifier == rhs.identifier
    }
}
