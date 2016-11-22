//
//  UITags.swift
//  Pods
//
//  Created by George Tsifrikas on 06/12/15.
//  Edited by Fernando Valle on 22/10/16.
//
//

import UIKit
import UICollectionViewLeftAlignedLayout

@IBDesignable
open class UITags: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBInspectable open var tagColor: UIColor?
    @IBInspectable open var tagSelectedColor: UIColor?
    
    @IBInspectable open var fontSize: CGFloat = 11.0
    @IBInspectable open var fontFamily = "System"
    @IBInspectable open var textColor: UIColor?
    @IBInspectable open var textColorSelected: UIColor?
    
    @IBInspectable open var tagHorizontalDistance: CGFloat = 2
    @IBInspectable open var tagVerticalDistance: CGFloat = 3
    
    @IBInspectable open var horizontalPadding: CGFloat = 3
    @IBInspectable open var verticalPadding: CGFloat = 2
    @IBInspectable open var tagCornerRadius: CGFloat = 3
    
    @IBInspectable open var canBeSelected = true
    
    
    
    open var collectionView: UICollectionView?
    
    open var layout: UICollectionViewLayout = UICollectionViewLeftAlignedLayout() {
        didSet {
            collectionView?.removeFromSuperview()
            setUp()
            setNeedsLayout()
        }
    }
    
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.tags = ["This", "is","a", "demo","for", "storyboard",".", "Please","make", "an","outlet", "and", "specify", "your", "own", "tags"]
    }
    
    open var delegate: UITagsViewDelegate?
    
    open var tags: [String] = [] {
        didSet {
            self.selectedTags.removeAll()
            self.createTags()
        }
    }
    
    
    open var customColors: [Int : UIColor] = [:] {
        didSet {
            self.selectedTags.removeAll()
            self.createTags()
        }
    }
    
    open var customSelectedColors: [Int : UIColor] = [:] {
        didSet {
            self.selectedTags.removeAll()
            self.createTags()
        }
    }
    
    open var selectedTags = [Int]()
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    fileprivate var contentHeight: CGFloat = 0.0
    
    fileprivate func setUp() {
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
    
    fileprivate func createTags() {
        collectionView?.reloadData()
        layoutSubviews()
    }
    
    open override var intrinsicContentSize : CGSize {
        let size = CGSize(width: frame.width, height: contentHeight)
        return size
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        collectionView?.frame = bounds
        collectionView?.layoutSubviews()
        contentHeight = calculatedHeight()
        invalidateIntrinsicContentSize()
    }
    
    //MARK: - collection view dataSource implemantation
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return configureCell(collectionView.dequeueReusableCell(withReuseIdentifier: "tagCell", for: indexPath), cellForItemAtIndexPath: indexPath)
    }
    
    fileprivate func configureCell(_ cell: UICollectionViewCell, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        guard let cellToConfigure = cell as? UITagCollectionViewCell else {
            print("Could not load UITagCollectionViewCell..")
            return UICollectionViewCell()
        }
        cellToConfigure.cornerRadius = self.tagCornerRadius
        cellToConfigure.fontFamily = self.fontFamily
        cellToConfigure.fontSize = self.fontSize
        cellToConfigure.textColor = self.selectedTags.contains(indexPath.row) ? self.textColorSelected : self.textColor
        if(self.customColors[indexPath.row] != nil)
        {
            cellToConfigure.contentView.backgroundColor = self.selectedTags.contains(indexPath.row) ?
                self.customSelectedColors[indexPath.row] : self.customColors[indexPath.row]
        }
        else{
            cellToConfigure.contentView.backgroundColor = self.selectedTags.contains(indexPath.row) ? self.tagSelectedColor : self.tagColor
        }
        
        cellToConfigure.title = self.tags[indexPath.row]
        return cellToConfigure
    }
    
    //MARK: - util methods
    fileprivate func sizeForCellAt(_ indexPath:IndexPath) -> CGSize {
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
    
    fileprivate func calculatedHeight() -> CGFloat {
        var totalHeight: CGFloat = 0
        
        let numberOfTags = collectionView!.numberOfItems(inSection: 0)
        
        let maximumRowWidth = frame.size.width
        
        var currentRowWidth: CGFloat = 0.0
        for var tagIndex in 0..<numberOfTags {
            
            var cellSize = sizeForCellAt(IndexPath(item: tagIndex, section: 0))
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
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return sizeForCellAt(indexPath)
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return self.tagHorizontalDistance
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.tagVerticalDistance
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    //MARK: - collection view delegate implementation
    
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(canBeSelected)
        {
            if self.selectedTags.contains(indexPath.row) {
                self.selectedTags.removeObject(indexPath.row)
                self.delegate?.tagDeselected(atIndex: indexPath.row)
            } else {
                self.selectedTags += [indexPath.row]
                self.delegate?.tagSelected(atIndex: indexPath.row)
            }
            
            self.configureCell(self.collectionView!.cellForItem(at: indexPath)!, cellForItemAtIndexPath: indexPath)
        }
        
    }
    
    open func setCustomColor(color: UIColor, selectedColor: UIColor, position: Int)
    {
        self.customColors[position] = color
        self.customSelectedColors[position] = selectedColor != nil ? selectedColor : color
        self.selectedTags.removeAll()
        self.createTags()
    }
}

private extension Array where Element: Equatable {
    mutating func removeObject(_ object: Element) {
        if let index = self.index(of: object) {
            self.remove(at: index)
        }
    }
    
    mutating func removeObjectsInArray(_ array: [Element]) {
        for object in array {
            self.removeObject(object)
        }
    }
}

public protocol UITagsViewDelegate {
    func tagSelected(atIndex index:Int) -> Void
    func tagDeselected(atIndex index:Int) -> Void
}

