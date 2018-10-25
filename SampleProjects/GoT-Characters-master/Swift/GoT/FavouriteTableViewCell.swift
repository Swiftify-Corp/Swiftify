//
//  FavouriteTableViewCell.swift
//  GoT
//
//  Created by piotrom1 on 26/10/15.
//  Copyright © 2015 Maciej Piotrowski. All rights reserved.
//

import UIKit

class FavouriteTableViewCell: UITableViewCell {
    var titleLabel: UILabel {
        return privateTitleLabel
    }
    var abstractLabel: UILabel {
        return privateAbstractLabel
    }
    var favouriteButton: UIButton {
        return privateFavouriteButton
    }

    private var privateTitleLabel: UILabel!
    private var privateAbstractLabel: UILabel!
    private var privateFavouriteButton: UIButton!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    class func avatarImage() -> UIImage? {
        var avatarImage: UIImage?
        var onceToken: Int = 0
        // TODO: use a static variable (`dispatch_once` is deprecated)
    if (onceToken == 0) {
            avatarImage = UIImage(named: "avatar")
        }
    onceToken = 1
        return avatarImage
    }

    class func favouriteOnImage() -> UIImage? {
        var image: UIImage?
        var onceToken: Int = 0
        // TODO: use a static variable (`dispatch_once` is deprecated)
    if (onceToken == 0) {
            image = UIImage(named: "fav_on")
        }
    onceToken = 1
        return image
    }

    class func favouriteOffImage() -> UIImage? {
        var image: UIImage?
        var onceToken: Int = 0
        // TODO: use a static variable (`dispatch_once` is deprecated)
    if (onceToken == 0) {
            image = UIImage(named: "fav_off")
        }
    onceToken = 1
        return image
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        imageView?.image = FavouriteTableViewCell.avatarImage()
        privateTitleLabel = UILabel.autolayout()
        privateAbstractLabel = UILabel.autolayout()
        privateAbstractLabel.numberOfLines = 2
        privateFavouriteButton = UIButton.autolayout()
        privateFavouriteButton.setImage(FavouriteTableViewCell.favouriteOffImage(), for: .normal)
        privateFavouriteButton.setImage(FavouriteTableViewCell.favouriteOnImage(), for: .selected)
        contentView.addSubview(privateTitleLabel)
        contentView.addSubview(privateAbstractLabel)
        contentView.addSubview(privateFavouriteButton)
        privateTitleLabel.mas_makeConstraints({ make in
            _ = make?.left.equalTo()(self.imageView?.mas_right)?.offset()(10)
            _ = make?.right.equalTo()(self.privateFavouriteButton.mas_left)?.offset()(-10)
            _ = make?.top.equalTo()(self.privateTitleLabel.superview)?.offset()(10)
        })
        privateAbstractLabel.mas_makeConstraints({ make in
            _ = make?.top.equalTo()(self.privateTitleLabel.mas_bottom)?.offset()(10)
            _ = make?.left.right().equalTo()(self.privateTitleLabel)
            _ = make?.bottom.equalTo()(self.contentView)?.offset()(-10)
        })
        privateFavouriteButton.mas_makeConstraints({ make in
            _ = make?.width.and().height().equalTo()(40)
            _ = make?.right.equalTo()(self.privateFavouriteButton.superview)?.offset()(-10)
            _ = make?.centerY.equalTo()(self.privateFavouriteButton.superview)
        })
    
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView?.image = FavouriteTableViewCell.avatarImage()
        textLabel?.text = ""
        detailTextLabel?.text = ""
        titleLabel.text = ""
        abstractLabel.text = ""
        privateFavouriteButton.isSelected = false
    }
}
