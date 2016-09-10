//
//  ItemDetailsVC.swift
//  DreamLister
//
//  Created by Chiranth Bangalore Sathyaprakash on 9/6/16.
//  Copyright © 2016 Chiranth Bangalore Sathyaprakash. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate ,
                        UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var storePicker : UIPickerView!
    @IBOutlet weak var titleField : CustomTextField!
    @IBOutlet weak var priceField: CustomTextField!
    @IBOutlet weak var detailsField: CustomTextField!
    
    
    var stores = [Store]()//hold list of stores
    
    var itemToEdit:Item?
    
    var imagePicker:UIImagePickerController!
    
    @IBOutlet weak var thumbImage: UIImageView!
    
    
    
    ////////////////////////////////////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let topItem = self.navigationController?.navigationBar.topItem{
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil) // this will show a plain back button
        }
        
        storePicker.delegate = self
        storePicker.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
     /*
        let store = Store(context: context)
        store.name = "Best Buy"
        
        let store2 = Store(context: context)
        store2.name = "Amazon"
        
        let store3 = Store(context: context)
        store3.name = "E-Bay"
        comment these lines after running once as they are saved in memory
        let store4 = Store(context: context)
        store4.name = "Target"
        
        let store5 = Store(context: context)
        store5.name = "PriceRite"
        
        let store6 = Store(context: context)
        store6.name = "Dollar-Tree"
        
        appDelegate.saveContext()//save in memory after running
   */
        getStores()
        
        if itemToEdit != nil {
            loadItemData()
            
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let store = stores[row]
        return store.name
    }
    
    // number of collums in picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stores.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //TODO: when row selected
    }
    
    func getStores(){
    
        let fetchRequest : NSFetchRequest<Store> = Store.fetchRequest()
        
        do {
            self.stores =  try context.fetch(fetchRequest)
            self.storePicker.reloadAllComponents()
        } catch let error as NSError{
            print(error.localizedDescription)
        }
    }
    ///////when save is pressed ////
    @IBAction func savePressed(_ sender: AnyObject) {
        
       // let item = Item(context: context) // create an object to save
        var item: Item!
        

        
        //if its a new item create a new one else edit existing one
        if itemToEdit == nil {
            item = Item(context: context)
        }else{
            item = itemToEdit
        }
        
        if let title = titleField.text{
            
            item.title = title
        }
        
        if let price = priceField.text{
            item.price = (price as NSString).doubleValue// price is string and item price is double , so cast it
        }
        
        if let details = detailsField.text{
            item.details = details
        }
        
        // create a new image entity
        let picture = Image(context: context)
        picture.image = thumbImage.image
        item.toImage = picture
        
        // get the selected store from pickerview's 0th column which is the only column and save it to item object
        item.toStore = stores[storePicker.selectedRow(inComponent: 0)]
        
        appDelegate.saveContext()
        
        _ = navigationController?.popViewController(animated: true)

    }
    /////////////////////
    func loadItemData(){
        if let item = itemToEdit{
            
            titleField.text = item.title
            priceField.text = String(item.price)
            detailsField.text = item.details
            thumbImage.image = item.toImage?.image as? UIImage
            
            
            if let store = item.toStore{
                var index = 0
                repeat{
                    let s = stores[index]
                    if s.name == store.name{
                        storePicker.selectRow(index, inComponent: 0, animated: false)
                        break
                    }
                    index += 1
                }while index < stores.count
            }
        }
    }
    /////////////////////
    @IBAction func deletePressed(_ sender: UIBarButtonItem) {
        
        if itemToEdit != nil {
            
            context.delete(itemToEdit!)
            appDelegate.saveContext()
            
        }
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    ///////////image picker cliked//////////
    @IBAction func addImage(_ sender: UIButton) {
        
        //presents a picker when clicked
        present(imagePicker, animated: true, completion: nil)
        
    }
    ///// image picker ////
   
    
    //returns a dictionary of chosen images from picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            thumbImage.image = img
        }
        imagePicker.dismiss(animated: true, completion: nil)//dismiss after setting image
    }
    ////////////////////////////
    
    
}
