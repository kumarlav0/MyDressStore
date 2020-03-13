//
//  ProductsVC.swift
//  FyndStore
//
//  Created by Kumar Lav on 3/11/20.
//  Copyright © 2020 Kumar Lav. All rights reserved.
//

import UIKit

class ProductsVC: UIViewController
{

    @IBOutlet weak var categoryList: UITableView!
    
       var categoryArray = [CategoryModel]()
    
       var isGridView = true
       
       let kHeaderSectionTag: Int = 6900
       var expandedSectionHeaderNumber: Int = -1
       var expandedSectionHeader: UITableViewHeaderFooterView!
       var sectionItems = [Any]()
       var sectionNames = [Any]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let nib = UINib(nibName: "CategoryCell", bundle: nil)
        categoryList.register(nib, forCellReuseIdentifier: "CategoryCell")
        
       self.categoryList!.tableFooterView = UIView()
        getAllCategory()
    }
    
// MARK:- Grid to List Switch Action
    @IBAction func gridToListSwitchAction(_ sender: UISwitch) {
        if sender.isOn{
            isGridView = true
        }
        else{
            isGridView = false
        }
        
       categoryList.reloadData()
        
    }
    

}



extension ProductsVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
            if isGridView{
                return 1
              }
            else{
              
                if categoryArray.count > 0 {
                            tableView.backgroundView = nil
                            return categoryArray.count
                        } else {
                            let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height))
                            messageLabel.text = "Retrieving data.\nPlease wait."
                            messageLabel.numberOfLines = 0;
                            messageLabel.textAlignment = .center;
                            messageLabel.font = UIFont(name: "HelveticaNeue", size: 20.0)!
                            messageLabel.sizeToFit()
                            tableView.backgroundView = messageLabel
                        }
                  return 0
              }
        }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isGridView{
             return self.categoryArray.count
        }
        else{
              if (self.expandedSectionHeaderNumber == section) {
                        let arrayOfItems = self.categoryArray[section].products
                         return arrayOfItems.count
                     } else {
                         return 0
                     }
        }
       
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
       if isGridView{
                  return ""
             }
              else{
                 if (self.categoryArray.count != 0) {
                     return self.categoryArray[section].name
                  }
                  return ""
             }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
         if isGridView{
             return 0
        }
         else{
             return 44.0
        }
       
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        return 0
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if isGridView{
                   
              }
               else{
                 //recast your view as a UITableViewHeaderFooterView
                   let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
                   header.contentView.backgroundColor = #colorLiteral(red: 0.5294117647, green: 0.3019607843, blue: 0.7490196078, alpha: 1)
                   header.textLabel?.textColor = UIColor.white
                   
                   if let viewWithTag = self.view.viewWithTag(kHeaderSectionTag + section) {
                       viewWithTag.removeFromSuperview()
                   }
                   let headerFrame = self.view.frame.size
                   let theImageView = UIImageView(frame: CGRect(x: headerFrame.width - 32, y: 13, width: 18, height: 18));
                   theImageView.image = UIImage(named: "Chevron-Dn-Wht")
                   theImageView.tag = kHeaderSectionTag + section
                   header.addSubview(theImageView)
                   
                   // make headers touchable
                   header.tag = section
                   let headerTapGesture = UITapGestureRecognizer()
                   headerTapGesture.addTarget(self, action: #selector(ProductsVC.sectionHeaderWasTouched(_:)))
                   header.addGestureRecognizer(headerTapGesture)
              }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isGridView{
            return 364
        }
        else{
            return 45
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
         if isGridView{
            let cell = categoryList.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
            cell.parentViewController = self
            
          
                let dict = self.categoryArray[indexPath.row]
                cell.categoryName.text! = dict.name
                cell.productArr =  dict.products
                cell.productCollectionView.reloadData()
            
            
            print("dict.products::::::",dict.products.count)
             return cell
        }
         else{
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
                   let section = self.categoryArray[indexPath.section].products
                  
                   cell.textLabel?.textColor = UIColor.black
                   cell.textLabel?.text = section[indexPath.row].name
                    
                    return cell
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
           if isGridView{
              }
           else{
            tableView.deselectRow(at: indexPath, animated: true)
             }
        }
        
        // MARK: - Expand / Collapse Methods
        
        @objc func sectionHeaderWasTouched(_ sender: UITapGestureRecognizer) {
            let headerView = sender.view as! UITableViewHeaderFooterView
            let section    = headerView.tag
            let eImageView = headerView.viewWithTag(kHeaderSectionTag + section) as? UIImageView
            
            if (self.expandedSectionHeaderNumber == -1) {
                self.expandedSectionHeaderNumber = section
                tableViewExpandSection(section, imageView: eImageView!)
            } else {
                if (self.expandedSectionHeaderNumber == section) {
                    tableViewCollapeSection(section, imageView: eImageView!)
                } else {
                    let cImageView = self.view.viewWithTag(kHeaderSectionTag + self.expandedSectionHeaderNumber) as? UIImageView
                    tableViewCollapeSection(self.expandedSectionHeaderNumber, imageView: cImageView!)
                    tableViewExpandSection(section, imageView: eImageView!)
                }
            }
        }
        
        func tableViewCollapeSection(_ section: Int, imageView: UIImageView) {
           let sectionData = self.categoryArray[section].products
            
            self.expandedSectionHeaderNumber = -1;
            if (sectionData.count == 0) {
                return;
            } else {
                UIView.animate(withDuration: 0.4, animations: {
                    imageView.transform = CGAffineTransform(rotationAngle: (0.0 * CGFloat(Double.pi)) / 180.0)
                })
                var indexesPath = [IndexPath]()
                for i in 0 ..< sectionData.count {
                    let index = IndexPath(row: i, section: section)
                    indexesPath.append(index)
                }
                self.categoryList!.beginUpdates()
                self.categoryList!.deleteRows(at: indexesPath, with: UITableView.RowAnimation.fade)
                self.categoryList!.endUpdates()
            }
        }
        
        func tableViewExpandSection(_ section: Int, imageView: UIImageView) {
           let sectionData = self.categoryArray[section].products
            
            if (sectionData.count == 0) {
                self.expandedSectionHeaderNumber = -1;
                return;
            } else {
                UIView.animate(withDuration: 0.4, animations: {
                    imageView.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(Double.pi)) / 180.0)
                })
                var indexesPath = [IndexPath]()
                for i in 0 ..< sectionData.count {
                    let index = IndexPath(row: i, section: section)
                    indexesPath.append(index)
                }
                self.expandedSectionHeaderNumber = section
                self.categoryList!.beginUpdates()
                self.categoryList!.insertRows(at: indexesPath, with: UITableView.RowAnimation.fade)
                self.categoryList!.endUpdates()
            }
        }

       
       

    
    
}



extension ProductsVC{
    
    
    func getAllCategory()
    {
        
        let dict = [String:AnyObject]()
        
       
        WebHelper.requestgetUrl(strURL: ApiNames.ALL_CATEGORY, Dictionary: dict, Controller: self, Success: { (success) in
            
            print("Arrrr:::",success)
            if let categoryArr = success as? NSArray{
                
                for i in categoryArr{
                   
                    let dict = i as! NSDictionary
                    
                    let name = Global.getStringValue(dict.value(forKey: "name") as AnyObject)
                    var productArr = [ProductModel]()
                    var imgCount = 0
                    if let product = dict.value(forKey: "products") as? NSArray{
                        for i in product{
                            
                          let proDict = i as! NSDictionary
                            let sku = proDict.value(forKey: "sku") as! Int
                            let name = Global.getStringValue(proDict.value(forKey: "name") as AnyObject)
                            let cost = proDict.value(forKey: "cost") as! Float
                            let proObj = ProductModel(sku: sku, name: name, cost: cost, productImg: Global.productImg[imgCount])
                            productArr.append(proObj)
                            imgCount += 1
                            if imgCount > 3{
                                imgCount = 0
                            }
                            
                        }
                    }
                    
                    let obj = CategoryModel(products: productArr, name: name)
                    self.categoryArray.append(obj)
                    
                }
                self.categoryList.reloadData()
            }
            
            
            
            
            
        }) { (error) in
            print("Error:::",error.localizedDescription)
        }
        
        
    }
    
    
}



