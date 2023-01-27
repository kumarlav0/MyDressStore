//
//  ProductsVC.swift
//  FyndStore
//
//  Kumar Lav on 27/01/23 Kumar Lav on 3/11/20.
//  Copyright © 2020 Kumar Lav. All rights reserved.
//

import UIKit

extension UITableView {
    func setBgMesaage()  {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height))
        messageLabel.text = "Retrieving data.\nPlease wait."
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "HelveticaNeue", size: 20.0)!
        messageLabel.sizeToFit()
        backgroundView = messageLabel
    }
}

class ProductsViewController: UIViewController {

    @IBOutlet weak var categoryList: UITableView!

    let viewModel = ProductListViewModel()
    var expandedSectionHeader: UITableViewHeaderFooterView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "CategoryCell", bundle: nil)
        categoryList.register(nib, forCellReuseIdentifier: "CategoryCell")
        viewModel.delegate = self
        categoryList.tableFooterView = UIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        viewModel.getAllCategory()
    }
    
    // MARK:- Grid to List Switch Action
    @IBAction func gridToListSwitchAction(_ sender: UISwitch) {
        viewModel.isGridView = sender.isOn
        reloadData()
    }
}

extension ProductsViewController: ProductListViewModelDelegate {
    func reloadData() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.categoryList.reloadData()
        }
    }
}


extension ProductsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if viewModel.categoryArray.count <= 0 {
            tableView.setBgMesaage()
            return 0
        } else if viewModel.isGridView {
            return 1
        } else {
            tableView.backgroundView = nil
            return viewModel.categoryArray.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.isGridView ? viewModel.categoryArray.count : viewModel.expandedSectionHeaderNumber == section ? viewModel.categoryArray[section].products.count : 0
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        !viewModel.isGridView && viewModel.categoryArray.count != 0 ? viewModel.categoryArray[section].name : ""
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        viewModel.isGridView ? 0 : 44.0
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if !viewModel.isGridView {
            //recast your view as a UITableViewHeaderFooterView
            let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
            header.contentView.backgroundColor = #colorLiteral(red: 0.5294117647, green: 0.3019607843, blue: 0.7490196078, alpha: 1)
            header.textLabel?.textColor = UIColor.white

            if let viewWithTag = view.viewWithTag(viewModel.kHeaderSectionTag + section) {
                viewWithTag.removeFromSuperview()
            }
            let headerFrame = view.frame.size
            let theImageView = UIImageView(frame: CGRect(x: headerFrame.width - 32, y: 13, width: 18, height: 18));
            theImageView.image = UIImage(named: "Chevron-Dn-Wht")
            theImageView.tag = viewModel.kHeaderSectionTag + section
            header.addSubview(theImageView)

            // make headers touchable
            header.tag = section
            let headerTapGesture = UITapGestureRecognizer()
            headerTapGesture.addTarget(self, action: #selector(sectionHeaderWasTouched(_:)))
            header.addGestureRecognizer(headerTapGesture)
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        viewModel.isGridView ? 364 : 45
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.isGridView {
            let cell = categoryList.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
            let obj = viewModel.categoryArray[indexPath.row]
            cell.setupData(obj, context: self)
            return cell
        } else {
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            let section = viewModel.categoryArray[indexPath.section].products
            cell.textLabel?.textColor = UIColor.black
            cell.textLabel?.text = section[indexPath.row].name
            cell.imageView?.setImage(urlStr: section[indexPath.row].productImg)
            return cell
        }
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ProductImgDetailsViewController") as! ProductImgDetailsViewController
        vc.modalTransitionStyle = .flipHorizontal
        vc.productData = viewModel.categoryArray[indexPath.section].products[indexPath.row]
        present(vc, animated: true, completion: nil)
    }
    // MARK: - Expand / Collapse Methods

    @objc private func sectionHeaderWasTouched(_ sender: UITapGestureRecognizer) {
        let headerView = sender.view as! UITableViewHeaderFooterView
        let section    = headerView.tag
        let eImageView = headerView.viewWithTag(viewModel.kHeaderSectionTag + section) as? UIImageView

        if viewModel.expandedSectionHeaderNumber == -1 {
            viewModel.expandedSectionHeaderNumber = section
            tableViewExpandSection(section, imageView: eImageView!)
        } else {
            if viewModel.expandedSectionHeaderNumber == section {
                tableViewCollapeSection(section, imageView: eImageView!)
            } else {
                let cImageView = view.viewWithTag(viewModel.kHeaderSectionTag + viewModel.expandedSectionHeaderNumber) as? UIImageView
                tableViewCollapeSection(viewModel.expandedSectionHeaderNumber, imageView: cImageView!)
                tableViewExpandSection(section, imageView: eImageView!)
            }
        }
    }

    func tableViewCollapeSection(_ section: Int, imageView: UIImageView) {
        let sectionData = viewModel.categoryArray[section].products

        viewModel.expandedSectionHeaderNumber = -1
        if sectionData.count == 0 {
            return
        } else {
            UIView.animate(withDuration: 0.4) {
                imageView.transform = CGAffineTransform(rotationAngle: (0.0 * CGFloat(Double.pi)) / 180.0)
            }
            var indexesPath = [IndexPath]()
            for i in 0 ..< sectionData.count {
                let index = IndexPath(row: i, section: section)
                indexesPath.append(index)
            }
            categoryList.beginUpdates()
            categoryList.deleteRows(at: indexesPath, with: UITableView.RowAnimation.fade)
            categoryList.endUpdates()
        }
    }

    func tableViewExpandSection(_ section: Int, imageView: UIImageView) {
        let sectionData = viewModel.categoryArray[section].products

        if sectionData.count == 0 {
            viewModel.expandedSectionHeaderNumber = -1
            return
        } else {
            UIView.animate(withDuration: 0.4) {
                imageView.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(Double.pi)) / 180.0)
            }
            var indexesPath = [IndexPath]()
            for i in 0 ..< sectionData.count {
                let index = IndexPath(row: i, section: section)
                indexesPath.append(index)
            }
            viewModel.expandedSectionHeaderNumber = section
            categoryList.beginUpdates()
            categoryList.insertRows(at: indexesPath, with: UITableView.RowAnimation.fade)
            categoryList.endUpdates()
        }
    }
    
}
