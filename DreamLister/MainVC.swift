//
//  MainVC.swift
//  DreamLister
//
//  Created by Chiranth Bangalore Sathyaprakash on 8/28/16.
//  Copyright © 2016 Chiranth Bangalore Sathyaprakash. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    var controller: NSFetchedResultsController<Item>! // fetches item entities
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var segment: UISegmentedControl! // three segments - date , price, title
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        // delegate and data source
        tableView.dataSource = self
        tableView.delegate = self
        
        generateTestData() // call the test data function
        
        attemptFetch() // need to call this as it sets self.controller's value with context and fetch request
        
    }

    //returns tableview cell at that index
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
            configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        
        return cell
    }

    /////
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let objs = controller.fetchedObjects, objs.count > 0 {
            let item  = objs[indexPath.row]
            performSegue(withIdentifier: "ItemDetailsVC", sender: item)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ItemDetailsVC"{
            if let destination = segue.destination as? ItemDetailsVC{
                if let item = sender as? Item{
                    destination.itemToEdit = item // assign sender Item to destination Item
                }
            }
        }
    }
    ////////
    
    func configureCell(cell:ItemCell, indexPath:NSIndexPath) {
        // indexPath is the path to specific node in array of tree of nodes
       
        //returns the object at that index path
        let item = controller.object(at: indexPath as IndexPath)
        
        // this item will be passed to the configureCell() function in the ItemCell Class as cell is of type ItemCell
        cell.configureCell(item: item)
    }
    
    // returns the number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let sections = controller.sections {
            
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects // returns number of objects in that row
        }
        
        return 0 // if there are no rows then return 0
    }
    
    // returns the number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if let sections = controller.sections {
            return sections.count // returns
        }
        
        return 0
    }
    
    // This function fixes row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    // function to fetch data
    func attemptFetch(){
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        let dateSort = NSSortDescriptor(key: "created", ascending: false)
        fetchRequest.sortDescriptors = [dateSort] //sort items by date created
        let priceSort = NSSortDescriptor(key: "price", ascending: true)// sort by price
        let titleSort = NSSortDescriptor(key: "title", ascending: true) // sort by title
        
        // sort according to segments
        if segment.selectedSegmentIndex == 0 {
            fetchRequest.sortDescriptors = [dateSort]
        }else if segment.selectedSegmentIndex == 1{
            fetchRequest.sortDescriptors = [priceSort]
        }else if segment.selectedSegmentIndex == 2{
            fetchRequest.sortDescriptors = [titleSort]
        }
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        
        controller.delegate = self // update controlle after saving item
        self.controller = controller // reassign controller after getting its context and fetch request
        //perform fetch needs to be in do catch as it may fail
        do {
            try controller.performFetch()
        } catch {
            let err = error as NSError
            print("The fetch error is : \(err)")
        }
        
    }
    // end of attemptFetch
    
    ///////
    @IBAction func segmentChanged(_ sender: AnyObject) {
        
        attemptFetch() // everytime segment is changed fetch data from our attemptFetch() function
        tableView.reloadData() // then reload data - inbuilt function
        
    }
    
    ///////
    
    
    //updates the tableview everytime content is changed
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    // ends the updates
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    //Notifies the receiver that a fetched object has been changed due to an add, remove, move, or update.
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        // type - maybe insert , delete,move, update,
        
        switch type {
        case.insert:
            // inserts new item at that index when we add
            if let indexPath = newIndexPath{
                tableView.insertRows(at: [indexPath], with: .left) // animation from left
            }
            break
        case.delete:
            //not new indexpath becuase we are deleting existing one
            if let indexPath = indexPath{
                tableView.deleteRows(at: [indexPath], with: .left)
            }
            break
        case.update:
            if let indexPath = indexPath{
                let cell = tableView.cellForRow(at: indexPath) as! ItemCell
                configureCell(cell: cell, indexPath: indexPath as NSIndexPath) //update UI labels on each update
            }
                break
               
        case.move:
            if let indexPath = indexPath{
                tableView.deleteRows(at: [indexPath], with: .left)
            }
            if let indexPath = newIndexPath{
                tableView.insertRows(at: [indexPath], with: .fade)
            }
                break
        default:
            //show error alert
            let alertController = UIAlertController(title: "Item error:", message: "Something went wrong when adding your item. Please try again later", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Close Alert", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            break
        }
        /////////////////// end of switch case/////////////////////
    }
    
    // function to test app by filling in test data
    func generateTestData()  {
     /*
        let item = Item(context: context)
        item.title = "Macbook Pro 2016"
        item.price = 1500
        item.details = "Retina Display, Intel i5, 8GB RAM, 256Gb SSD"

        let item2 = Item(context: context)
        item2.title = "Bose Headphones "
        item2.price = 450
        item2.details = "The best audio quality you will ever hear. Only for audiophiles"
        
        let item3 = Item(context: context)
        item3.title = "Tesla Model S"
        item3.price = 15000
        item3.details = "The best electric car of this generation now with autodriving feature"
        
        
        appDelegate.saveContext() // save the data generated in memory
 */
    }
}

