
import UIKit

// notice by going straight to "UITableViewController" and having a nav VC we don't need to deal with delegates (i.e FlashChat).. it's happening in background now
class ToDoListVC: UITableViewController {
    
    // how can we get the checkmark functionality to associate with the data not the cell? Remove dequeue?
    
    var itemArray = [Item]()
   
    // below is an example of singleton that always refers to plist (other examples are URLSession and file manager)
//    let defaults = UserDefaults.standard // >>>>>>>>>> deactivate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.title = "First Item"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Second Item"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Third Item"
        itemArray.append(newItem3)
        
        let newItem4 = Item()
        newItem4.title = "Forth Item"
        itemArray.append(newItem4)
        
        // test cell to see if checkmark functionality is as expected
        itemArray.append(newItem4)
        itemArray.append(newItem4)
        itemArray.append(newItem4)
        itemArray.append(newItem4)
        itemArray.append(newItem4)
        itemArray.append(newItem4)
        itemArray.append(newItem4)
        itemArray.append(newItem4)
        itemArray.append(newItem4)
        itemArray.append(newItem4)
        itemArray.append(newItem4)
        itemArray.append(newItem4)
        itemArray.append(newItem4)
        itemArray.append(newItem4)
        itemArray.append(newItem4)
        itemArray.append(newItem4)
        
        // default list items app will remember when user comes back >>>>>>>>>>>>> deactivate
//                if let items = defaults.array(forKey: "TodoListArray") as? [String] {
//                    itemArray = items
//                }
        
    }
    
    //MARK: - Tableview Datasource Methods
    
    // I just want to comment that these two delegate methods for tableview has become more routine (considering as "boiler plate")
    
    // Return the number of rows for the table.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    // Provide a cell object for each row.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        //let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell") >> may not need 
        
        // Configure the cell’s contents..updated to now tapping into title property of Item class
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        // toggle accessory on and off
        if itemArray[indexPath.row].done == true {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        // tableView.reloadData() // i added this from IBbuttonPressed
        
        return cell
    }
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // now lets deal with our 'done' property below (toggling)
        if itemArray[indexPath.row].done == false { // default setting is false
            itemArray[indexPath.row].done = true // meaning we're at this cell..
        } else {
            itemArray[indexPath.row].done = false // we must be at different cell
        }
        
        // 'didSelectRowAt' is asking what you want to happen after selection is made. Compared to 'cellForRowAt' which deals with initial presentation of cell...
        self.tableView.reloadData() // IOW update or iterate through array
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        // have a local variable to represent what's typed into "alert"
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todeoy Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            
            // what will happen once the user clicks the add item button on our UIAlert; we again tap into "title" property of Item class by making "newItem" object and make it refer to what user typed into textField
            let newItem = Item()
            newItem.title = textField.text!
            
            // add this "newItem" to the array of items
            self.itemArray.append(newItem)
            
            //self.itemArray.append(textField.text!) //>>> this was a fair attempt, but notice the resulting error: "No exact matches in call to instance method 'append'" -> I was fixated on the "append" aspect, wondering why I couldn't append to an array (itemArray). Instead the message was asking me to be more specific with WHAT to append ('title' or 'done')..that's why we had to make 'newItem' object to tap into the specific 'title' property of our array.
            
            //self.itemArray[0].title = textField.text! >>>> this is valid code bc it's specific about 'title', but undesirable as changes only occur on top cell ([0])
        
            // we can save what's appended to itemArray
            // self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            // update the UI so something will chose after the action...
            self.tableView.reloadData()
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
}





