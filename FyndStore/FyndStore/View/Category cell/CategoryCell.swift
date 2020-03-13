//
//  CategoryCell.swift
//  FyndStore
//
//  Created by Kumar Lav on 3/11/20.
//  Copyright © 2020 Kumar Lav. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   
    

    
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var sortingSegCon: UISegmentedControl!
    @IBOutlet weak var productCollectionView: UICollectionView!
    
    
    var parentViewController: UIViewController? = nil
    var productArr = [ProductModel]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.productCollectionView.delegate = self
        self.productCollectionView.dataSource = self
        
        let nib = UINib(nibName: "ProductCell", bundle: nil)
        productCollectionView.register(nib, forCellWithReuseIdentifier: "ProductCell")
    }

 
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productArr.count
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = productCollectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCell
        cell.product = productArr[indexPath.row]
        return cell
       }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width) / 3
        return CGSize(width: width, height: 153)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProductImgDetailsVC") as! ProductImgDetailsVC
        vc.modalTransitionStyle = .flipHorizontal
        vc.productData = productArr[indexPath.row]
        self.parentViewController?.present(vc, animated: true, completion: nil)
       
    }
    
    
    
    @IBAction func sortProductAction(_ sender: UISegmentedControl) {
        if sortingSegCon.selectedSegmentIndex == 0{
            self.sortByPrice()
        }
        else{
            sortByName()
        }
        
    }
    
    
    func sortByPrice()
    {
        let newProductArr = productArr.sorted(by: {$0.cost > $1.cost})
        
        productArr.removeAll()
        productArr = newProductArr
        self.productCollectionView.reloadData()
    }
    
    func sortByName()
       {
        let newProductArr = productArr.sorted(by: {$0.name > $1.name})
           
           productArr.removeAll()
           productArr = newProductArr
           self.productCollectionView.reloadData()
       }
    
}
