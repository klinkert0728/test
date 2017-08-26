//
//  RequestVacationViewController.swift
//  test
//
//  Created by Daniel Klinkert Houfer on 8/24/17.
//  Copyright © 2017 Daniel Klinkert Houfer. All rights reserved.
//

import UIKit
import RealmSwift
import RxSwift
import SBPickerSelector
import SVProgressHUD

class RequestVacationViewController: BaseViewController,SBPickerSelectorDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var startDateTextfield: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    @IBOutlet weak var lastVacationTextField: UITextField!
    
    var createClosure:(()->())?
    
    
    var name                    = Variable<String>("")
    var lastVacation            = Variable<String>("")
    var startDate               = Variable<String>("")
    var endDate                 = Variable<String>("")
    
    var disposeBag              = DisposeBag()

    @IBOutlet weak var approveVacation: UIButton!
    
    var reloadClosure:(()->())?
    var request:Request?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        
        
        if !User.isAdmin {
            approveVacation.isHidden = true
        }else {
            navigationItem.rightBarButtonItem = nil
            approveVacation.isHidden = false
            nameTextField.isEnabled = false
        }
        
        
        bindTwo(property:nameTextField.rx.text, variable: name).addDisposableTo(disposeBag)
        bindTwo(property:startDateTextfield.rx.text, variable: startDate).addDisposableTo(disposeBag)
        bindTwo(property:endDateTextField.rx.text, variable: endDate).addDisposableTo(disposeBag)
        bindTwo(property:lastVacationTextField.rx.text, variable:lastVacation).addDisposableTo(disposeBag)
        
        
        guard let request = request else {
            return
        }

        name.value = request.employeeName
        startDateTextfield.text = (request.beginDate as NSDate).formattedDate(withFormat: "dd-MM-yyyy")
        endDateTextField.text   =  (request.endDate as NSDate).formattedDate(withFormat: "dd-MM-yyyy")
        lastVacationTextField.text  = (request.lasVacationOn as NSDate).formattedDate(withFormat: "dd-MM-yyyy")
    }
    
    
    @IBAction func aproveVacationAction(_ sender: Any) {
        guard let current  = request, !current.approved else {
            return
        }
        
        Realm.update { (realm) in
           current.approved = true
        }
        
        reloadClosure?()
        
    }
    @IBAction func pickerStartDate(_ sender: Any) {
        presentPickerFromPicker()
    }
    
    @IBAction func pickerEndDate(_ sender: Any) {
        presentPickerToPicker()
        
    }
    
    
    
    @IBAction func presentPickerLast(_ sender: Any) {
        presentPickerLastVacationsPicker()
    }
    
    
    private func presentPickerFromPicker() {
        
        let picker: SBPickerSelector    = SBPickerSelector()
        picker.delegate                 = self
        picker.pickerType               = SBPickerSelectorType.date
        picker.doneButtonTitle          = "Done"
        picker.cancelButtonTitle        = "Cancel"
        picker.tag                      = 0
        
        picker.pickerType               = SBPickerSelectorType.date //select date(needs implements delegate method with date)
        
        picker.showPickerOver(self) //classic picker display
    }
    
    private func presentPickerToPicker() {
        
        let picker: SBPickerSelector    = SBPickerSelector()
        picker.delegate                 = self
        picker.pickerType               = SBPickerSelectorType.date
        picker.doneButtonTitle          = "Done"
        picker.cancelButtonTitle        = "Cancel"
        picker.tag                      = 1
        
        picker.pickerType               = SBPickerSelectorType.date //select date(needs implements delegate method with date)
        
        picker.showPickerOver(self) //classic picker display
    }
    
    private func presentPickerLastVacationsPicker() {
        
        let picker: SBPickerSelector    = SBPickerSelector()
        picker.delegate                 = self
        picker.pickerType               = SBPickerSelectorType.date
        picker.doneButtonTitle          = "Done"
        picker.cancelButtonTitle        = "Cancel"
        picker.tag                      = 2
        
        picker.pickerType               = SBPickerSelectorType.date //select date(needs implements delegate method with date)
        
        picker.showPickerOver(self) //classic picker display
    }
    
    func pickerSelector(_ selector: SBPickerSelector, dateSelected date: Date) {
        
        if User.isAdmin {
            return
        }
        
        nameTextField.resignFirstResponder()
        if selector.tag == 0 {
            startDate.value  = (date as NSDate).formattedDate(withFormat: "dd-MM-yyyy")
            
        }else if selector.tag == 1 {
            endDate.value = (date as NSDate).formattedDate(withFormat: "dd-MM-yyyy")
        }else {
            lastVacation.value  = (date as NSDate).formattedDate(withFormat: "dd-MM-yyyy")
        }
        
    }

    @IBAction func saveRequest(_ sender: Any) {
        
        if !(name.value.isEmpty && startDate.value.isEmpty && endDate.value.isEmpty && lastVacation.value.isEmpty) {
            Realm.update(updateClosure: { (realm) in
                let activityId = realm.objects(Request.self).count + 1
                let newRequest              =   Request()
                newRequest.activityId       =   "\(activityId)"
                newRequest.predefined       =   false
                newRequest.employeeName     =   self.name.value
                newRequest.requestDate      =   Date()
                newRequest.beginDate        =   NSDate(string: self.startDate.value, formatString: "dd-MM-yyyy") as Date
                newRequest.endDate          =   NSDate(string: self.endDate.value, formatString: "dd-MM-yyyy") as Date
                newRequest.lasVacationOn    =   NSDate(string: self.lastVacation.value, formatString: "dd-MM-yyyy") as Date
                newRequest.process          =   "Vacation"
                newRequest.processId        =   "1"
                
                realm.add(newRequest)
            })
            reloadClosure?()
        }else {
            SVProgressHUD.show(withStatus: "All fields are required to submit a request")
            
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
