//
//  FilterViewCollectionViewCell.swift
//  ADIC-News
//
//  Created by Edwin Wilson on 02/09/2021.
//

import UIKit

class FilterViewCellPresentation: Hashable {

    var filterType: FilterSection
    var name: String
    var isSelected = false
    var uuid = UUID()

    init(filterType: FilterSection,  name: String) {

        self.filterType = filterType
        self.name = name
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
        }

    static func == (lhs: FilterViewCellPresentation,
                    rhs: FilterViewCellPresentation) -> Bool {
        lhs.uuid == rhs.uuid
    }
}

class FilterViewCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var filterNameLabel: UILabel!

    var presentation: FilterViewCellPresentation? {

        didSet {
            updateUI()
        }
    }

    private func updateUI() {

        guard let presentation = presentation else { return }

        isSelected = presentation.isSelected
        filterNameLabel.text = presentation.name
        backgroundColor = presentation.isSelected ? .black : .white
        filterNameLabel.textColor = presentation.isSelected ? .white : .black
    }
}
