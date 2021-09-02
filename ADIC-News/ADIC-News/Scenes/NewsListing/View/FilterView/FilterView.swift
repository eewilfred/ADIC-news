//
//  FilterView.swift
//  ADIC-News
//
//  Created by Edwin Wilson on 02/09/2021.
//

import UIKit


enum FilterSection: String, CaseIterable {

    case sourceLocation = "source location"
    case publishedDate = "published date"
    case type = "type"
}

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

class FilterView: UIView {

    @IBOutlet weak private var collectionView: UICollectionView!

    var presentation: FilterViewPresentation?

    var dataSource: UICollectionViewDiffableDataSource<FilterSection, FilterViewCellPresentation>?

    func configureFilterView() {

        presentation = FilterViewPresentation()
        configureCollectionView()

    }

    private func configureCollectionView() {

        var layoutConfig = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        layoutConfig.headerMode = .supplementary
        let listLayout = UICollectionViewCompositionalLayout.list(using: layoutConfig)

        collectionView.collectionViewLayout = listLayout

        collectionView.register(
            FilterViewCollectionViewCell.nib,
            forCellWithReuseIdentifier: FilterViewCollectionViewCell.identifier
        )

        dataSource = UICollectionViewDiffableDataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, cellPresentation) in
                guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: FilterViewCollectionViewCell.identifier,
                        for: indexPath
                ) as? FilterViewCollectionViewCell else { return UICollectionViewCell() }

                cell.presentation = cellPresentation
                return cell
            }
        )

        configureHeader()
        configureData()
    }

    private func configureHeader() {

        let headerRegistration = UICollectionView.SupplementaryRegistration
        <UICollectionViewListCell>(elementKind: UICollectionView.elementKindSectionHeader) {
            [unowned self] (headerView, elementKind, indexPath) in
            let headerItem = self.dataSource?.snapshot().sectionIdentifiers[indexPath.section]
            var configuration = headerView.defaultContentConfiguration()
            configuration.text = headerItem?.rawValue

//            // Customize header appearance to make it more eye-catching
//            configuration.textProperties.font = .boldSystemFont(ofSize: 16)
//            configuration.textProperties.color = .systemBlue
            configuration.directionalLayoutMargins = .init(top: 20.0, leading: 0.0, bottom: 10.0, trailing: 0.0)

            // Apply the configuration to header view
            headerView.contentConfiguration = configuration
        }

        dataSource?.supplementaryViewProvider = { [unowned self]
            (collectionView, elementKind, indexPath) -> UICollectionReusableView? in

            if elementKind == UICollectionView.elementKindSectionHeader {

                // Dequeue header view
                return self.collectionView.dequeueConfiguredReusableSupplementary(
                    using: headerRegistration, for: indexPath)

            }
            return nil
        }
    }

    private func configureData() {

        var snaphot = NSDiffableDataSourceSnapshot<FilterSection, FilterViewCellPresentation>()
        snaphot.appendSections(FilterSection.allCases)
        for type in FilterSection.allCases {
            if let cellPresentation = presentation?.filters[type] {
                snaphot.appendItems(cellPresentation, toSection: type)
            }
        }
        dataSource?.apply(snaphot)
    }

    func UpdatePresetnation(news: [News]) {

        guard var presentation = presentation,
              var snapshot = dataSource?.snapshot()else { return }

        let values = presentation.filters.values.flatMap({$0})
        snapshot.deleteItems(values)
        presentation.update(news: news)
        snapshot.appendItems(presentation.filters[.sourceLocation] ?? [], toSection: .sourceLocation)
        snapshot.appendItems(presentation.filters[.publishedDate] ?? [], toSection: .publishedDate)
        snapshot.appendItems(presentation.filters[.type] ?? [], toSection: .type)
        dataSource?.apply(snapshot)
    }
}
