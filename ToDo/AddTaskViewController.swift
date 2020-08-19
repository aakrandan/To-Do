//
//  AddTaskViewController.swift
//  ToDo
//
//  Created by Ananth  on 16/08/20.
//  Copyright © 2020 Infosys. All rights reserved.
//

import UIKit

class AddTaskViewController: UIViewController, UITextFieldDelegate {
    
    let taskField = UITextField()
    let dateField = UITextField()
    let saveButton = UIButton()
    let datePicker = UIDatePicker()
    
    var updateClosure: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        view.addSubview(taskField)
        view.addSubview(saveButton)
        view.addSubview(dateField)
        
        taskField.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        dateField.translatesAutoresizingMaskIntoConstraints = false
    
        taskField.delegate = self
        taskField.placeholder = "Add Task"
        taskField.borderStyle = .roundedRect
        taskField.tag = 1
        
        dateField.placeholder = "Enter Time"
        dateField.borderStyle = .roundedRect
        dateField.tag = 2
        
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(.green, for: .normal)
        saveButton.addTarget(self, action: #selector(didTapSave), for: .touchUpInside)
        
        //Create datePicker
        createDatePicker()
        
        view.addConstraint(NSLayoutConstraint(item: taskField, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 200))
        view.addConstraint(NSLayoutConstraint(item: taskField, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 20))
        view.addConstraint(NSLayoutConstraint(item: taskField, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: -20))
        view.addConstraint(NSLayoutConstraint(item: taskField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 44))
        
        view.addConstraint(NSLayoutConstraint(item: dateField, attribute: .top, relatedBy: .equal, toItem: taskField, attribute: .bottom, multiplier: 1, constant: 20))
        view.addConstraint(NSLayoutConstraint(item: dateField, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 20))
        view.addConstraint(NSLayoutConstraint(item: dateField, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: -20))
        view.addConstraint(NSLayoutConstraint(item: dateField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 44))
        
        view.addConstraint(NSLayoutConstraint(item: saveButton, attribute: .top, relatedBy: .equal, toItem: dateField, attribute: .bottom, multiplier: 1, constant: 20))
        view.addConstraint(NSLayoutConstraint(item: saveButton, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 20))
        view.addConstraint(NSLayoutConstraint(item: saveButton, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: -20))
        
    }
    
    func createDatePicker() {
        datePicker.datePickerMode = .dateAndTime
        datePicker.timeZone = NSTimeZone.local
        datePicker.backgroundColor = .white
        
        let calendar = Calendar(identifier: .gregorian)
        var comps = DateComponents()

        comps.month = 1
        let maxD = calendar.date(byAdding: comps, to: Date())
        
        comps.month = 0
        comps.day = -1
        let minD = calendar.date(byAdding: comps, to: Date())
        
        datePicker.maximumDate = maxD
        datePicker.minimumDate = minD
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        dateField.inputAccessoryView = toolBar
        dateField.inputView = datePicker
        
        let leftBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: nil)
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tappedDone))
        
        toolBar.setItems([leftBarButton, rightBarButton], animated: true)
    }
    
    
    @objc func tappedDone() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        
        dateField.text = formatter.string(from: datePicker.date)
        
        self.view.endEditing(true)
    }
    
    @objc func tappedCancel() {
        self.view.endEditing(true)
    }
    
    @objc func didTapSave() {
        
        guard let text = taskField.text, !text.isEmpty else {return}
        guard let dateText = dateField.text, !dateText.isEmpty else {return}
        guard let count = UserDefaults().value(forKey: "count") as? Int else {return}
        
        let newCount = count+1
        
        UserDefaults().set(newCount, forKey: "count")
        UserDefaults().set(text, forKey: "task_\(newCount)")
        UserDefaults().set(dateText, forKey: "date_\(newCount)")
        
        updateClosure?()
        navigationController?.popViewController(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        
        if let nextResponder = textField.superview?.viewWithTag(nextTag), nextResponder == dateField {
            print("im here")
            dateField.becomeFirstResponder()
        }
        else {
            print("else part")
            textField.resignFirstResponder()
        }
        
        return true
    }
}

