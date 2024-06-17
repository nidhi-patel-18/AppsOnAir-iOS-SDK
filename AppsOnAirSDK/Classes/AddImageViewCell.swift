//
//  AddImageViewCell.swift
//  AppsOnAir
//
//  Created by nidhi-patel-us on 14/06/24.
//

import Foundation


class AddImageViewCell: UICollectionViewCell {
    
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var bgImageView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnAdd.setTitle("", for: .normal)
    }

}
