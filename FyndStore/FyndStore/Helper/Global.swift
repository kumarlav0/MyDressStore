//
//  Global.swift
//  APIHandler
//
//  Created by Kumar Lav on 12/23/19.
//  Copyright © 2019 Kumar Lav. All rights reserved.
//

import Foundation
import SystemConfiguration
import MBProgressHUD


class Global: NSObject {

class var sharedInstance: Global {
    struct Static {
        static let instance: Global = Global()
    }
    return Static.instance
}

    
    //MARK: - Internet Connection Checking Methods
       
       class func isInternetAvailable() -> Bool {
           
           var zeroAddress = sockaddr_in()
           zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
           zeroAddress.sin_family = sa_family_t(AF_INET)
           
           guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
               $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                   SCNetworkReachabilityCreateWithAddress(nil, $0)
               }
           }) else {
               return false
           }
           
           var flags: SCNetworkReachabilityFlags = []
           if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
               return false
           }
           
           let isReachable = flags.contains(.reachable)
           let needsConnection = flags.contains(.connectionRequired)
           
           return (isReachable && !needsConnection)
       }
    
    
    //MARK: - Global alert Methods
       
       static func showAlertMessageWithOkButtonAndTitle(_ strTitle: String, andMessage strMessage: String)
       {
           if objc_getClass("UIAlertController") == nil
           {
            print("if objc_getClass:::::::::::")
               let alert: UIAlertView = UIAlertView(title: strTitle, message: strMessage, delegate: nil, cancelButtonTitle: "OK", otherButtonTitles: "")
               alert.show()
               
           }
           else
           {
             
            let alertController: UIAlertController = UIAlertController(title:strTitle, message: strMessage, preferredStyle: UIAlertController.Style.alert)
               print(" else objc_getClass:::::::::::",strTitle,strMessage)
               let ok: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
               alertController.addAction(ok)
               
               let topWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
               topWindow.rootViewController = UIViewController()
               topWindow.windowLevel = UIWindow.Level.alert
               topWindow.makeKeyAndVisible()
               topWindow.rootViewController!.present(alertController, animated: true, completion: {
                   
               })
           }
       }
    

    
    
    //MARK: Show Progresshud on the middle when API calls
    class func showGlobalProgressHUD(withTitle title: String) -> MBProgressHUD {
           let window: UIWindow? = UIApplication.shared.windows.last
           MBProgressHUD.hide(for: window!, animated: true)
           let hud = MBProgressHUD.showAdded(to: window!, animated: true)
           hud.mode = .indeterminate
           hud.backgroundView.color = UIColor(white: 0, alpha: 0.3)
           hud.backgroundView.style = MBProgressHUDBackgroundStyle.solidColor
           hud.label.text = title
           return hud
       }
    
    
    // Dissmiss Progresshud
    class func dismissGlobalHUD() {
        let window: UIWindow? = UIApplication.shared.windows.last
        MBProgressHUD.hide(for: window!, animated: true)
    }
    
    

   
    
    /// Trim for String
       static func Trim(_ value: String) -> String {
           let value = value.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
           return value
       }
    
    
    // checks whether string value exists or it contains null or null in string
      static func stringExists(_ str: String) -> Bool {
          var strString : String? = str
          
          if strString == nil {
              return false
          }
          
          if strString == String(describing: NSNull()) {
              return false
          }
          if (strString == "<null>") {
              return false
          }
          if (strString == "(null)") {
              return false
          }
          strString = Global.Trim(str)
          if (str == "") {
              return false
          }
          if strString?.count == 0 {
              return false
          }
          return true
      }
      
      // returns string value after removing null and unwanted characters
      
      static func getStringValue(_ str: AnyObject) -> String {
          if str is NSNull {
              return ""
          }
          else{
            
              var strString : String? = str as? String
              if Global.stringExists(strString!) {
                  strString = strString!.replacingOccurrences(of: "\t", with: " ")
                  strString = Global.Trim(strString!)
                  if (strString == "{}") {
                      strString = ""
                  }
                  if (strString == "()") {
                      strString = ""
                  }
                  if (strString == "null") {
                      strString = ""
                  }
                  return strString!
              }
              return ""
          }
      }
    
  class func uniqueId() -> String {
         return  UUID().uuidString
     }
    
  
    
    static let productImg = ["http://pngimg.com/uploads/jacket/jacket_PNG8050.png","http://pngimg.com/uploads/jacket/jacket_PNG8026.png","http://pngimg.com/uploads/suit/suit_PNG8127.png","http://pngimg.com/uploads/dress_shirt/dress_shirt_PNG8080.png"]
    
    //   http://pngimg.com/uploads/dress_shirt/dress_shirt_PNG8108.png
    
}  // End of Global
