//
//  collectionCell.swift
//  BidirectionalLayout
//
//  Created by Tamta Topuria on 12/18/20.
//

import UIKit

class collectionCell: UITableViewCell {
    
    @IBOutlet var collectionView: UICollectionView!

    lazy var flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        return flowLayout
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.collectionViewLayout = flowLayout
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 2*Constants.spacing, bottom: 0, right: 2*Constants.spacing)
        
        collectionView.register(
            UINib(nibName: "yellowCell", bundle: nil),
            forCellWithReuseIdentifier: "yellowCell"
        )
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: Constants.spacing, left: 0, bottom: Constants.spacing, right: 0))
    }
    
}

extension collectionCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "yellowCell", for: indexPath)
    }
}

extension collectionCell: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let fullHeight = collectionView.frame.height - (Constants.itemCountInLine - 1) * Constants.spacing
        var itemHeight = fullHeight * 0.7
        if indexPath.item % 4 == 0 || indexPath.item % 4 == 3 {
            itemHeight = fullHeight * 0.3
        }
        return CGSize(
            width: fullHeight * 0.55,
            height: itemHeight
        )
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return Constants.spacing
    }
    
    
}
