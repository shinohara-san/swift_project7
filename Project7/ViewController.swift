//
//  ViewController.swift
//  Project7
//
//  Created by Yuki Shinohara on 2020/05/23.
//  Copyright © 2020 Yuki Shinohara. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // let urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(popupTextField))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(showAlert))
        
        
        let urlString: String

        if navigationController?.tabBarItem.tag == 0 {
            // urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            // urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }

        showError()
        
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()

        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            //Data型のjsonをPetitions型にデコードせよ
            //asking it to convert our json data into a Petitions object
            //Petitions type itself
            petitions = jsonPetitions.results
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//        if filteredPetitions != nil{
//            return
//        }
        let petition = petitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body //table view cell subtitleの小さい方のテキスト
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row] //DetailViewControllerのdetailItemという変数に代入
        navigationController?.pushViewController(vc, animated: true) //画面遷移
    }
    
    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @objc func showAlert() {
        let ac = UIAlertController(title: "Attention", message: "The data comes from the We The People API of the Whitehouse.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @objc func popupTextField() {
        let ac = UIAlertController(title: "Enter sort key", message: nil, preferredStyle: .alert)
        ac.addTextField() //アラートに入力フォーム
        
        let submitAction = UIAlertAction(title: "Sort", style: .default) { [weak self, weak ac] action in
            guard let key = ac?.textFields?[0].text else { return }
            self?.sort(key: key)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func sort(key: String){
        petitions = petitions.filter { $0.title.lowercased().contains(key) }
        tableView.reloadData()
    }
}

