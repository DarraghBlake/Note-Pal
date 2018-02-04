//
//  TaskController.swift
//  Note Pal
//
//  Created by Darragh on 2/3/18.
//  Copyright © 2018 Darragh. All rights reserved.
//

import UIKit
import CoreData

class TaskController: UITableViewController, CreateTaskControllerDelegate {
    
    var category: Category?
    var tasks = [Task]()
    let cellId = "cellId"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = category?.name
    }
    
    private func fetchTasks() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let request = NSFetchRequest<Task>(entityName: "Task")
        do {
            let tasks = try context.fetch(request)
            self.tasks = tasks
        } catch let err {
            print("Failed to fetch tasks:", err)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let task = tasks[indexPath.row]
        cell.textLabel?.text = task.name
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        fetchTasks()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        setupPlusButtonInNavBar(selector: #selector(handleAdd))
    }
    
    func didAddTask(task: Task) {
        tasks.append(task)
        tableView.reloadData()
    }
    
    @objc private func handleAdd() {
        let createTaskController = CreateTaskController()
        createTaskController.delegate = self
        let navController = CustomNavigationController(rootViewController: createTaskController)
        present(navController, animated: true, completion: nil)
    }
    
}