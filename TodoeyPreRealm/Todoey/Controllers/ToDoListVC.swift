
import UIKit

// notice by going straight to "UITableViewController" and having a nav VC (Main.swift) we don't need to deal with delegates (i.e FlashChat).. it's happening in background now

class ToDoListVC: UITableViewController {
    
    var itemArray = [Item]()
    
    // below is an example of singleton that always refers to plist (other examples are URLSession and File Manager)
    // let defaults = UserDefaults.standard >> no longer will use, instead we'll create our own storage
    
    // place outside 'viewDidLoad' to make it 'global'; scope throughout and maintain 'addButtonPressed' re-usability (FYI this is where the plist is located in storage)
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
    }
    
    //MARK: - Tableview Datasource Methods
    
    // I just want to comment that these two delegate methods for tableView have become more routine (considering it as "boiler plate")
    
    // Return the number of rows for the table.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    // Provide a cell object whose template will re-generate according to array.count
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        // Configure the cell’s contents..updated to now tapping into title property of Item class
        cell.textLabel?.text = item.title
        
        // let's use ternary operator (effective when requiring a print statement for testing purposes)
        
        // cell.accessoryType = item.done == true ? .checkmark : .none >> the true is inferred, therefore
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        
        //        if item.done == true {
        //            cell.accessoryType = .checkmark
        //        } else {
        //            cell.accessoryType = .none
        //        }
        
        return cell
    }
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 'didSelectRowAt' is asking what you want to happen after selection is made. Compared to 'cellForRowAt' which deals with creation of additional cell based on array's TOTAL count
        
        // ensures cells generate with no checkmark as default..like initializing/defining a variable with a value to start
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        // how do we get below info to reflect in plist? Same URL style process that created and stored our inputed data into plist..update the URL style process has been seen made into a below function
        saveItems()
        
        // de-highlight a selection after tapped? Although doesn't seem to have that effect currently..
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        // have a local variable to represent what's typed into 'alert'
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add An Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            
            // what will happen once the user clicks the add item button on our UIAlert; we again tap into 'title' property of Item class by making 'newItem' object and make it refer to what user typed into textField
            let newItem = Item()
            newItem.title = textField.text!
            // userDefaults take only standard datatypes, not custom ones (has to do with storage conservation); [We want to simply tap into testField and just extract its data not UI component]; Solution to this ultimately, is find a different way of storing data (->File Manager)
            
            // add this "newItem" to the array of items
            self.itemArray.append(newItem)
            
            //self.itemArray.append(textField.text!) //>>> this was a fair attempt, but notice the resulting error: "No exact matches in call to instance method 'append'" -> I was fixated on the "append" aspect, wondering why I couldn't append to an array (itemArray). Instead the message was asking me to be more specific with WHAT to append ('title' or 'done')..that's why we had to make 'newItem' object to tap into the specific 'title' property of our array
            
            //self.itemArray[0].title = textField.text! >>> this is valid code bc it's specific about 'title', but undesirable effect as changes only occur on top cell ([0])
            
            // let's refer to the function that will create an encoder object and make plist file in directory (to also include checkmark acknowledgment)
            self.saveItems() // both their title and checkmark (if tapped); also reload the table after adding and/or checking
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Model Manipulation Methods
    
    // the reason we're creating this retrieval method is because it occurs more than once: when we tap (+) on UI to add new list item; and whether we tap for a completion checkmark (as default is set to false)
    
    func saveItems() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray) //>>> imagine just data = encoder.>>>tap into it's properties
            // now let's write the data to our file path which can also 'throw'
            try data.write(to: dataFilePath!) // can force it bc we have to 'catch' anyway
        } catch {
            print("Error encoding item array: \(error.localizedDescription)")
        }
        
        // quick note that '.self' for itemArray and dataFilePath were removed here as they're no longer in a closure (instead in a function that exists in our ToDoListVC class)
        
        // update the iterate through item array
        tableView.reloadData()
        
        // note on architecture of this function: no parameters or returns, so simply gets triggered at certain instance and performs duty of encoding
        
    }
    
    // loadItems now decodes from plist and transmits to UI at startup (viewDidLoad)
    func loadItems() {
        let decoder = PropertyListDecoder()
        
        if let data = try? Data(contentsOf: dataFilePath!) {
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("self.Unsuccessful loading items: \(error.localizedDescription)")
            }
        }
        
    }
    
    
    
}

// original hardcoded list items for experimentation below
//let newItem = Item()
//newItem.title = "Example item"
//itemArray.append(newItem)



