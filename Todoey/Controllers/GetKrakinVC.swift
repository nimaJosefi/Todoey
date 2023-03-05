
import UIKit
import RealmSwift

class GetKrakinVC: UITableViewController {
    
    var todoItems: Results<Item>? // formally 'itemArray', changed as no longer an array as per realm
    
    lazy var realm:Realm = {
        return try! Realm()
    }()
    // let realm = try! Realm()
    
    var selectedCategory: Category? { // able to load particular items when category is selected
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] { // if item is !nil therefore be able to change title and done/not done properties
            cell.textLabel!.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items added"
        }
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                
                try realm.write({ // try to update and delete using realm
                //realm.delete(item) >> if we want to add delete,
                    item.done = !item.done
                })
            } catch {
                print("Error saving done status walla: \(error)")
            }
            
        }
        tableView.reloadData() // to show done status immediately on screen
        
        tableView.deselectRow(at: indexPath, animated: true) // so highlight of row is not permanent
        
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonTap(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Enter Task", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Task", style: .default) { action in
            
            if let currentCat = self.selectedCategory { // ability to add item to optional category (if)
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date() // this means every created date gets "stamped" with current date/time
                        currentCat.items.append(newItem)
                    }
                } catch {
                    print("Error saving new items walla: \(error)")
                }
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new task"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Model Manipulation Methods
    
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
      //todoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true) >> if we want to sequence according to 'point in time' created
        
        tableView.reloadData() // which specifies we should have as many cells as we have 'todoItems' for our current selected category
        
    }
    
}

//MARK: - SearchBar Methods

extension GetKrakinVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
        
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

