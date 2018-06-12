//
//  AddGoalViewController.swift
//  GameOfLife
//
//  Created by Kari Rye Schougaard on 15/08/2017.
//  Copyright © 2017 Prinsisse. All rights reserved.
//

import UIKit
import os.log

class AddGoalViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var goalName: UITextField!
    @IBOutlet weak var activityPicker: UIPickerView!
    @IBOutlet weak var goalImageSelector: UIImageView!
    @IBOutlet weak var pointsToAchieveGoal: UITextField!
    @IBOutlet weak var currentPoints: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    /*
     This value is either passed by `ChoreTableViewController` in `prepare(for:sender:)`
     or constructed as part of adding a new goal.
     */
    var goal: Goal?

    var choreData : ChoreDataController = ChoreDataController.instance
    var goalData : GoalDataController = GoalDataController.instance
    
    var selectedChoreName : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Handle the text field’s user input through delegate callbacks.
        self.activityPicker.delegate = self
        self.activityPicker.dataSource = self
        // Do any additional setup after loading the view.

        // Set up views if editing an existing Goal.
        if let goal = goal {
            navigationItem.title = goal.name
            goalName.text = goal.name
            pointsToAchieveGoal.text = String(goal.pointsToAchieveGoal)
            currentPoints.text = String(goal.currentPoints)
            goalImageSelector.image = goal.photo
        }
        
        // Enable the Save button only if the text field has a valid Chore name.
        updateSaveButtonState()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let name = goalName.text ?? ""
        let photo = goalImageSelector.image
        let pointsToAchieveGoal: Int = Int(self.pointsToAchieveGoal.text ?? "") ?? 0
        
        //FIXME virker kun når man selv har valgt en aktivitet 
        let choreNames = [selectedChoreName ?? ""]
        
        // Set the goal to be passed to ChoreTableViewController after the unwind segue.
        guard let goal : Goal = Goal(name: name, photo: photo, pointsToAchieveGoal: pointsToAchieveGoal, currentPoints: 0, pointGivingChoresArray: choreNames) else {
            os_log("Error creating goal", log: OSLog.default, type: .debug)
            return
        }
        
        self.goal = Goal(name: name, photo: photo, pointsToAchieveGoal: pointsToAchieveGoal, currentPoints: 0, pointGivingChoresArray: choreNames)

    }
    
    //MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }

    //MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        self.goalImageSelector.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }

    
    // MARK: UIPickerViewDataSource
    // returns the number of 'columns' to display.
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    
    // returns the # of rows in each component..
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return choreData.count();
    }
    
    // MARK: UIPickerViewDelegate
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return choreData.get(index: row).name;
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedChoreName = choreData.get(index: row).name
    }
    
    @IBAction func selectImage(_ sender: UITapGestureRecognizer) {
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    //MARK: Actions
    
    //MARK: Private Methods
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = goalName.text ?? ""
        saveButton.isEnabled = !text.isEmpty
        saveButton.isEnabled = true
    }

}
