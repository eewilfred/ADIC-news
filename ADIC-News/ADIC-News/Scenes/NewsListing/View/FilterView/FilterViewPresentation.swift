//
//  FilterViewPresentation.swift
//  ADIC-News
//
//  Created by Edwin Wilson on 02/09/2021.
//

import Foundation

struct FilterViewPresentation {

    var filters = [ FilterSection: [FilterViewCellPresentation]]()

    mutating func update(news: [News]) {

        var types = Set<String>()
        var publishedDates = Set<String>()
        var sourceLocations = Set<String> ()

        news.forEach({
            if let type = $0.type {
                types.insert(type)
            }
            if let publishedDate = $0.publishedDate {
                publishedDates.insert(publishedDate)
            }
            if let sourceLocation = $0.geoFacet {
                sourceLocation.forEach { location in
                    sourceLocations.insert(location)
                }
            }
        })

        FilterSection.allCases.forEach { section in
            switch section {
            case .sourceLocation:
                filters[section] = sourceLocations.map(
                    { FilterViewCellPresentation(filterType: section, name: $0)}
                )
            case .publishedDate:
                filters[section] = publishedDates.map(
                    { FilterViewCellPresentation(filterType: section, name: $0)}
                )
            case .type:
                filters[section] = types.map(
                    { FilterViewCellPresentation(filterType: section, name: $0)}
                )
            }
        }
    }
}
