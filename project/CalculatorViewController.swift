import UIKit
import StoreKit
import GoogleMobileAds

class CalculatorViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK : Declaring Outlets
    @IBOutlet weak var noResultsLabel: UILabel!
    @IBOutlet weak var loanAmountTextField: UITextField!
    @IBOutlet weak var paymentFrequencyTextfield: UITextField!
    @IBOutlet weak var interest: UISlider!
    @IBOutlet weak var interestSliderLabel: UILabel!
    @IBOutlet weak var interestPaid: UILabel!
    @IBOutlet weak var interestPerPayment: UILabel!
    @IBOutlet weak var totalInterestOutputHeader: UILabel!
    @IBOutlet weak var interestPerPaymentOutputHeader: UILabel!
    @IBOutlet weak var amortization: UISlider!
    @IBOutlet weak var amortizationSliderLabel: UILabel!
    @IBOutlet weak var paymentLabel: UILabel!
    @IBOutlet weak var paymentPlanLabel: UILabel!
    @IBOutlet weak var paymentsOutputHeader: UILabel!
    @IBOutlet weak var numOfPayments: UILabel!
    @IBOutlet weak var numOfPaymentsOutputHeader: UILabel!
    @IBOutlet weak var principle: UILabel!
    @IBOutlet weak var principleOutputHeader: UILabel!
   
    // MARK : Declaring Global Variables
    var loanAmount: Double = 0.00
    var interestAmount = 5.0
    var amortizationAmount = 48.0
    var months: Double = 12.0
    var weeksInYear = 52.00
    var pickerValue: String?
    var interstitial: GADInterstitial!

    let paymentPlan = ["","Monthly", "Weekly", "Semi-Monthly", "Semi-Weekly"]
    
    //declaring number formatter object
    lazy var numberFormatter: NumberFormatter =
        {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
        }()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //advertisement test ads
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        let request = GADRequest()
        interstitial.load(request)
      
         loanAmountTextField.delegate = self
         loanAmountTextField.placeholder = updateTextfield(amountParameter: loanAmount)
         createPaymentPicker()
         createToolBar()
        
         interestSliderLabel.text = "5 %"
         amortizationSliderLabel.text = "48 months"
    }

    // MARK: PickerView Object + Delegate Methods
    func createPaymentPicker()
    {
        let paymentPicker = UIPickerView()
            paymentPicker.delegate = self as UIPickerViewDelegate
    
            paymentFrequencyTextfield.inputView = paymentPicker
    }

    func createToolBar()
    {
        let toolBar = UIToolbar()
             toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(CalculatorViewController.dismissKeyboard))
        
            toolBar.setItems([doneButton], animated: false)
            toolBar.isUserInteractionEnabled = true
        
            paymentFrequencyTextfield.inputAccessoryView = toolBar
    }
    //picker delegate methods
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return paymentPlan.count
    }
        
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return paymentPlan[row]
    }
        
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        pickerValue = paymentPlan[row]
        paymentFrequencyTextfield.text = pickerValue
    }
    
    //MARK: Slider Actions
    @IBAction func interestSlider(_ sender: UISlider)
    {
        let interval: Double = 0.25
        interestAmount = Double((sender.value / Float(interval)).rounded() * Float(interval))
        sender.setValue(Float(interestAmount), animated: true)
        print(interestAmount)
        interestSliderLabel.text = (String(interestAmount)) + " %"
    }
    
    @IBAction func amortizationSlider(_ sender: UISlider)
    {
        let interval: Double = 1.00
        amortizationAmount = Double(Int((sender.value / Float(interval)).rounded() * Float(interval)))
        sender.setValue(Float(amortizationAmount), animated: true)
        if(amortizationAmount == 1)
        {
        amortizationSliderLabel.text = String(Int(sender.value)) + " month"
        }
        else
        {
        amortizationSliderLabel.text = String(Int(sender.value)) + " months"
        }
    }
     // MARK: Textfield Format + Delegate Methods
    func updateTextfield(amountParameter: Double) -> String?
    {
        return numberFormatter.string(from: NSNumber(value: amountParameter))
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if let digit = Double(string)
        {
            loanAmount = loanAmount * 10 + digit
            loanAmountTextField.text = updateTextfield(amountParameter: loanAmount)
        }
        
        if string == ""
        {
            loanAmount = loanAmount / 10
            loanAmountTextField.text = updateTextfield(amountParameter: loanAmount)
        }
        return false
    }
    
    // MARK : Text Field Functions
    func loanAmountToDouble(from textField: UITextField) -> Double
    {
        let loan = loanAmount

        return loan
    }
    
    func getPaymentsPerMonthBeforeInterest(value: Double) -> String
    {
        return String(value)
    }
    
     // MARK:- Invalid Alert Dialog
    func showInvalidInputAlert()
    {
        let alert = UIAlertController(title: "Invalid Input", message: "Field must be filled", preferredStyle: .alert)
        
        let titFont = [NSAttributedString.Key.font: UIFont(name: "Courier-Bold", size: 18.0)!]
        let msgFont = [NSAttributedString.Key.font: UIFont(name: "Courier", size: 12.0)!]
        
        let titAttrString = NSMutableAttributedString(string: "Invalid Input", attributes: titFont)
        let msgAttrString = NSMutableAttributedString(string: "All fields must be filled!", attributes: msgFont)
        
        alert.setValue(titAttrString, forKey: "attributedTitle")
        alert.setValue(msgAttrString, forKey: "attributedMessage")
        
        
        let fixAction = UIAlertAction(title: "Ok", style: .default) { (action) in
        }
            alert.addAction(fixAction)
            
            alert.view.tintColor = UIColor.blue
            alert.view.layer.cornerRadius = 40
            
            DispatchQueue.main.async(execute: {
            self.present(alert, animated: true)
            })
        }
    
    // MARK : Final Check Alert
    func showFinalCheckAlert()
    {
        if( loanAmountTextField.text == "" || loanAmountTextField.text == "$0.00" || pickerValue == nil )
        {
            showInvalidInputAlert()
        }
        else
        {
            let loanAmount = updateTextfield(amountParameter: self.loanAmount)
            let interestA = String(interestAmount)
            let amortizationAmount = String(lroundf(amortization.value))
            let frequencyAmount = pickerValue
            
            let message = "Loan: \(loanAmount!)\n Interest \(interestA)%\n Amortization \(amortizationAmount) Months\n Payment Plan: \(frequencyAmount!)"
            
            let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
            
            let titFont = [NSAttributedString.Key.font: UIFont(name: "Courier-Bold", size: 20.0)!]
            let msgFont = [NSAttributedString.Key.font: UIFont(name: "Courier", size: 16.0)!]
            
            let titAttrString = NSMutableAttributedString(string: "Correct?", attributes: titFont)
            let msgAttrString = NSMutableAttributedString(string: message, attributes: msgFont)
            
            alert.setValue(titAttrString, forKey: "attributedTitle")
            alert.setValue(msgAttrString, forKey: "attributedMessage")

            
            let fixAction = UIAlertAction(title: "Fix", style: .default) { (action) in
             
                if self.interstitial.isReady {
                    self.interstitial.present(fromRootViewController: self)
                }
            }
            
            let calculateAction = UIAlertAction(title: "Calculate", style: .default, handler: { _ in
                self.updateLabels()
                SKStoreReviewController.requestReview()
            })
            
            alert.addAction(fixAction)
            alert.addAction(calculateAction)
            
            alert.view.tintColor = UIColor.blue
            alert.view.layer.cornerRadius = 40
            
            DispatchQueue.main.async(execute: {
                self.present(alert, animated: true)
                
            })
        }
    }
    
    // MARK : Calculate Button
    @IBAction func calculateButton()
    {
        showFinalCheckAlert()
    }
    
    // MARK : Updating Labels
    func updateLabels()
     {
            //changing color of labels for result output
            principleOutputHeader.backgroundColor = #colorLiteral(red: 0.3764705882, green: 0.6705882353, blue: 0.6823529412, alpha: 0.6971853596)
            paymentsOutputHeader.backgroundColor = #colorLiteral(red: 0.3764705882, green: 0.6705882353, blue: 0.6823529412, alpha: 0.6971853596)
            totalInterestOutputHeader.backgroundColor = #colorLiteral(red: 0.3764705882, green: 0.6705882353, blue: 0.6823529412, alpha: 0.6971853596)
            interestPerPaymentOutputHeader.backgroundColor = #colorLiteral(red: 0.3764705882, green: 0.6705882353, blue: 0.6823529412, alpha: 0.6971853596)
            numOfPaymentsOutputHeader.backgroundColor = #colorLiteral(red: 0.3764705882, green: 0.6705882353, blue: 0.6823529412, alpha: 0.6971853596)
            noResultsLabel.text = ""

            //grabbing input values to perform calculations
            let amortizationRate = Double(lroundf(amortization.value))
            let loanAmount = loanAmountToDouble(from: loanAmountTextField)
            let interestRate = (interestAmount / 100) * loanAmount
        
            //updating labels in output results
            interestPaid.text = updateTextfield(amountParameter: interestRate)
            principle.text = updateTextfield(amountParameter: loanAmount)
        
        
            // get full interest + principle payment on monthly plan
            let monthlyPaymentWithoutInterest = (trunc(loanAmount / amortizationRate))
            let monthlyInterest = (loanAmount / amortizationRate) * (interestAmount / 100)
            let monthlyPaymentWithInterest = monthlyPaymentWithoutInterest + monthlyInterest
            let numberOfMonthlyPaymentsToMake = String(Int(amortizationRate))
            
            // gets full interest + principle payment on weekly plan
            let weeklyPaymentWithoutInterest = loanAmount / (trunc((amortizationRate / months) * weeksInYear))
            let weeklyInterest =  (loanAmount / ((amortizationRate / months) * weeksInYear)) * (interestAmount / 100)
            let weeklyPaymentWithInterest = weeklyPaymentWithoutInterest + weeklyInterest
            let numberOfWeeklyPaymentsToMake = String(Int((amortizationRate / months) * (weeksInYear)))
            
            // gets full interest + principle payment on bi monthly plan
            let semiMonthlyPaymentWithoutInterest = (trunc(loanAmount / amortizationRate) / 2)
            let semiMonthlyInterest = ((loanAmount / amortizationRate) / 2) * (interestAmount / 100)
            let semiMonthlyPaymentWithInterest = semiMonthlyPaymentWithoutInterest + semiMonthlyInterest
            let numberOfSemiMonthlyPaymentsToMake = String(Int(amortizationRate * 2))
            
            // gets full interest + principle payment on bi weekly plan
            let semiWeeklyPaymentWithoutInterest = ((loanAmount / amortizationRate) / 2)
            let semiWeeklyInterest = ((loanAmount / amortizationRate) / 2) * (interestAmount / 100)
            let semiWeeklyPaymentsWithInterest = semiWeeklyPaymentWithoutInterest + semiWeeklyInterest
            let semiWeeklyPaymentsToMake = String(Int(amortizationRate * 2))
        
            //switch, handling all combonations of payment plan
            switch (pickerValue)
            {
            case "Monthly":
                paymentLabel.text = updateTextfield(amountParameter: monthlyPaymentWithInterest)
                numOfPayments.text = numberOfMonthlyPaymentsToMake
                paymentPlanLabel.text = "Monthly"
                interestPerPayment.text = updateTextfield(amountParameter: monthlyInterest)
            case "Weekly":
                paymentLabel.text = updateTextfield(amountParameter: weeklyPaymentWithInterest)
                numOfPayments.text = numberOfWeeklyPaymentsToMake
                paymentPlanLabel.text = "Weekly"
                interestPerPayment.text = updateTextfield(amountParameter: weeklyInterest)
                
            case "Semi-Monthly":
                paymentLabel.text = updateTextfield(amountParameter: semiMonthlyPaymentWithInterest)
                numOfPayments.text = numberOfSemiMonthlyPaymentsToMake
                paymentPlanLabel.text = "Semi-Monthly"
                interestPerPayment.text = updateTextfield(amountParameter: semiMonthlyInterest)
                
            case "Semi-Weekly":
                paymentLabel.text = updateTextfield(amountParameter: semiWeeklyPaymentsWithInterest)
                numOfPayments.text = semiWeeklyPaymentsToMake
                paymentPlanLabel.text = "Semi-Weekly"
                interestPerPayment.text = updateTextfield(amountParameter: semiWeeklyInterest)
                
            default:
                break
        }
    }
}
