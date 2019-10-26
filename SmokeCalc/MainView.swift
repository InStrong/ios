

import UIKit

class MainView: UIViewController {
    
    @IBOutlet weak var calcButton: UIButton!
    @IBAction func calcButtonAction(_ sender: Any) {
        
        if !tf2.text!.isEmpty, !tf1.text!.isEmpty, !tf3.text!.isEmpty, !tf4.text!.isEmpty {
            statisticView.isHidden = false
            
            UserDefaults.standard.setValue(true, forKey: "data")
            
            UserDefaults.standard.setValue(pickedDate, forKey: "date")
            UserDefaults.standard.setValue(tf2.text, forKey: "sigsPerDay")
            UserDefaults.standard.setValue(tf3.text, forKey: "numbInBlock")
            UserDefaults.standard.setValue(tf4.text, forKey: "price")
            
            calcStatistics()
        } else {
            alerFunction()
        }
        
       
    }

    @IBAction func editButtonAction(_ sender: Any) {
        statisticView.isHidden = true
    }
    
    @IBAction func tf1Action(_ sender: Any) {
        showDatePicker()
    }
    
    @IBOutlet weak var statisticView: UIView!
    @IBOutlet weak var statDays: UILabel!
    @IBOutlet weak var statSigs: UILabel!
    @IBOutlet weak var statRubs: UILabel!
    
    @IBOutlet weak var tf1: UITextField! //date
    @IBOutlet weak var tf2: UITextField! //
    @IBOutlet weak var tf3: UITextField! //
    @IBOutlet weak var tf4: UITextField! //price
    
    let datePicker = UIDatePicker()
    var pickedDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showDatePicker()
        calcButton.layer.cornerRadius = 16
        calcButton.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        calcButton.isUserInteractionEnabled = true
        
        if UserDefaults.standard.value(forKey: "data") != nil {
            statisticView.isHidden = false
            
            let date = UserDefaults.standard.value(forKey: "date") as? Date
            pickedDate = date!
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            tf1.text = formatter.string(from: date!)
            tf2.text = UserDefaults.standard.value(forKey: "sigsPerDay") as! String
            tf3.text = UserDefaults.standard.value(forKey: "numbInBlock") as! String
            tf4.text = UserDefaults.standard.value(forKey: "price") as! String
            
            calcStatistics()
        }
        
        self.hideKeyboardWhenTappedAround()
    }
    
    func calcStatistics() {
        let calendar = Calendar.current
        let date1 = calendar.startOfDay(for: pickedDate)
        let date2 = calendar.startOfDay(for: Date())
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        
        statDays.text = "\(components.day!)"
        
        let sigsPerDay = Int(tf2.text!)
        statSigs.text = "\(components.day!*sigsPerDay!)"
        
        let priceForOneSig = Int(tf4.text!)!/Int(tf3.text!)!
        let totaSigs = components.day!*sigsPerDay!
        statRubs.text = "\(totaSigs*priceForOneSig)"
    }
    
    func alerFunction() {
        let alertController = UIAlertController(title: "Ошибка", message: "Нужно заполнить все поля", preferredStyle: .alert)
        let action = UIAlertAction(title: "ОК", style: .cancel, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true)
    }

    func showDatePicker() {
        //Formate Date
        datePicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        toolbar.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        tf1.inputAccessoryView = toolbar
        tf1.inputView = datePicker
    }
    
    @objc func donedatePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        tf1.text = formatter.string(from: datePicker.date)
        pickedDate = datePicker.date
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker( ){ self.view.endEditing(true) }
   
}//class


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}








































