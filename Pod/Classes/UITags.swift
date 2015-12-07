//
//  UITags.swift
//  Pods
//
//  Created by George Tsifrikas on 06/12/15.
//
//

import UIKit
import UICollectionViewLeftAlignedLayout

@IBDesignable public class UITags: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBInspectable var tagColor:UIColor?
    @IBInspectable var tagSelectedColor:UIColor?
    
    @IBInspectable var fontSize: CGFloat = 11.0
    @IBInspectable var fontFamily: String = "System"
    @IBInspectable var textColor:UIColor?
    @IBInspectable var textColorSelected:UIColor?
    
    @IBInspectable var tagHorizontalDistance:CGFloat = 2
    @IBInspectable var tagVerticalDistance:CGFloat = 3
    
    @IBInspectable var horizontalPadding:CGFloat = 3
    @IBInspectable var verticalPadding:CGFloat = 2
    
    private var collectionView:UICollectionView?

    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.tags = ["This", "is","a", "demo","for", "storyboard",".", "Please","make", "an","outlet", "and", "specify", "your", "own", "tags"]
    }
    
    public var delegate:UITagsViewDelegate?
    
    public var tags:[String] = [] {
        didSet {
            self.createTags()
        }
    }
    
    private var selectedTags:[Int] = []
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    private func setUp() {
//        let standardLayout = UICollectionViewFlowLayout()
        self.collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: UICollectionViewLeftAlignedLayout())
        self.collectionView!.delegate = self
        self.collectionView!.dataSource = self
        self.collectionView!.showsHorizontalScrollIndicator = false
        self.collectionView!.showsVerticalScrollIndicator = false
        self.collectionView?.backgroundColor = UIColor.clearColor()
        self.collectionView!.registerClass(UITagCollectionViewCell.self, forCellWithReuseIdentifier: "tagCell")
        self.addSubview(self.collectionView!)
    }
    
    private func createTags() {
        self.collectionView?.reloadData()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.collectionView?.frame = self.bounds
    }
    
    //MARK: - collection view dataSource implemantation
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return configureCell(collectionView.dequeueReusableCellWithReuseIdentifier("tagCell", forIndexPath: indexPath), cellForItemAtIndexPath: indexPath)
    }
    
    private func configureCell(cell: UICollectionViewCell, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cellToConfigure = cell as! UITagCollectionViewCell
        cellToConfigure.fontFamily = self.fontFamily
        cellToConfigure.fontSize = self.fontSize
        cellToConfigure.textColor = self.selectedTags.contains(indexPath.row) ? self.textColorSelected : self.textColor
        cellToConfigure.contentView.backgroundColor = self.selectedTags.contains(indexPath.row) ? self.tagSelectedColor : self.tagColor
        cellToConfigure.title = self.tags[indexPath.row]
        return cellToConfigure
    }
    
    //MARK: - util methods
    private func sizeForCellAt(indexPath:NSIndexPath) -> CGSize {
        let tempLabel = UILabel()
        tempLabel.text = self.tags[indexPath.row]
        tempLabel.font = UIFont(name: fontFamily, size: fontSize)
        tempLabel.textColor = textColor
        tempLabel.textAlignment = .Center
        
        var size = tempLabel.sizeThatFits(CGSize(width: CGFloat.max, height: CGFloat.max))
        size.height += 2 * verticalPadding
        size.width += 2 * horizontalPadding
        
        return size
    }
    
    //MARK: - collectionview flow layout delegate implementation
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return sizeForCellAt(indexPath)
    }
    
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return self.tagHorizontalDistance
    }
    
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return self.tagVerticalDistance
    }
    
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    //MARK: - collection view delegate implementation
    
    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if self.selectedTags.contains(indexPath.row) {
            self.selectedTags.removeObject(indexPath.row)
            self.delegate?.tagDeselected(atIndex: indexPath.row)
        } else {
            self.selectedTags += [indexPath.row]
            self.delegate?.tagSelected(atIndex: indexPath.row)
        }
                
        self.configureCell(self.collectionView!.cellForItemAtIndexPath(indexPath)!, cellForItemAtIndexPath: indexPath)
    }
}

private extension Array where Element: Equatable {
    mutating func removeObject(object: Element) {
        if let index = self.indexOf(object) {
            self.removeAtIndex(index)
        }
    }
    
    mutating func removeObjectsInArray(array: [Element]) {
        for object in array {
            self.removeObject(object)
        }
    }
}

public protocol UITagsViewDelegate {
    func tagSelected(atIndex index:Int) -> Void
    func tagDeselected(atIndex index:Int) -> Void
}

