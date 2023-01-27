//
//  ProductListViewModel.swift
//  Toga Store
//
//  Kumar Lav on 27/01/23.
//

import Foundation

protocol ProductListViewModelDelegate: AnyObject {
    func reloadData()
}

class ProductListViewModel {
    weak var delegate: ProductListViewModelDelegate?
    var categoryArray = [CategoryModel]()
    var isGridView = true

    let kHeaderSectionTag: Int = 6900
    var expandedSectionHeaderNumber: Int = -1
    let imgUrl1 = "https://images.unsplash.com/photo-1576566588028-4147f3842f27?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=764&q=80"
    let imgUrl2 = "https://c.pxhere.com/photos/04/36/suit_man_dapper_work_male_business_person_businessman-868417.jpg!d"
    let imgUrl3 = "https://get.pxhere.com/photo/person-black-and-white-girl-woman-white-portrait-model-young-fashion-clothing-lady-wedding-dress-bride-ballet-eyes-dress-women-skin-attractive-gown-beautiful-woman-photo-shoot-female-face-women-face-formal-wear-bridal-clothing-cocktail-dress-804661.jpg"
    let imgUrl4 = "https://get.pxhere.com/photo/mobile-person-people-girl-woman-white-cute-female-portrait-model-young-spring-green-youth-natural-fresh-fashion-clothing-healthy-wedding-dress-smiling-smile-caucasian-face-eyes-dress-happy-happiness-neck-skin-joy-beautiful-teen-beautiful-women-attractive-gown-adult-beautiful-woman-beauty-girl-woman-smile-royalty-free-sleeve-photo-shoot-beautiful-woman-smiling-woman-smiling-beautiful-smile-smiling-woman-using-mobile-girl-mobile-little-black-dress-supermodel-bridal-clothing-cocktail-dress-487425.jpg"
    let imgUrl5 = "https://images.unsplash.com/photo-1571945153237-4929e783af4a?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80"
    let imgUrl6 = "https://images.unsplash.com/photo-1551799517-eb8f03cb5e6a?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80"
    let imgUrl7 = "https://images.unsplash.com/photo-1592878904946-b3cd8ae243d0?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=881&q=80"
    let imgUrl8 = "https://images.unsplash.com/photo-1608063615781-e2ef8c73d114?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80"
    var imgUrls = [String]()
    let names = ["Jeans Pents", "Jacket", "Denim Dress", "Close wear", "Jasmin Tshirt", "Frock", "Pent", "Lather Jacket"]
    let brand = ["Jack and Jons", "Denim","Gucchy","Rupa","Khadims","Petel England"]
    
    func getAllCategory() {
        imgUrls = [imgUrl1, imgUrl2, imgUrl3, imgUrl4, imgUrl5, imgUrl6, imgUrl7, imgUrl8]
        var productArr = [ProductModel]()
        for _ in 0..<8 {
            let obj = ProductModel(sku: 8675, name: names[Int.random(in: 0...7)], cost: Float.random(in: 1300.5...2785.5), productImg: imgUrls[Int.random(in: 0...7)])
            productArr.append(obj)
        }

        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
            for _ in 0..<5 {
                let catgry = CategoryModel(products: productArr, name: self.brand[Int.random(in: 0...5)])
                self.categoryArray.append(catgry)
            }
            self.delegate?.reloadData()
        }
    }
}
