//
//  UITagCollectionViewCell.swift
//  Pods
//
//  Created by George Tsifrikas on 06/12/15.
//  Edited by Fernando Valle on 22/10/16.
//
//

import UIKit

class UITagCollectionViewCell: UICollectionViewCell {
    
    var title = "" {
        didSet {
            self.titleLabelRef?.font = UIFont(name: fontFamily, size: fontSize)
            self.titleLabelRef?.textColor = textColor
            self.titleLabelRef?.textAlignment = .center
            self.titleLabelRef?.text = title
        }
    }
    var fontSize: CGFloat = 11.0
    var fontFamily = "System"
    var textColor: UIColor?
    var cornerRadius: CGFloat = 3.0
    
    fileprivate weak var titleLabelRef: UILabel?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        title = ""
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        let titleLabel = UILabel(frame: bounds)
        titleLabelRef = titleLabel
        titleLabelRef?.font = UIFont(name: fontFamily, size: fontSize)
        titleLabelRef?.textColor = textColor
        titleLabelRef?.textAlignment = .center
        contentView.addSubview(titleLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabelRef?.frame = bounds
        contentView.layer.cornerRadius = cornerRadius
    }
}
