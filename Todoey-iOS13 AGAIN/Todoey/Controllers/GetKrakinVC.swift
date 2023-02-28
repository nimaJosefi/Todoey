// this VC has all our delegate functionality
//  ViewController.swift

// note that '.defaults' has a shared component making it a singleton
// let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")

import UIKit
import CoreData

class GetKrakinVC: UITableViewController {
    // finally understood why 'global'/often recurring properties are listed here
    
    var itemArray = [Item]() // notice the constructor here links Item as part of coreData class
    
    var selectedCategory: Category? {
        didSet {
          // this will trigger as soon as selectedCategory gets set with a value
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext // brought this constant up here bc both addButtonTap and saveItems() use 'context'
    
    // how can we assign check/uncheck property to data instead of cell (which is 'reusable')? first ask: where does this occur? -> 'cellForRowAt'; second: what is at our disposal? do we need to create our own custom dataType to have particular properties? -> notice that as soon as we made our (custom) Item datatype, userDefaults became immediately out of the question
    
    // let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // searchBar.delegate = self -> avoided doing this by manually linking on Main.storyboard
        
        // loadItems() moved to selectedCategory 
        
    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        // Configure the cell’s contents.
        cell.textLabel!.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        context.delete(itemArray[indexPath.row]) // we must commit first then remove to stay w/i index range
//        itemArray.remove(at: indexPath.row)
        
        // make the opposite; what is the value of done property/attribute after we tap
        //itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems() // commit change to done, delete and create values
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonTap(_ sender: UIBarButtonItem) {
        
        // create popup alert
        let alert = UIAlertController(title: "Enter Task", message: "", preferredStyle: .alert)
        
        // local variable to represent what's typed into 'alert'
        var textField = UITextField()
        
        // this is title we get when done typing our task
        let action = UIAlertAction(title: "Add Task", style: .default) { action in
            
            let newItem = Item(context: self.context) // reps a 'row' therefore NSManagedObject
            newItem.title = textField.text! // reps a field in table
            newItem.done = false            // reps a field in table
            // now we need to specify its parentCategory
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
            // encode our data (itemArray) to custom plist
            self.saveItems()
        }
        
        // add textfield
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new task"
            textField = alertTextField // this can be done bc: let alertTextField: UITextField
            
        }
        
        // cryptic, but okay
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Model Manipulation Methods
    
    func saveItems() {
        
        do {
            try context.save() // same as AppDel and this then commits context to persistent container
        } catch {
            print("Failure to save context walla: \(error.localizedDescription)")
        }
        
        tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) { // this is an example of READ, therefore a save() isn't applicable
        // let request : NSFetchRequest<Item> = Item.fetchRequest() // here we are fetching from container; broadly; not sure how Item can have a property of fetchRequest.. notice the ability to code this out bc its been placed as a parameter input
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request) // need to go through context first; made equal to itemArray bc its what we use to load our data source and 'request' is the ultimate goal/destination
        } catch {
            print("Error fetching data using context walla: \(error.localizedDescription)")
        }
        
        tableView.reloadData()
        
    }
}
   
    //MARK: - SearchBar Methods

extension GetKrakinVC: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // upon tap of search bar, we want to initiate query into our container by way of requesting to context
        let request : NSFetchRequest<Item> = Item.fetchRequest() // broad request
        
        // print(searchBar.text!) // assumption check
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!) // specifies how we want to query our database
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
        // so is it the reason we can't simply call loadItems() here, that we've declare specific requests (i.e predicate and sortDescriptors) and we want those to signify 'request' in this case?
        
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == "" {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
            
            
        }
   
    }
    
}


