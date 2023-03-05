
import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    lazy var realm:Realm = {
        return try! Realm()
    }()
    //let realm = try! Realm() -> outdated 
    
    var categories: Results<Category>? // changed from array (coreData) is collection type (realm)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
          loadCats()
    }
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        categories?.count ?? 1 // if categories is not nil, return number of categories. If is nil, then just return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet..."
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { // this is done prior to "performSegue"
        
        let destinationVC = segue.destination as! GetKrakinVC // points to items VC (i.e GetKrakin)
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row] // claiming that certain items belong to selected category 
            
        }
    }
    
    //MARK: - Data Manipulation Methods
    
    func save(category: Category) {
        do {
            try realm.write { // "write {}" allows us to commit changes
                realm.add(category) // this is the change we want to commit (i.e category)
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        
        tableView.reloadData()
    }

    func loadCats() {
        
        categories = realm.objects(Category.self) // look inside realm and fetch all objects that belong to category data type
        
        tableView.reloadData() // which calls all data source methods (i.e tableView delegates)
    }
    
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Create a category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCat = Category()
            newCat.name = textField.text!
            
            self.save(category: newCat)
            
            // am I missing a reload?
            // self.tableView.reloadData()
        }
        
        alert.addAction(action)
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Create your category"
        }
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
}


