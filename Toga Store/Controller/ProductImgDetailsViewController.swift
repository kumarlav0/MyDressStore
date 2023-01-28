//
//  ProductImgDetailsVC.swift
//
//  Kumar Lav on 27/01/23.
//

import UIKit
import Kingfisher

class ProductImgDetailsViewController: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var imgScrollView: UIScrollView!
    @IBOutlet weak var cropButton: UIButton!
    @IBOutlet var cropAreaView: CropAreaView!
    var productData:ProductModel?
    
     // MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        setData()
        // Do any additional setup after loading the view.
        cropButton.layer.cornerRadius = cropButton.frame.height / 2
        cropAreaView.isHidden = true
    }
    
    var cropArea: CGRect {
          get {
              let factor = imgView.image!.size.width/view.frame.width
              let scale = 1/imgScrollView.zoomScale
              let imageFrame = imgView.imageFrame()
              let x = (imgScrollView.contentOffset.x + cropAreaView.frame.origin.x - imageFrame.origin.x) * scale * factor
              let y = (imgScrollView.contentOffset.y + cropAreaView.frame.origin.y - imageFrame.origin.y) * scale * factor
              let width = cropAreaView.frame.size.width * scale * factor
              let height = cropAreaView.frame.size.height * scale * factor
              return CGRect(x: x, y: y, width: width, height: height)
          }
      }
    
    
    
    // MARK:- Go back Action
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
      }
    
    @IBAction func cropAction(_ sender: UIButton) {
        if sender.isSelected {
           cropButton.setTitle("Crop", for: .normal)
            sender.isSelected = false
            cropAreaView.isHidden = true
             crop()
        } else {
            cropButton.setTitle("Done", for: .normal)
            sender.isSelected = true
            cropAreaView.isHidden = false
        }
        
    }
    
    
    func setData() {
        guard let productData = productData else {
            imgView.image = #imageLiteral(resourceName: "jacket")
            return
        }
        imgView.setImage(urlStr: productData.productImg)
    }
    
}


// MARK:- UIScrollViewDelegate
extension ProductImgDetailsViewController: UIScrollViewDelegate{
    
    // MARK:- setupScrollView method
    func setupScrollView()
    {
               imgScrollView.delegate = self
               imgScrollView.minimumZoomScale = 1.0
               imgScrollView.maximumZoomScale = 10.0
               let dualTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapScrollView))
               dualTap.numberOfTapsRequired = 2
               imgView.isUserInteractionEnabled = true
               imgView.addGestureRecognizer(dualTap)
    }

     // MARK:- doubleTap Handler method
    @objc func handleDoubleTapScrollView(recognizer: UITapGestureRecognizer) {
            if imgScrollView.zoomScale == 1 {
                imgScrollView.zoom(to: zoomRectForScale(scale: 3.0, center: recognizer.location(in: recognizer.view)), animated: true)
            }
            else {
                imgScrollView.setZoomScale(1, animated: true)
            }
        }
    
    func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
             var zoomRect = CGRect.zero
             zoomRect.size.height = imgView.frame.size.height / scale
             zoomRect.size.width  = imgView.frame.size.width  / scale
             let newCenter = imgView.convert(center, from: imgScrollView)
             zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
             zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
             return zoomRect
         }
         
    
    // MARK:- UIScrollViewDelegate Mathods
         func viewForZooming(in scrollView: UIScrollView) -> UIView? {
             return imgView
         }
         
         func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
             return self.imgView
         }
    
}


extension ProductImgDetailsViewController{
    
    func crop() {
         let croppedCGImage = imgView.image?.cgImage?.cropping(to: cropArea)
               let croppedImage = UIImage(cgImage: croppedCGImage!)
               imgView.image = croppedImage
               imgScrollView.zoomScale = 1
    }
    
}

extension UIImageView{
    func imageFrame()->CGRect{
        let imageViewSize = self.frame.size
        guard let imageSize = self.image?.size else{return CGRect.zero}
        let imageRatio = imageSize.width / imageSize.height
        let imageViewRatio = imageViewSize.width / imageViewSize.height
        
        if imageRatio < imageViewRatio {
            let scaleFactor = imageViewSize.height / imageSize.height
            let width = imageSize.width * scaleFactor
            let topLeftX = (imageViewSize.width - width) * 0.5
            return CGRect(x: topLeftX, y: 0, width: width, height: imageViewSize.height)
        }else{
            let scalFactor = imageViewSize.width / imageSize.width
            let height = imageSize.height * scalFactor
            let topLeftY = (imageViewSize.height - height) * 0.5
            return CGRect(x: 0, y: topLeftY, width: imageViewSize.width, height: height)
        }
    }
}

class CropAreaView: UIView {
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return false
    }
    
}
