//
//  ViewController.swift
//  Mind Map
//
//  Created by Denys Denysenko on 07.11.2021.
//

import UIKit

class ViewController: UITableViewController {
    
    var minds = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
       
        title = "Your Minds"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New Document", style: .plain, target: self, action: #selector(addFile))
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return minds.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.textLabel?.text = minds[indexPath.row]
        return cell!
        
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.mainIdeaLabelText = minds[indexPath.row]
            
            
            self.navigationController?.pushViewController(vc, animated: true)
    }
    }
    @objc func addFile () {
        
        let ac = UIAlertController(title: "Add new mind map", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        ac.addAction(UIAlertAction(title: "Add", style: .default, handler:{
            [weak self, weak ac] action in
            let text = ac?.textFields![0].text
            if text!.isEmpty {
                self!.alertIfDocumentNameIsEmpty()
            }else {
            self!.minds.append(text!)
                }
                self!.tableView.reloadData()
            if let vc = self!.storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
                vc.mainIdeaLabelText = text!
                
                
                self!.navigationController?.pushViewController(vc, animated: true)
            }
        }))
        present(ac, animated: true)
        
    }
    
    func alertIfDocumentNameIsEmpty () {
        var ac = UIAlertController(title: "Name is empty", message: "Can't create file without name", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true)
    }
    }




