//  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//  CategoryViewController.swift
//  Todoey
//
//  Created by saloni on 24/02/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categories = [Category]()
    
    // ask yourself what we're trying to tap into and why? more importantly what mechanism allows us to point to common class; communicate with persistent container
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // added this, don't know if it's Angela's or google
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CategoryCell")
        
        loadCats()
    }
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a reusable cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        // define cell contents using textLabel and NSManagedObject
        cell.textLabel?.text = categories[indexPath.row].name
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    // decide what happens when you select a row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    // perform some prep before next VC (items) can display
    // this will be triggered before above 'performSegue'
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // store a reference to destination VC
        let destinationVC = segue.destination as! GetKrakinVC
        
        // grab the category that corresponds to selected cell, therefore first we need to determine what is the selected cell
        //although below 'indexPath' is optional, we are sure it won't be nil bc there needs to be a created category first (therefore contain value), in order to select it.. but just in case we'll wrap in an 'if let'
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
            // in order to have 'selectedCategory' property, we need to create this in GetKrakinVC as a var; and we can do this bc 'destinationVC' has been casted as GetKrakinVc
            
        }
    }
    
    
    
    
    
    
    //MARK: - Data Manipulation Methods
    
    // commit category changes to CONTEXT and reload data to UI -> context.save()
    func saveCat() {
        do {
            try context.save()
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        
        tableView.reloadData()
    }
    
    func loadCats() {
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do {
            // need to READ data from context/persistent container
            categories = try context.fetch(request)
        } catch {
            print("Error fetching data using context walla: \(error.localizedDescription)")
        }
        
        tableView.reloadData()
    }
    
    
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        // alert controller
        let alert = UIAlertController(title: "Create a category", message: "", preferredStyle: .alert)
        
        // text/title
        var textField = UITextField()
        
        // action to then access how to deal with 'action' in handler
        let action = UIAlertAction(title: "Add my category", style: .default) { (action) in
            
            // we want to add the text typed to the list
            // first define what is the text typed: NSManagedObject; IOW we want to access Entity to do something with its attribute
            let newCat = Category(context: self.context)
            newCat.name = textField.text
            
            // append to array to display as category list
            self.categories.append(newCat)
            
            // commit created category
            self.saveCat()
        }
        
        // addAction
        alert.addAction(action)
        
        // add textField alert
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Create your category"
        }
        
        // present
        self.present(alert, animated: true, completion: nil)
        
        
    } // end of IBAction
    
    
    
}


