//
//  ProductCell.swift
//  FyndStore
//
//  Created by Kumar Lav on 3/11/20.
//  Copyright © 2020 Kumar Lav. All rights reserved.
//

import UIKit
import Kingfisher


class ProductCell: UICollectionViewCell {

    @IBOutlet weak var productImgView: UIImageView!
    
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productCostLabel: UILabel!
    
    var product: ProductModel!{
        
        willSet(newProduct){
            self.productNameLabel.text! = newProduct.name
            self.productCostLabel.text! = "\(newProduct.cost)$"
            let url = URL(string: newProduct.productImg)
            productImgView.kf.indicatorType = .activity
            productImgView.kf.setImage(
                with: url,
                placeholder: UIImage(named: "splash"),
                options: [
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ])
        }
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
