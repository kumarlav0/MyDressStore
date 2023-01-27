//
//  CategoryCell.swift
//  FyndStore
//
//  Kumar Lav on 27/01/23 Kumar Lav on 3/11/20.
//  Copyright © 2020 Kumar Lav. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {
    
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var sortingSegCon: UISegmentedControl!
    @IBOutlet weak var productCollectionView: UICollectionView!
    
    
    var parentViewController: UIViewController?
    var productArr = [ProductModel]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        let nib = UINib(nibName: "ProductCell", bundle: nil)
        productCollectionView.register(nib, forCellWithReuseIdentifier: "ProductCell")
    }

 
    func setupData(_ data: CategoryModel, context: UIViewController) {
        parentViewController = context
        categoryName.text = data.name
        productArr =  data.products
        reloadData()
    }

    @IBAction func sortProductAction(_ sender: UISegmentedControl) {
        sortingSegCon.selectedSegmentIndex == 0 ? sortByPrice() : sortByName()
    }


    func sortByPrice() {
        let newProductArr = productArr.sorted(by: {$0.cost > $1.cost})
        productArr.removeAll()
        productArr = newProductArr
        reloadData()
    }

    func sortByName() {
        let newProductArr = productArr.sorted(by: {$0.name > $1.name})
        productArr.removeAll()
        productArr = newProductArr
        reloadData()
    }

    func reloadData() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.productCollectionView.reloadData()
        }
    }

}

extension CategoryCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

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
        let vc = parentViewController?.storyboard?.instantiateViewController(withIdentifier: "ProductImgDetailsViewController") as! ProductImgDetailsViewController
        vc.modalTransitionStyle = .flipHorizontal
        vc.productData = productArr[indexPath.row]
        self.parentViewController?.present(vc, animated: true, completion: nil)

    }
}
