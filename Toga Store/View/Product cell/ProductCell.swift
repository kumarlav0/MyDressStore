//
//  ProductCell.swift
//
//  Kumar Lav on 27/01/23.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setImage(urlStr: String) {
        let url = URL(string: urlStr)
        kf.indicatorType = .activity
        kf.setImage(
            with: url,
            placeholder: UIImage(named: "splash"),
            options: [
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
    }
}


class ProductCell: UICollectionViewCell {

    @IBOutlet weak var productImgView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productCostLabel: UILabel!
    
    var product: ProductModel!{
        
        willSet(newProduct) {
            productNameLabel.text = newProduct.name
            productCostLabel.text = "\(newProduct.cost)$"
            productImgView.setImage(urlStr: newProduct.productImg)
        }
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
