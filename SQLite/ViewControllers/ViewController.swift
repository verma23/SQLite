//
//  ViewController.swift
//  SQLite
//
//  Created by Shivanshu Verma on 2022-03-08.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate{
    @IBOutlet var lblTable : UILabel!
    @IBOutlet var lblPicker : UILabel!
    @IBOutlet var tfName : UITextField!
    @IBOutlet var tfEmail : UITextField!
    @IBOutlet var tfFood : UITextField!
    
    @IBAction func addPerson(sender: Any)
    {
        let person : Data = Data.init()
        person.initWithData(theRow: 0, theName: tfName.text!, theEmail: tfEmail.text!, theFood: tfFood.text!)
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        let returnCode = mainDelegate.insertIntoDatabase(person: person)
        var reutrnMSG : String = "Person Added"
        if returnCode == false{
            reutrnMSG = "Person Add Failed"
        }
        
        let alertController = UIAlertController(title: "SQlite Add", message: reutrnMSG, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch : UITouch = touches.first!
        let touchPoint : CGPoint = touch.location(in: self.view!)
        let tableFrame : CGRect = lblTable.frame
        let PickerFrame : CGRect = lblPicker.frame
        if tableFrame.contains(touchPoint)
        {
            performSegue(withIdentifier: "HomeSegueToTable", sender: self)
        }
        if PickerFrame.contains(touchPoint)
        {
            performSegue(withIdentifier: "HomeSegueToPicker", sender: self)
        }
    }
    
    @IBAction func unwindToHomeViewController(segue: UIStoryboardSegue ){
        
        
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

