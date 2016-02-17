//
//  ConsultaPredialViewController.swift
//  Culiacan
//
//  Created by Armando Trujillo on 17/12/14.
//  Copyright (c) 2014 RedRabbit. All rights reserved.
//

import UIKit

class ConsultaPredialViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var lblMUN: UITextField!
    @IBOutlet weak var lblPOB: UITextField!
    @IBOutlet weak var lblCUA: UITextField!
    @IBOutlet weak var lblMAN: UITextField!
    @IBOutlet weak var lblPRE: UITextField!
    @IBOutlet weak var lblUNI: UITextField!
    @IBOutlet weak var btnBuscar: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnBuscar.layer.cornerRadius = 7
        
        self.lblMUN.text = "07"
        self.lblPOB.text = "000"
        self.lblCUA.text = "015"
        self.lblMAN.text = "005"
        self.lblPRE.text = "004"
        self.lblUNI.text = "001"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "pushDetPredial" {
            let DetPredialVC:DetPredialViewController = segue.destinationViewController as! DetPredialViewController
            DetPredialVC.id_predial = lblMUN.text + lblPOB.text + lblCUA.text + lblMAN.text + lblPRE.text + lblUNI.text
        }
    }
    
    @IBAction func unWind(Segue: UIStoryboardSegue){
        
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if string == "" {
            return true
        }else if textField == lblMUN {
            if range.location == 1 {
                textField.text = textField.text + string
                lblPOB.becomeFirstResponder()
                return false
            } else if range.location > 2{
               return false
            }
        }else if textField == lblPOB {
            if range.location == 2 {
                textField.text = textField.text + string
                lblCUA.becomeFirstResponder()
                return false
            } else if range.location > 2{
                return false
            }
        }else if textField == lblCUA {
            if range.location == 2 {
                textField.text = textField.text + string
                lblMAN.becomeFirstResponder()
                return false
            } else if range.location > 2{
                return false
            }
        }else if textField == lblMAN {
            if range.location == 2 {
                textField.text = textField.text + string
                lblPRE.becomeFirstResponder()
                return false
            } else if range.location > 2{
                return false
            }
        }else if textField == lblPRE {
            if range.location == 2 {
                textField.text = textField.text + string
                lblUNI.becomeFirstResponder()
                return false
            } else if range.location > 2{
                return false
            }
        }
        else if textField == lblUNI {
            if range.location == 2 {
                textField.text = textField.text + string
                textField.resignFirstResponder()
                self.view.endEditing(true)
                return false
            } else if range.location > 2{
                return false
            }
        }
        return true
    }
    
    // MARK: - IBActios Buttons
    @IBAction func actionShowDetalle(sender: AnyObject) {
        

        if lblMUN.text == "" ||  lblPOB.text == "" ||  lblCUA.text == "" ||  lblMAN.text == "" ||  lblPRE.text == "" ||  lblUNI.text == "" {
            UIAlertView(title: "Advertencia", message: "Falta Capturar Clave", delegate: nil, cancelButtonTitle: "Aceptar").show()
            return
        }
        
        self.view.endEditing(true)
        self.performSegueWithIdentifier("pushDetPredial", sender: self)
    }
    
    @IBAction func actionShowMenu(sender: AnyObject) {
        toggleSideMenuView()
    }
    
    // MARK: - IBActions Tap
    @IBAction func actionTapHideKeyBoard(sender: AnyObject) {
        self.view.endEditing(true)
    }
}
