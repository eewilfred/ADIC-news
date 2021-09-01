//
//  NewsListingTableViewCell.swift
//  ADIC-News
//
//  Created by Edwin Wilson on 01/09/2021.
//

import UIKit

class NewsListingTableViewCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var reporterLabel: UILabel!
    @IBOutlet private weak var publishedOnLabel: UILabel!
    @IBOutlet private weak var thumbnailImageView: UIImageView!

    var presentation: NewsListingCellPresentation? {

        didSet {
            updateUI()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        thumbnailImageView.layer.cornerRadius = thumbnailImageView.frame.height / 2
        backgroundColor = UIColor(named: "BGColor")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {}

    private func updateUI() {

        guard  let presentation = presentation else {
            return
        }

        titleLabel.text = presentation.title
        reporterLabel.text = presentation.reporter
        publishedOnLabel.text = presentation.publishedOn

        reporterLabel.textColor = UIColor(named: "SubtitleTextColor")
        publishedOnLabel.textColor = UIColor(named: "SubtitleTextColor")
    }
    
}
