//
//  ItemCell.swift
//  DreamLister
//
//  Created by Chiranth Bangalore Sathyaprakash on 9/2/16.
//  Copyright © 2016 Chiranth Bangalore Sathyaprakash. All rights reserved.
//

import UIKit

//class for each item in table view row
class ItemCell: UITableViewCell {

    @IBOutlet weak var thumbnail: UIImageView!

    @IBOutlet weak var title: UILabel!

    @IBOutlet weak var price: UILabel!
   
    
    @IBOutlet weak var details: UILabel!

    // pass the details froom item object onto the UI labels 
    // recives item from MainVC's configureCell func
    func configureCell(item:Item) {
    
        title.text = item.title
        price.text = "$\(item.price)" // since we need $ sign we use String Interpolation
        details.text = item.details
        thumbnail.image = item.toImage?.image as? UIImage
    }
}
