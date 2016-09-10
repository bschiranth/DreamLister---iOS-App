//
//  MaterialView.swift
//  DreamLister
//
//  Created by Chiranth Bangalore Sathyaprakash on 9/2/16.
//  Copyright © 2016 Chiranth Bangalore Sathyaprakash. All rights reserved.
//

import UIKit

private var materialKey = false // if true user attribute else default

extension UIView {

    
    
    // gives the option for user defined attribute
    @IBInspectable var materialDesign: Bool{
        get{
            return materialKey
        }set{
            materialKey = newValue
            
            if materialKey {
                
                self.layer.masksToBounds = false
                self.layer.shadowRadius = 3.0
                self.layer.cornerRadius = 3.0
                self.layer.shadowOpacity = 0.8
                self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
                self.layer.shadowColor = UIColor(red: 157/255, green: 157/255, blue: 157/255, alpha: 1.0).cgColor
                
            }else{
            //default here
                
                self.layer.shadowRadius = 0
                self.layer.cornerRadius = 0
                self.layer.shadowOpacity = 0
                self.layer.shadowColor = nil
            }
        }
    }
}
