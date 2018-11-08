//
//  UITags.swift
//  Pods
//
//  Created by George Tsifrikas on 06/12/15.
//
//

import UIKit
import UICollectionViewLeftAlignedLayout

@IBDesignable
public class UITags: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBInspectable public var tagColor: UIColor?
    @IBInspectable public var tagSelectedColor: UIColor?
    
    @IBInspectable public var fontSize: CGFloat = 11.0
    @IBInspectable public var fontFamily = "System"
    @IBInspectable public var textColor: UIColor?
    @IBInspectable public var textColorSelected: UIColor?
    
    @IBInspectable public var tagHorizontalDistance: CGFloat = 2
    @IBInspectable public var tagVerticalDistance: CGFloat = 3
    
    @IBInspectable public var horizontalPadding: CGFloat = 3
    @IBInspectable public var verticalPadding: CGFloat = 2
    @IBInspectable public var tagCornerRadius: CGFloat = 3

    
    public var collectionView: UICollectionView?
    
    public var layout: UICollectionViewLayout = UICollectionViewLeftAlignedLayout() {
        didSet {
            collectionView?.removeFromSuperview()
            setUp()
            setNeedsLayout()
        }
    }

    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.tags = ["This", "is","a", "demo","for", "storyboard",".", "Please","make", "an","outlet", "and", "specify", "your", "own", "tags"]
    }
    
    public var delegate: UITagsViewDelegate?
    
    public var tags: [String] = [] {
        didSet {
            self.selectedTags.removeAll()
            self.createTags()
        }
    }
    
    public var selectedTags = [Int]()
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    private var contentHeight: CGFloat = 0.0
    
    private func setUp() {
        collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.backgroundColor = UIColor.clear
        collectionView?.register(UITagCollectionViewCell.self, forCellWithReuseIdentifier: "tagCell")
        if let collectionView = collectionView {
            self.addSubview(collectionView)
            self.layoutSubviews()
        }
    }
    
    private func createTags() {
        collectionView?.reloadData()
        layoutSubviews()
    }
    
    public override var intrinsicContentSize: CGSize {
        let size = CGSize(width: frame.width, height: contentHeight)
        return size
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        collectionView?.frame = bounds
        collectionView?.layoutSubviews()
        contentHeight = calculatedHeight()
        invalidateIntrinsicContentSize()
    }
    
    //MARK: - collection view dataSource implemantation
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return configureCell(cell: collectionView.dequeueReusableCell(withReuseIdentifier: "tagCell", for: indexPath), cellForItemAtIndexPath: indexPath)
    }
    
    private func configureCell(cell: UICollectionViewCell, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        guard let cellToConfigure = cell as? UITagCollectionViewCell else {
            print("Could not load UITagCollectionViewCell..")
            return UICollectionViewCell()
        }
        cellToConfigure.cornerRadius = self.tagCornerRadius
        cellToConfigure.fontFamily = self.fontFamily
        cellToConfigure.fontSize = self.fontSize
        cellToConfigure.textColor = self.selectedTags.contains(indexPath.row) ? self.textColorSelected : self.textColor
        cellToConfigure.contentView.backgroundColor = self.selectedTags.contains(indexPath.row) ? self.tagSelectedColor : self.tagColor
        cellToConfigure.title = self.tags[indexPath.row]
        return cellToConfigure
    }
    
    //MARK: - util methods
    private func sizeForCellAt(indexPath: IndexPath) -> CGSize {
        let tempLabel = UILabel()
        tempLabel.text = self.tags[indexPath.row]
        tempLabel.font = UIFont(name: fontFamily, size: fontSize)
        tempLabel.textColor = textColor
        tempLabel.textAlignment = .center
        
        var size = tempLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        size.height += 2 * verticalPadding
        size.width += 2 * horizontalPadding
        
        return size
    }
    
    private func calculatedHeight() -> CGFloat {
        var totalHeight: CGFloat = 0
        
        let numberOfTags = collectionView!.numberOfItems(inSection: 0)
        
        let maximumRowWidth = frame.size.width
        
        var currentRowWidth: CGFloat = 0.0
        for var tagIndex in 0..<numberOfTags {
            
            var cellSize = sizeForCellAt(indexPath: IndexPath(item: tagIndex, section: 0))
            cellSize.height += tagVerticalDistance
            cellSize.width += tagHorizontalDistance
            
            if currentRowWidth == 0 {
                totalHeight += cellSize.height
            }
            
            currentRowWidth += cellSize.width
            
            if maximumRowWidth - currentRowWidth < cellSize.width {
                currentRowWidth = 0
                tagIndex -= 1
                continue
            }
        }
        return totalHeight
    }
    
    //MARK: - collectionview flow layout delegate implementation
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return sizeForCellAt(indexPath: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return self.tagHorizontalDistance
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.tagVerticalDistance
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    //MARK: - collection view delegate implementation
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.selectedTags.contains(indexPath.row) {
            self.selectedTags.removeObject(object: indexPath.row)
            self.delegate?.tagDeselected(atIndex: indexPath.row)
        } else {
            self.selectedTags += [indexPath.row]
            self.delegate?.tagSelected(atIndex: indexPath.row)
        }
        
        let _ = self.configureCell(cell: collectionView.cellForItem(at: indexPath)!, cellForItemAtIndexPath: indexPath)
    }
}

private extension Array where Element: Equatable {
    mutating func removeObject(object: Element) {
        for (index, obj) in self.enumerated() {
            if object == obj {
                self.remove(at: index)
            }
        }
    }
}

public protocol UITagsViewDelegate {
    func tagSelected(atIndex index:Int) -> Void
    func tagDeselected(atIndex index:Int) -> Void
}

