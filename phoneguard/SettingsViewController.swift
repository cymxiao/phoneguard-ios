//
//  settingsViewController.swift
//  phoneguard
//
//  Created by 蔡亚明 on 2018/7/22.
//  Copyright © 2018年 蔡亚明. All rights reserved.
//

import UIKit

class SettingsViewController: BaseUIViewController, UITextFieldDelegate, UIPickerViewDelegate {
//, UIPickerViewDataSource {
    
    // The number of columns of data
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//       return pickerData.count
//    }
//
//
//    // The data to return for the row and component (column) that's being passed in
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        //return pickerData[row]
//        let pickerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: pickerView.frame.size.width, height: 30))
//        pickerLabel.backgroundColor = UIColor.red
//        pickerLabel.text = pickerData[row]
//        //pickerLabel.textColor = UIColor.red
//        return pickerLabel.text
//
//    }
    
    // Catpure the picker view selection
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        // This method is triggered whenever the user makes a change to the picker selection.
//        // The parameter named row and component represents what was selected.
//        print("Data selected: \(pickerData[row])")
//        //print(pickerData[row]);
//    }
   
    @IBOutlet weak var alertTimeoutText: UITextField!
    @IBOutlet weak var pwdText: UITextField!
    //@IBOutlet weak var saveSettings: UIButton!
    @IBOutlet weak var swhTouchID: UISwitch!
  //  @IBOutlet weak var picker: UIPickerView!
    
  //  var pickerData: [String] = [String]()
    
    @IBAction func saveSettings(_ sender: Any) {
        UserDefaults.standard.set(alertTimeoutText.text, forKey: "timeout")
        UserDefaults.standard.set(pwdText.text, forKey: "pwd")
        UserDefaults.standard.synchronize()
        
        // create the alert
        let alert = UIAlertController(title: "提示", message: "保持成功.", preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        //view.resignFirstResponder()
        view.endEditing(true)
        self.present(alert, animated: true, completion: nil)
        
        //navigationController?.popViewController(animated:true)
        //openSettingsView()
    }
    
    
    @IBAction func touchIDSwitchAction(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "enableTouchID")
    }
    
 
    
    @IBAction func closeKeyBoard(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        alertTimeoutText.delegate = self
        pwdText.delegate = self
        //self.navigationItem.hidesBackButton = true
        //let leftBarBtn = UIBarButtonItem(title: "返回", style: .plain, target: self,  action: #selector(backToPrevious)) 
        //self.navigationItem.leftBarButtonItem = leftBarBtn
        
        //self.navigationController?.setNavigationBarHidden(false,animated: true)
        // Connect data:
//        self.picker.delegate = self
//        self.picker.dataSource = self
//        pickerData = ["蓝色", "红色", "黄色", "黑色（夜晚）"]
        
        let initTimeOut = UserDefaults.standard.value(forKey: "timeout") as? String
        let initPwd  = UserDefaults.standard.value(forKey: "pwd") as? String
        let enableTouchID  = UserDefaults.standard.bool(forKey: "enableTouchID")
     
        alertTimeoutText.text = initTimeOut
        pwdText.text = initPwd
        swhTouchID.setOn(enableTouchID, animated: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesBegan(touches, with: event)
//        view.endEditing(true)
//    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool
    {
        var maxLength = 4
        switch textField {
        case alertTimeoutText:
             maxLength = 1
        default:
             maxLength = 4
        }
        
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    @IBAction func alarmChanged(_ sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex);
        switch sender.selectedSegmentIndex {
        case 0:
            UserDefaults.standard.set("alarm_dudu" , forKey: "alarmFileName")
            break
        case 1:
            UserDefaults.standard.set("alarm_police_car" , forKey: "alarmFileName")
            break
        case 2:
            UserDefaults.standard.set("alarm_didi" , forKey: "alarmFileName")
            break
        default:
            UserDefaults.standard.set("alarm_dudu" , forKey: "alarmFileName")
            break
        }
        UserDefaults.standard.synchronize() 
        let mp3Name = UserDefaults.standard.value(forKey: "alarmFileName") as! String
        self.playSoundwithName(mp3Name);
        
    }
    
    func openSettingsView(){
        
        let sc = self.storyboard?.instantiateViewController(withIdentifier:  "Settings")  as! SettingsViewController
        self.navigationController?.show(sc, sender: nil )
    }
    
}



