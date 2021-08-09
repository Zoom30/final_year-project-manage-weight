import UIKit
import RealmSwift
class WeeklyMealRoutineViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: - IBOutlet declaration
    @IBOutlet var breakfastCollection: [UILabel]!
    @IBOutlet var lunchCollection: [UILabel]!
    @IBOutlet var dinnerCollection: [UILabel]!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dietTextField: UITextField!
    @IBOutlet weak var recipeToExcludeTextField: UITextField!
    @IBOutlet weak var currentCalorieLabel: UILabel!
    @IBOutlet weak var dietPlanButton: UIButton!
    @IBOutlet weak var customPlanButton: UIButton!
    @IBOutlet weak var dietAndCustomPlanButton: UIButton!
    
    //MARK: - Global variables
    var accessToInitialWeight : Results<InitialWeightAndHeight>?
    var accessToTargetWeight : Results<SetTargetWeight>?
    var accessToWeeklyMealStored : Results<WeeklyMealStored>?
    
    var generateWeeklyMeal = GenerateWeeklyMeal()
    let apiUrl = "https://api.spoonacular.com/mealplanner/generate?apiKey=9b901895edad45a483f3f7c377fd0ebf&timeFrame=week&targetCalories="
    var mBfLink = "", tBfLink = "", wBfLink = "", thBfLink = "", fBfLink = "", sBfLink = "", suBfLink = ""
    var mLLink = "", tLLink = "", wLLink = "", thLLink = "", fLLink = "", sLLink = "", suLLink = ""
    var mDLink = "", tDLink = "", wDLink = "", thDLink = "", fDLink = "", sDLink = "", suDLink = ""
    
    
    
    //MARK: - viewDidLoad() method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dietTextField.delegate = self
        recipeToExcludeTextField.delegate = self
        
        hideKeyboardWhenTappedAround()
        resizeViewOnKeyboardAppearDisappear()
        //load necessary data
        loadInitialWeight()
        loadTargetWeight()
        loadStoredWeeklyPlan()
        
        
        
        
        if accessToWeeklyMealStored!.count > 0 {
            let mBfTap = UITapGestureRecognizer(target: self, action: #selector(openMBfLink(sender:)))
            breakfastCollection[0].addGestureRecognizer(mBfTap)
            let tBfTap = UITapGestureRecognizer(target: self, action: #selector(openTBfLink(sender:)))
            breakfastCollection[1].addGestureRecognizer(tBfTap)
            let wBfTap = UITapGestureRecognizer(target: self, action: #selector(openWBfLink(sender:)))
            breakfastCollection[2].addGestureRecognizer(wBfTap)
            let thBfTap = UITapGestureRecognizer(target: self, action: #selector(openThBfLink(sender:)))
            breakfastCollection[3].addGestureRecognizer(thBfTap)
            let fBfTap = UITapGestureRecognizer(target: self, action: #selector(openFBfLink(sender:)))
            breakfastCollection[4].addGestureRecognizer(fBfTap)
            let sBfTap = UITapGestureRecognizer(target: self, action: #selector(openSBfLink(sender:)))
            breakfastCollection[5].addGestureRecognizer(sBfTap)
            let suBfTap = UITapGestureRecognizer(target: self, action: #selector(openSuBfLink(sender:)))
            breakfastCollection[6].addGestureRecognizer(suBfTap)
            
            
            let mLTap = UITapGestureRecognizer(target: self, action: #selector(openMLLink(sender:)))
            lunchCollection[0].addGestureRecognizer(mLTap)
            let tLTap = UITapGestureRecognizer(target: self, action: #selector(openTLLink(sender:)))
            lunchCollection[1].addGestureRecognizer(tLTap)
            let wLTap = UITapGestureRecognizer(target: self, action: #selector(openWLLink(sender:)))
            lunchCollection[2].addGestureRecognizer(wLTap)
            let thLTap = UITapGestureRecognizer(target: self, action: #selector(openThLLink(sender:)))
            lunchCollection[3].addGestureRecognizer(thLTap)
            let fLTap = UITapGestureRecognizer(target: self, action: #selector(openFLLink(sender:)))
            lunchCollection[4].addGestureRecognizer(fLTap)
            let sLTap = UITapGestureRecognizer(target: self, action: #selector(openSLLink(sender:)))
            lunchCollection[5].addGestureRecognizer(sLTap)
            let suLTap = UITapGestureRecognizer(target: self, action: #selector(openSuLLink(sender:)))
            lunchCollection[6].addGestureRecognizer(suLTap)
            
            
            let mDTap = UITapGestureRecognizer(target: self, action: #selector(openMDLink(sender:)))
            dinnerCollection[0].addGestureRecognizer(mDTap)
            let tDTap = UITapGestureRecognizer(target: self, action: #selector(openTDLink(sender:)))
            dinnerCollection[1].addGestureRecognizer(tDTap)
            let wDTap = UITapGestureRecognizer(target: self, action: #selector(openWDLink(sender:)))
            dinnerCollection[2].addGestureRecognizer(wDTap)
            let thDTap = UITapGestureRecognizer(target: self, action: #selector(openThDLink(sender:)))
            dinnerCollection[3].addGestureRecognizer(thDTap)
            let fDTap = UITapGestureRecognizer(target: self, action: #selector(openFDLink(sender:)))
            dinnerCollection[4].addGestureRecognizer(fDTap)
            let sDTap = UITapGestureRecognizer(target: self, action: #selector(openSDLink(sender:)))
            dinnerCollection[5].addGestureRecognizer(sDTap)
            let suDTap = UITapGestureRecognizer(target: self, action: #selector(openSuDLink(sender:)))
            dinnerCollection[6].addGestureRecognizer(suDTap)
            
            
            currentCalorieLabel.text = accessToWeeklyMealStored?.last?.calorie
            breakfastCollection[0].text = accessToWeeklyMealStored?.last?.mBf
            mBfLink = (accessToWeeklyMealStored?.last?.mBfUrl)!
            
            breakfastCollection[1].text = accessToWeeklyMealStored?.last?.tBf
            tBfLink = (accessToWeeklyMealStored?.last?.tBfUrl)!
            
            breakfastCollection[2].text = accessToWeeklyMealStored?.last?.wBf
            wBfLink = (accessToWeeklyMealStored?.last?.wBfUrl)!
            
            breakfastCollection[3].text = accessToWeeklyMealStored?.last?.thBf
            thBfLink = (accessToWeeklyMealStored?.last?.thBfUrl)!
            
            breakfastCollection[4].text = accessToWeeklyMealStored?.last?.fBf
            fBfLink = (accessToWeeklyMealStored?.last?.fBfUrl)!
            
            breakfastCollection[5].text = accessToWeeklyMealStored?.last?.sBf
            sBfLink = (accessToWeeklyMealStored?.last?.sBfUrl)!
            
            breakfastCollection[6].text = accessToWeeklyMealStored?.last?.suBf
            suBfLink = (accessToWeeklyMealStored?.last?.suBfUrl)!
            
            
            lunchCollection[0].text = accessToWeeklyMealStored?.last?.mL
            mLLink = (accessToWeeklyMealStored?.last?.mLUrl)!
            
            lunchCollection[1].text = accessToWeeklyMealStored?.last?.tL
            tLLink = (accessToWeeklyMealStored?.last?.tLUrl)!
            
            lunchCollection[2].text = accessToWeeklyMealStored?.last?.wL
            wLLink = (accessToWeeklyMealStored?.last?.wLUrl)!
            
            lunchCollection[3].text = accessToWeeklyMealStored?.last?.thL
            thLLink = (accessToWeeklyMealStored?.last?.thLUrl)!
            
            lunchCollection[4].text = accessToWeeklyMealStored?.last?.fL
            fLLink = (accessToWeeklyMealStored?.last?.fLUrl)!
            
            lunchCollection[5].text = accessToWeeklyMealStored?.last?.sL
            sLLink = (accessToWeeklyMealStored?.last?.sLUrl)!
            
            lunchCollection[6].text = accessToWeeklyMealStored?.last?.suL
            suLLink = (accessToWeeklyMealStored?.last?.suLUrl)!
            
            
            dinnerCollection[0].text = accessToWeeklyMealStored?.last?.mD
            mDLink = (accessToWeeklyMealStored?.last?.mDUrl)!
            
            dinnerCollection[1].text = accessToWeeklyMealStored?.last?.tD
            tDLink = (accessToWeeklyMealStored?.last?.tDUrl)!
            
            dinnerCollection[2].text = accessToWeeklyMealStored?.last?.wD
            wDLink = (accessToWeeklyMealStored?.last?.wDUrl)!
            
            dinnerCollection[3].text = accessToWeeklyMealStored?.last?.thD
            thDLink = (accessToWeeklyMealStored?.last?.thDUrl)!
            
            dinnerCollection[4].text = accessToWeeklyMealStored?.last?.fD
            fDLink = (accessToWeeklyMealStored?.last?.fDUrl)!
            
            dinnerCollection[5].text = accessToWeeklyMealStored?.last?.sD
            sDLink = (accessToWeeklyMealStored?.last?.sDUrl)!
            
            dinnerCollection[6].text = accessToWeeklyMealStored?.last?.suD
            suDLink = (accessToWeeklyMealStored?.last?.suDUrl)!
            
        }else
        {
            
            //UILabel tapGesture assign
            let mBfTap = UITapGestureRecognizer(target: self, action: #selector(openMBfLink(sender:)))
            breakfastCollection[0].addGestureRecognizer(mBfTap)
            let tBfTap = UITapGestureRecognizer(target: self, action: #selector(openTBfLink(sender:)))
            breakfastCollection[1].addGestureRecognizer(tBfTap)
            let wBfTap = UITapGestureRecognizer(target: self, action: #selector(openWBfLink(sender:)))
            breakfastCollection[2].addGestureRecognizer(wBfTap)
            let thBfTap = UITapGestureRecognizer(target: self, action: #selector(openThBfLink(sender:)))
            breakfastCollection[3].addGestureRecognizer(thBfTap)
            let fBfTap = UITapGestureRecognizer(target: self, action: #selector(openFBfLink(sender:)))
            breakfastCollection[4].addGestureRecognizer(fBfTap)
            let sBfTap = UITapGestureRecognizer(target: self, action: #selector(openSBfLink(sender:)))
            breakfastCollection[5].addGestureRecognizer(sBfTap)
            let suBfTap = UITapGestureRecognizer(target: self, action: #selector(openSuBfLink(sender:)))
            breakfastCollection[6].addGestureRecognizer(suBfTap)
            
            
            let mLTap = UITapGestureRecognizer(target: self, action: #selector(openMLLink(sender:)))
            lunchCollection[0].addGestureRecognizer(mLTap)
            let tLTap = UITapGestureRecognizer(target: self, action: #selector(openTLLink(sender:)))
            lunchCollection[1].addGestureRecognizer(tLTap)
            let wLTap = UITapGestureRecognizer(target: self, action: #selector(openWLLink(sender:)))
            lunchCollection[2].addGestureRecognizer(wLTap)
            let thLTap = UITapGestureRecognizer(target: self, action: #selector(openThLLink(sender:)))
            lunchCollection[3].addGestureRecognizer(thLTap)
            let fLTap = UITapGestureRecognizer(target: self, action: #selector(openFLLink(sender:)))
            lunchCollection[4].addGestureRecognizer(fLTap)
            let sLTap = UITapGestureRecognizer(target: self, action: #selector(openSLLink(sender:)))
            lunchCollection[5].addGestureRecognizer(sLTap)
            let suLTap = UITapGestureRecognizer(target: self, action: #selector(openSuLLink(sender:)))
            lunchCollection[6].addGestureRecognizer(suLTap)
            
            
            let mDTap = UITapGestureRecognizer(target: self, action: #selector(openMDLink(sender:)))
            dinnerCollection[0].addGestureRecognizer(mDTap)
            let tDTap = UITapGestureRecognizer(target: self, action: #selector(openTDLink(sender:)))
            dinnerCollection[1].addGestureRecognizer(tDTap)
            let wDTap = UITapGestureRecognizer(target: self, action: #selector(openWDLink(sender:)))
            dinnerCollection[2].addGestureRecognizer(wDTap)
            let thDTap = UITapGestureRecognizer(target: self, action: #selector(openThDLink(sender:)))
            dinnerCollection[3].addGestureRecognizer(thDTap)
            let fDTap = UITapGestureRecognizer(target: self, action: #selector(openFDLink(sender:)))
            dinnerCollection[4].addGestureRecognizer(fDTap)
            let sDTap = UITapGestureRecognizer(target: self, action: #selector(openSDLink(sender:)))
            dinnerCollection[5].addGestureRecognizer(sDTap)
            let suDTap = UITapGestureRecognizer(target: self, action: #selector(openSuDLink(sender:)))
            dinnerCollection[6].addGestureRecognizer(suDTap)
            
            
            
            
            //WGP weekly planner
            var randomCalorieAssignment = 0
            
            let initialWeight = Int(accessToInitialWeight![0].weight)
            let targetWeight = Int(accessToTargetWeight![0].targetWeight)
            
            
            if Double(initialWeight) <= Double(targetWeight) {
                titleLabel.text = "Weekly meal routine (gain)"
                randomCalorieAssignment = Int.random(in: 2500...3500)
                if Double(initialWeight) == Double(targetWeight){
                    randomCalorieAssignment = Int.random(in: 1800...2200)
                    titleLabel.text = "Weekly meal routine (maintain)"
                }
                currentCalorieLabel.text = "Current daily calorie: \(randomCalorieAssignment)"
                let newApiUrl = "\(apiUrl)\(String(randomCalorieAssignment))"
                
                generateWeeklyMeal.fetchPostData(completionHandler: { (response) in
                    DispatchQueue.main.async {
                        
                        self.breakfastCollection![0].text! = response.week.monday.meals[0].title
                        self.mBfLink = response.week.monday.meals[0].sourceURL
                        self.breakfastCollection![1].text! = response.week.tuesday.meals[0].title
                        self.tBfLink = response.week.tuesday.meals[0].sourceURL
                        self.breakfastCollection![2].text! = response.week.wednesday.meals[0].title
                        self.wBfLink = response.week.wednesday.meals[0].sourceURL
                        self.breakfastCollection![3].text! = response.week.thursday.meals[0].title
                        self.thBfLink = response.week.thursday.meals[0].sourceURL
                        self.breakfastCollection![4].text! = response.week.friday.meals[0].title
                        self.fBfLink = response.week.friday.meals[0].sourceURL
                        self.breakfastCollection![5].text! = response.week.saturday.meals[0].title
                        self.sBfLink = response.week.saturday.meals[0].sourceURL
                        self.breakfastCollection![6].text! = response.week.sunday.meals[0].title
                        self.suBfLink = response.week.sunday.meals[0].sourceURL
                        
                        self.lunchCollection![0].text! = response.week.monday.meals[1].title
                        self.mLLink = response.week.monday.meals[1].sourceURL
                        self.lunchCollection![1].text! = response.week.tuesday.meals[1].title
                        self.tLLink = response.week.tuesday.meals[1].sourceURL
                        self.lunchCollection![2].text! = response.week.wednesday.meals[1].title
                        self.wLLink = response.week.wednesday.meals[1].sourceURL
                        self.lunchCollection![3].text! = response.week.thursday.meals[1].title
                        self.thLLink = response.week.thursday.meals[1].sourceURL
                        self.lunchCollection![4].text! = response.week.friday.meals[1].title
                        self.fLLink = response.week.friday.meals[1].sourceURL
                        self.lunchCollection![5].text! = response.week.saturday.meals[1].title
                        self.sLLink = response.week.saturday.meals[1].sourceURL
                        self.lunchCollection![6].text! = response.week.sunday.meals[1].title
                        self.suLLink = response.week.sunday.meals[1].sourceURL
                        
                        self.dinnerCollection![0].text! = response.week.monday.meals[2].title
                        self.mDLink = response.week.monday.meals[2].sourceURL
                        self.dinnerCollection![1].text! = response.week.tuesday.meals[2].title
                        self.tDLink = response.week.tuesday.meals[2].sourceURL
                        self.dinnerCollection![2].text! = response.week.wednesday.meals[2].title
                        self.wDLink = response.week.wednesday.meals[2].sourceURL
                        self.dinnerCollection![3].text! = response.week.thursday.meals[2].title
                        self.thDLink = response.week.thursday.meals[2].sourceURL
                        self.dinnerCollection![4].text! = response.week.friday.meals[2].title
                        self.fDLink = response.week.friday.meals[2].sourceURL
                        self.dinnerCollection![5].text! = response.week.saturday.meals[2].title
                        self.sDLink = response.week.saturday.meals[2].sourceURL
                        self.dinnerCollection![6].text! = response.week.sunday.meals[2].title
                        self.suDLink = response.week.sunday.meals[2].sourceURL
                    }
                }, url: newApiUrl)
                
            }
            
            //WLP weekly planner
            if Double(initialWeight) > Double(targetWeight) {
                titleLabel.text = "Weekly meal routine (lose)"
                
                randomCalorieAssignment = Int.random(in: 800...1400)
                currentCalorieLabel.text = "Current daily calorie: \(randomCalorieAssignment)"
                let newApiUrl = "\(apiUrl)\(String(randomCalorieAssignment))"
                
                generateWeeklyMeal.fetchPostData(completionHandler: { (response) in
                    DispatchQueue.main.async {
                        self.breakfastCollection![0].text! = response.week.monday.meals[0].title
                        self.mBfLink = response.week.monday.meals[0].sourceURL
                        self.breakfastCollection![1].text! = response.week.tuesday.meals[0].title
                        self.tBfLink = response.week.tuesday.meals[0].sourceURL
                        self.breakfastCollection![2].text! = response.week.wednesday.meals[0].title
                        self.wBfLink = response.week.wednesday.meals[0].sourceURL
                        self.breakfastCollection![3].text! = response.week.thursday.meals[0].title
                        self.thBfLink = response.week.thursday.meals[0].sourceURL
                        self.breakfastCollection![4].text! = response.week.friday.meals[0].title
                        self.fBfLink = response.week.friday.meals[0].sourceURL
                        self.breakfastCollection![5].text! = response.week.saturday.meals[0].title
                        self.sBfLink = response.week.saturday.meals[0].sourceURL
                        self.breakfastCollection![6].text! = response.week.sunday.meals[0].title
                        self.suBfLink = response.week.sunday.meals[0].sourceURL
                        
                        self.lunchCollection![0].text! = response.week.monday.meals[1].title
                        self.mLLink = response.week.monday.meals[1].sourceURL
                        self.lunchCollection![1].text! = response.week.tuesday.meals[1].title
                        self.tLLink = response.week.tuesday.meals[1].sourceURL
                        self.lunchCollection![2].text! = response.week.wednesday.meals[1].title
                        self.wLLink = response.week.wednesday.meals[1].sourceURL
                        self.lunchCollection![3].text! = response.week.thursday.meals[1].title
                        self.thLLink = response.week.thursday.meals[1].sourceURL
                        self.lunchCollection![4].text! = response.week.friday.meals[1].title
                        self.fLLink = response.week.friday.meals[1].sourceURL
                        self.lunchCollection![5].text! = response.week.saturday.meals[1].title
                        self.sLLink = response.week.saturday.meals[1].sourceURL
                        self.lunchCollection![6].text! = response.week.sunday.meals[1].title
                        self.suLLink = response.week.sunday.meals[1].sourceURL
                        
                        self.dinnerCollection![0].text! = response.week.monday.meals[2].title
                        self.mDLink = response.week.monday.meals[2].sourceURL
                        self.dinnerCollection![1].text! = response.week.tuesday.meals[2].title
                        self.tDLink = response.week.tuesday.meals[2].sourceURL
                        self.dinnerCollection![2].text! = response.week.wednesday.meals[2].title
                        self.wDLink = response.week.wednesday.meals[2].sourceURL
                        self.dinnerCollection![3].text! = response.week.thursday.meals[2].title
                        self.thDLink = response.week.thursday.meals[2].sourceURL
                        self.dinnerCollection![4].text! = response.week.friday.meals[2].title
                        self.fDLink = response.week.friday.meals[2].sourceURL
                        self.dinnerCollection![5].text! = response.week.saturday.meals[2].title
                        self.sDLink = response.week.saturday.meals[2].sourceURL
                        self.dinnerCollection![6].text! = response.week.sunday.meals[2].title
                        self.suDLink = response.week.sunday.meals[2].sourceURL
                    }
                }, url: newApiUrl)
            }
            
        }
        //
        //        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        //        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    
    
 
    //    override var shouldAutorotate: Bool{
//        return true
//    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters1 = CharacterSet.letters
        let allowedCharacters2 = CharacterSet.punctuationCharacters
        let characterSet = CharacterSet(charactersIn: string)
        if allowedCharacters1.isSuperset(of: characterSet) {
            return true
        }
        else if allowedCharacters2.isSuperset(of: characterSet){
            return true
        }
        else {
            return false
        }
    }
    
    
    //MARK: - Load data
    func loadInitialWeight (){
        if let realm = try? Realm(){
            accessToInitialWeight = realm.objects(InitialWeightAndHeight.self)
        }
    }
    func loadTargetWeight(){
        if let realm = try? Realm(){
            accessToTargetWeight = realm.objects(SetTargetWeight.self)
        }
    }
    
    
    
    //MARK: - Generate New Plan Button
    
    
    @IBAction func getNewMealPlanPressed(_ sender: UIButton) {
        loadInitialWeight()
        loadTargetWeight()
        
        var randomCalorieAssignment = 0
        
        let initialWeight = Int(accessToInitialWeight![0].weight)
        let targetWeight = Int(accessToTargetWeight![0].targetWeight)
        
        if initialWeight <= targetWeight {
            titleLabel.text = "Weekly meal routine (gain)"
            randomCalorieAssignment = Int.random(in: 2500...3500)
            if Double(initialWeight) == Double(targetWeight){
                randomCalorieAssignment = Int.random(in: 1800...2200)
                titleLabel.text = "Weekly meal routine (maintain)"
            }
            currentCalorieLabel.text = "Current daily calorie: \(randomCalorieAssignment)"
            let newApiUrl = "\(apiUrl)\(String(randomCalorieAssignment))"
            
            generateWeeklyMeal.fetchPostData(completionHandler: { (response) in
                DispatchQueue.main.async {
                    self.breakfastCollection![0].text! = response.week.monday.meals[0].title
                    self.mBfLink = response.week.monday.meals[0].sourceURL
                    self.breakfastCollection![1].text! = response.week.tuesday.meals[0].title
                    self.tBfLink = response.week.tuesday.meals[0].sourceURL
                    self.breakfastCollection![2].text! = response.week.wednesday.meals[0].title
                    self.wBfLink = response.week.wednesday.meals[0].sourceURL
                    self.breakfastCollection![3].text! = response.week.thursday.meals[0].title
                    self.thBfLink = response.week.thursday.meals[0].sourceURL
                    self.breakfastCollection![4].text! = response.week.friday.meals[0].title
                    self.fBfLink = response.week.friday.meals[0].sourceURL
                    self.breakfastCollection![5].text! = response.week.saturday.meals[0].title
                    self.sBfLink = response.week.saturday.meals[0].sourceURL
                    self.breakfastCollection![6].text! = response.week.sunday.meals[0].title
                    self.suBfLink = response.week.sunday.meals[0].sourceURL
                    
                    self.lunchCollection![0].text! = response.week.monday.meals[1].title
                    self.mLLink = response.week.monday.meals[1].sourceURL
                    self.lunchCollection![1].text! = response.week.tuesday.meals[1].title
                    self.tLLink = response.week.tuesday.meals[1].sourceURL
                    self.lunchCollection![2].text! = response.week.wednesday.meals[1].title
                    self.wLLink = response.week.wednesday.meals[1].sourceURL
                    self.lunchCollection![3].text! = response.week.thursday.meals[1].title
                    self.thLLink = response.week.thursday.meals[1].sourceURL
                    self.lunchCollection![4].text! = response.week.friday.meals[1].title
                    self.fLLink = response.week.friday.meals[1].sourceURL
                    self.lunchCollection![5].text! = response.week.saturday.meals[1].title
                    self.sLLink = response.week.saturday.meals[1].sourceURL
                    self.lunchCollection![6].text! = response.week.sunday.meals[1].title
                    self.suLLink = response.week.sunday.meals[1].sourceURL
                    
                    self.dinnerCollection![0].text! = response.week.monday.meals[2].title
                    self.mDLink = response.week.monday.meals[2].sourceURL
                    self.dinnerCollection![1].text! = response.week.tuesday.meals[2].title
                    self.tDLink = response.week.tuesday.meals[2].sourceURL
                    self.dinnerCollection![2].text! = response.week.wednesday.meals[2].title
                    self.wDLink = response.week.wednesday.meals[2].sourceURL
                    self.dinnerCollection![3].text! = response.week.thursday.meals[2].title
                    self.thDLink = response.week.thursday.meals[2].sourceURL
                    self.dinnerCollection![4].text! = response.week.friday.meals[2].title
                    self.fDLink = response.week.friday.meals[2].sourceURL
                    self.dinnerCollection![5].text! = response.week.saturday.meals[2].title
                    self.sDLink = response.week.saturday.meals[2].sourceURL
                    self.dinnerCollection![6].text! = response.week.sunday.meals[2].title
                    self.suDLink = response.week.sunday.meals[2].sourceURL
                }
            }, url: newApiUrl)
            
        }
        if initialWeight > targetWeight {
            titleLabel.text = "Weekly meal routine (lose)"
            randomCalorieAssignment = Int.random(in: 800...1400)
            currentCalorieLabel.text = "Current daily calorie: \(randomCalorieAssignment)"
            let newApiUrl = "\(apiUrl)\(String(randomCalorieAssignment))"
            
            generateWeeklyMeal.fetchPostData(completionHandler: { (response) in
                DispatchQueue.main.async {
                    self.breakfastCollection![0].text! = response.week.monday.meals[0].title
                    self.mBfLink = response.week.monday.meals[0].sourceURL
                    self.breakfastCollection![1].text! = response.week.tuesday.meals[0].title
                    self.tBfLink = response.week.tuesday.meals[0].sourceURL
                    self.breakfastCollection![2].text! = response.week.wednesday.meals[0].title
                    self.wBfLink = response.week.wednesday.meals[0].sourceURL
                    self.breakfastCollection![3].text! = response.week.thursday.meals[0].title
                    self.thBfLink = response.week.thursday.meals[0].sourceURL
                    self.breakfastCollection![4].text! = response.week.friday.meals[0].title
                    self.fBfLink = response.week.friday.meals[0].sourceURL
                    self.breakfastCollection![5].text! = response.week.saturday.meals[0].title
                    self.sBfLink = response.week.saturday.meals[0].sourceURL
                    self.breakfastCollection![6].text! = response.week.sunday.meals[0].title
                    self.suBfLink = response.week.sunday.meals[0].sourceURL
                    
                    self.lunchCollection![0].text! = response.week.monday.meals[1].title
                    self.mLLink = response.week.monday.meals[1].sourceURL
                    self.lunchCollection![1].text! = response.week.tuesday.meals[1].title
                    self.tLLink = response.week.tuesday.meals[1].sourceURL
                    self.lunchCollection![2].text! = response.week.wednesday.meals[1].title
                    self.wLLink = response.week.wednesday.meals[1].sourceURL
                    self.lunchCollection![3].text! = response.week.thursday.meals[1].title
                    self.thLLink = response.week.thursday.meals[1].sourceURL
                    self.lunchCollection![4].text! = response.week.friday.meals[1].title
                    self.fLLink = response.week.friday.meals[1].sourceURL
                    self.lunchCollection![5].text! = response.week.saturday.meals[1].title
                    self.sLLink = response.week.saturday.meals[1].sourceURL
                    self.lunchCollection![6].text! = response.week.sunday.meals[1].title
                    self.suLLink = response.week.sunday.meals[1].sourceURL
                    
                    self.dinnerCollection![0].text! = response.week.monday.meals[2].title
                    self.mDLink = response.week.monday.meals[2].sourceURL
                    self.dinnerCollection![1].text! = response.week.tuesday.meals[2].title
                    self.tDLink = response.week.tuesday.meals[2].sourceURL
                    self.dinnerCollection![2].text! = response.week.wednesday.meals[2].title
                    self.wDLink = response.week.wednesday.meals[2].sourceURL
                    self.dinnerCollection![3].text! = response.week.thursday.meals[2].title
                    self.thDLink = response.week.thursday.meals[2].sourceURL
                    self.dinnerCollection![4].text! = response.week.friday.meals[2].title
                    self.fDLink = response.week.friday.meals[2].sourceURL
                    self.dinnerCollection![5].text! = response.week.saturday.meals[2].title
                    self.sDLink = response.week.saturday.meals[2].sourceURL
                    self.dinnerCollection![6].text! = response.week.sunday.meals[2].title
                    self.suDLink = response.week.sunday.meals[2].sourceURL
                }
            }, url: newApiUrl)
        }
    }
    
    
    @IBAction func didEndEditing(_ sender: UITextField) {
        
        if dietTextField.text != "" && dietTextField.text!.filter({$0 == " "}).count == 0 {
            dietPlanButton.isEnabled = true
            dietPlanButton.tintColor = .systemGreen
        }else{
            dietPlanButton.isEnabled = false
            dietPlanButton.tintColor = .systemGray
        }
        if recipeToExcludeTextField.text != "" && recipeToExcludeTextField.text!.filter({$0 == " "}).count == 0 {
            customPlanButton.isEnabled = true
            customPlanButton.tintColor = .systemGreen
        }else{
            customPlanButton.isEnabled = false
            customPlanButton.tintColor = .systemGray
        }
        if (dietTextField.text != "" && dietTextField.text!.filter({$0 == " "}).count == 0 && recipeToExcludeTextField.text != "" && recipeToExcludeTextField.text!.filter({$0 == " "}).count == 0) {
            dietAndCustomPlanButton.isEnabled = true
        }
        else{
            dietAndCustomPlanButton.isEnabled = false
        }
        
    }
    
    
    
    
    @IBAction func dietPlanPressed(_ sender: UIButton) {
        loadInitialWeight()
        loadTargetWeight()
        let dietPreference = dietTextField.text!
        var randomCalorieAssignment = 0
        let initialWeight = Int(accessToInitialWeight![0].weight)
        let targetWeight = Int(accessToTargetWeight![0].targetWeight)
        
        if initialWeight <= targetWeight {
            randomCalorieAssignment = Int.random(in: 2500...3500)
            if Double(initialWeight) == Double(targetWeight){
                randomCalorieAssignment = Int.random(in: 1800...2200)
                titleLabel.text = "Weekly meal routine (maintain)"
            }
            currentCalorieLabel.text = "Current daily calorie: \(randomCalorieAssignment)"
            let newApiUrl = "\(apiUrl)\(String(randomCalorieAssignment))&diet=\(dietPreference)"
            generateWeeklyMeal.fetchPostData(completionHandler: { (response) in
                DispatchQueue.main.async {
                    self.breakfastCollection![0].text! = response.week.monday.meals[0].title
                    self.mBfLink = response.week.monday.meals[0].sourceURL
                    self.breakfastCollection![1].text! = response.week.tuesday.meals[0].title
                    self.tBfLink = response.week.tuesday.meals[0].sourceURL
                    self.breakfastCollection![2].text! = response.week.wednesday.meals[0].title
                    self.wBfLink = response.week.wednesday.meals[0].sourceURL
                    self.breakfastCollection![3].text! = response.week.thursday.meals[0].title
                    self.thBfLink = response.week.thursday.meals[0].sourceURL
                    self.breakfastCollection![4].text! = response.week.friday.meals[0].title
                    self.fBfLink = response.week.friday.meals[0].sourceURL
                    self.breakfastCollection![5].text! = response.week.saturday.meals[0].title
                    self.sBfLink = response.week.saturday.meals[0].sourceURL
                    self.breakfastCollection![6].text! = response.week.sunday.meals[0].title
                    self.suBfLink = response.week.sunday.meals[0].sourceURL
                    
                    self.lunchCollection![0].text! = response.week.monday.meals[1].title
                    self.mLLink = response.week.monday.meals[1].sourceURL
                    self.lunchCollection![1].text! = response.week.tuesday.meals[1].title
                    self.tLLink = response.week.tuesday.meals[1].sourceURL
                    self.lunchCollection![2].text! = response.week.wednesday.meals[1].title
                    self.wLLink = response.week.wednesday.meals[1].sourceURL
                    self.lunchCollection![3].text! = response.week.thursday.meals[1].title
                    self.thLLink = response.week.thursday.meals[1].sourceURL
                    self.lunchCollection![4].text! = response.week.friday.meals[1].title
                    self.fLLink = response.week.friday.meals[1].sourceURL
                    self.lunchCollection![5].text! = response.week.saturday.meals[1].title
                    self.sLLink = response.week.saturday.meals[1].sourceURL
                    self.lunchCollection![6].text! = response.week.sunday.meals[1].title
                    self.suLLink = response.week.sunday.meals[1].sourceURL
                    
                    self.dinnerCollection![0].text! = response.week.monday.meals[2].title
                    self.mDLink = response.week.monday.meals[2].sourceURL
                    self.dinnerCollection![1].text! = response.week.tuesday.meals[2].title
                    self.tDLink = response.week.tuesday.meals[2].sourceURL
                    self.dinnerCollection![2].text! = response.week.wednesday.meals[2].title
                    self.wDLink = response.week.wednesday.meals[2].sourceURL
                    self.dinnerCollection![3].text! = response.week.thursday.meals[2].title
                    self.thDLink = response.week.thursday.meals[2].sourceURL
                    self.dinnerCollection![4].text! = response.week.friday.meals[2].title
                    self.fDLink = response.week.friday.meals[2].sourceURL
                    self.dinnerCollection![5].text! = response.week.saturday.meals[2].title
                    self.sDLink = response.week.saturday.meals[2].sourceURL
                    self.dinnerCollection![6].text! = response.week.sunday.meals[2].title
                    self.suDLink = response.week.sunday.meals[2].sourceURL
                }
            }, url: newApiUrl)
            
        }
        if initialWeight > targetWeight {
            randomCalorieAssignment = Int.random(in: 800...1400)
            currentCalorieLabel.text = "Current daily calorie: \(randomCalorieAssignment)"
            let newApiUrl = "\(apiUrl)\(String(randomCalorieAssignment))&diet=\(dietPreference)"
            generateWeeklyMeal.fetchPostData(completionHandler: { (response) in
                DispatchQueue.main.async {
                    self.breakfastCollection![0].text! = response.week.monday.meals[0].title
                    self.mBfLink = response.week.monday.meals[0].sourceURL
                    self.breakfastCollection![1].text! = response.week.tuesday.meals[0].title
                    self.tBfLink = response.week.tuesday.meals[0].sourceURL
                    self.breakfastCollection![2].text! = response.week.wednesday.meals[0].title
                    self.wBfLink = response.week.wednesday.meals[0].sourceURL
                    self.breakfastCollection![3].text! = response.week.thursday.meals[0].title
                    self.thBfLink = response.week.thursday.meals[0].sourceURL
                    self.breakfastCollection![4].text! = response.week.friday.meals[0].title
                    self.fBfLink = response.week.friday.meals[0].sourceURL
                    self.breakfastCollection![5].text! = response.week.saturday.meals[0].title
                    self.sBfLink = response.week.saturday.meals[0].sourceURL
                    self.breakfastCollection![6].text! = response.week.sunday.meals[0].title
                    self.suBfLink = response.week.sunday.meals[0].sourceURL
                    
                    self.lunchCollection![0].text! = response.week.monday.meals[1].title
                    self.mLLink = response.week.monday.meals[1].sourceURL
                    self.lunchCollection![1].text! = response.week.tuesday.meals[1].title
                    self.tLLink = response.week.tuesday.meals[1].sourceURL
                    self.lunchCollection![2].text! = response.week.wednesday.meals[1].title
                    self.wLLink = response.week.wednesday.meals[1].sourceURL
                    self.lunchCollection![3].text! = response.week.thursday.meals[1].title
                    self.thLLink = response.week.thursday.meals[1].sourceURL
                    self.lunchCollection![4].text! = response.week.friday.meals[1].title
                    self.fLLink = response.week.friday.meals[1].sourceURL
                    self.lunchCollection![5].text! = response.week.saturday.meals[1].title
                    self.sLLink = response.week.saturday.meals[1].sourceURL
                    self.lunchCollection![6].text! = response.week.sunday.meals[1].title
                    self.suLLink = response.week.sunday.meals[1].sourceURL
                    
                    self.dinnerCollection![0].text! = response.week.monday.meals[2].title
                    self.mDLink = response.week.monday.meals[2].sourceURL
                    self.dinnerCollection![1].text! = response.week.tuesday.meals[2].title
                    self.tDLink = response.week.tuesday.meals[2].sourceURL
                    self.dinnerCollection![2].text! = response.week.wednesday.meals[2].title
                    self.wDLink = response.week.wednesday.meals[2].sourceURL
                    self.dinnerCollection![3].text! = response.week.thursday.meals[2].title
                    self.thDLink = response.week.thursday.meals[2].sourceURL
                    self.dinnerCollection![4].text! = response.week.friday.meals[2].title
                    self.fDLink = response.week.friday.meals[2].sourceURL
                    self.dinnerCollection![5].text! = response.week.saturday.meals[2].title
                    self.sDLink = response.week.saturday.meals[2].sourceURL
                    self.dinnerCollection![6].text! = response.week.sunday.meals[2].title
                    self.suDLink = response.week.sunday.meals[2].sourceURL
                }
            }, url: newApiUrl)
            
            
        }
        
        
        
    }
    
    
    
    @IBAction func customPlanPressed(_ sender: UIButton) {
        
        loadInitialWeight()
        loadTargetWeight()
        let recipeExclusion = recipeToExcludeTextField.text!
        var randomCalorieAssignment = 0
        let initialWeight = Int(accessToInitialWeight![0].weight)
        let targetWeight = Int(accessToTargetWeight![0].targetWeight)
        
        if initialWeight <= targetWeight {
            randomCalorieAssignment = Int.random(in: 2500...3500)
            if Double(initialWeight) == Double(targetWeight){
                randomCalorieAssignment = Int.random(in: 1800...2200)
                titleLabel.text = "Weekly meal routine (maintain)"
            }
            currentCalorieLabel.text = "Current daily calorie: \(randomCalorieAssignment)"
            let newApiUrl = "\(apiUrl)\(String(randomCalorieAssignment))&exclude=\(recipeExclusion)"
            generateWeeklyMeal.fetchPostData(completionHandler: { (response) in
                DispatchQueue.main.async {
                    self.breakfastCollection![0].text! = response.week.monday.meals[0].title
                    self.mBfLink = response.week.monday.meals[0].sourceURL
                    self.breakfastCollection![1].text! = response.week.tuesday.meals[0].title
                    self.tBfLink = response.week.tuesday.meals[0].sourceURL
                    self.breakfastCollection![2].text! = response.week.wednesday.meals[0].title
                    self.wBfLink = response.week.wednesday.meals[0].sourceURL
                    self.breakfastCollection![3].text! = response.week.thursday.meals[0].title
                    self.thBfLink = response.week.thursday.meals[0].sourceURL
                    self.breakfastCollection![4].text! = response.week.friday.meals[0].title
                    self.fBfLink = response.week.friday.meals[0].sourceURL
                    self.breakfastCollection![5].text! = response.week.saturday.meals[0].title
                    self.sBfLink = response.week.saturday.meals[0].sourceURL
                    self.breakfastCollection![6].text! = response.week.sunday.meals[0].title
                    self.suBfLink = response.week.sunday.meals[0].sourceURL
                    
                    self.lunchCollection![0].text! = response.week.monday.meals[1].title
                    self.mLLink = response.week.monday.meals[1].sourceURL
                    self.lunchCollection![1].text! = response.week.tuesday.meals[1].title
                    self.tLLink = response.week.tuesday.meals[1].sourceURL
                    self.lunchCollection![2].text! = response.week.wednesday.meals[1].title
                    self.wLLink = response.week.wednesday.meals[1].sourceURL
                    self.lunchCollection![3].text! = response.week.thursday.meals[1].title
                    self.thLLink = response.week.thursday.meals[1].sourceURL
                    self.lunchCollection![4].text! = response.week.friday.meals[1].title
                    self.fLLink = response.week.friday.meals[1].sourceURL
                    self.lunchCollection![5].text! = response.week.saturday.meals[1].title
                    self.sLLink = response.week.saturday.meals[1].sourceURL
                    self.lunchCollection![6].text! = response.week.sunday.meals[1].title
                    self.suLLink = response.week.sunday.meals[1].sourceURL
                    
                    self.dinnerCollection![0].text! = response.week.monday.meals[2].title
                    self.mDLink = response.week.monday.meals[2].sourceURL
                    self.dinnerCollection![1].text! = response.week.tuesday.meals[2].title
                    self.tDLink = response.week.tuesday.meals[2].sourceURL
                    self.dinnerCollection![2].text! = response.week.wednesday.meals[2].title
                    self.wDLink = response.week.wednesday.meals[2].sourceURL
                    self.dinnerCollection![3].text! = response.week.thursday.meals[2].title
                    self.thDLink = response.week.thursday.meals[2].sourceURL
                    self.dinnerCollection![4].text! = response.week.friday.meals[2].title
                    self.fDLink = response.week.friday.meals[2].sourceURL
                    self.dinnerCollection![5].text! = response.week.saturday.meals[2].title
                    self.sDLink = response.week.saturday.meals[2].sourceURL
                    self.dinnerCollection![6].text! = response.week.sunday.meals[2].title
                    self.suDLink = response.week.sunday.meals[2].sourceURL
                }
            }, url: newApiUrl)
            
        }
        if initialWeight > targetWeight {
            randomCalorieAssignment = Int.random(in: 800...1400)
            currentCalorieLabel.text = "Current daily calorie: \(randomCalorieAssignment)"
            let newApiUrl = "\(apiUrl)\(String(randomCalorieAssignment))&exclude=\(recipeExclusion)"
            generateWeeklyMeal.fetchPostData(completionHandler: { (response) in
                DispatchQueue.main.async {
                    self.breakfastCollection![0].text! = response.week.monday.meals[0].title
                    self.mBfLink = response.week.monday.meals[0].sourceURL
                    self.breakfastCollection![1].text! = response.week.tuesday.meals[0].title
                    self.tBfLink = response.week.tuesday.meals[0].sourceURL
                    self.breakfastCollection![2].text! = response.week.wednesday.meals[0].title
                    self.wBfLink = response.week.wednesday.meals[0].sourceURL
                    self.breakfastCollection![3].text! = response.week.thursday.meals[0].title
                    self.thBfLink = response.week.thursday.meals[0].sourceURL
                    self.breakfastCollection![4].text! = response.week.friday.meals[0].title
                    self.fBfLink = response.week.friday.meals[0].sourceURL
                    self.breakfastCollection![5].text! = response.week.saturday.meals[0].title
                    self.sBfLink = response.week.saturday.meals[0].sourceURL
                    self.breakfastCollection![6].text! = response.week.sunday.meals[0].title
                    self.suBfLink = response.week.sunday.meals[0].sourceURL
                    
                    self.lunchCollection![0].text! = response.week.monday.meals[1].title
                    self.mLLink = response.week.monday.meals[1].sourceURL
                    self.lunchCollection![1].text! = response.week.tuesday.meals[1].title
                    self.tLLink = response.week.tuesday.meals[1].sourceURL
                    self.lunchCollection![2].text! = response.week.wednesday.meals[1].title
                    self.wLLink = response.week.wednesday.meals[1].sourceURL
                    self.lunchCollection![3].text! = response.week.thursday.meals[1].title
                    self.thLLink = response.week.thursday.meals[1].sourceURL
                    self.lunchCollection![4].text! = response.week.friday.meals[1].title
                    self.fLLink = response.week.friday.meals[1].sourceURL
                    self.lunchCollection![5].text! = response.week.saturday.meals[1].title
                    self.sLLink = response.week.saturday.meals[1].sourceURL
                    self.lunchCollection![6].text! = response.week.sunday.meals[1].title
                    self.suLLink = response.week.sunday.meals[1].sourceURL
                    
                    self.dinnerCollection![0].text! = response.week.monday.meals[2].title
                    self.mDLink = response.week.monday.meals[2].sourceURL
                    self.dinnerCollection![1].text! = response.week.tuesday.meals[2].title
                    self.tDLink = response.week.tuesday.meals[2].sourceURL
                    self.dinnerCollection![2].text! = response.week.wednesday.meals[2].title
                    self.wDLink = response.week.wednesday.meals[2].sourceURL
                    self.dinnerCollection![3].text! = response.week.thursday.meals[2].title
                    self.thDLink = response.week.thursday.meals[2].sourceURL
                    self.dinnerCollection![4].text! = response.week.friday.meals[2].title
                    self.fDLink = response.week.friday.meals[2].sourceURL
                    self.dinnerCollection![5].text! = response.week.saturday.meals[2].title
                    self.sDLink = response.week.saturday.meals[2].sourceURL
                    self.dinnerCollection![6].text! = response.week.sunday.meals[2].title
                    self.suDLink = response.week.sunday.meals[2].sourceURL
                }
            }, url: newApiUrl)
            
            
        }
        
        
    }
    
    
    @IBAction func comboPlanPressed(_ sender: UIButton) {
        
        loadInitialWeight()
        loadTargetWeight()
        let diet = dietTextField.text!
        let recipeExclusion = recipeToExcludeTextField.text!
        var randomCalorieAssignment = 0
        let initialWeight = Int(accessToInitialWeight![0].weight)
        let targetWeight = Int(accessToTargetWeight![0].targetWeight)
        
        if initialWeight <= targetWeight {
            randomCalorieAssignment = Int.random(in: 2500...3500)
            if Double(initialWeight) == Double(targetWeight){
                randomCalorieAssignment = Int.random(in: 1800...2200)
                titleLabel.text = "Weekly meal routine (maintain)"
            }
            currentCalorieLabel.text = "Current daily calorie: \(randomCalorieAssignment)"
            let newApiUrl = "\(apiUrl)\(String(randomCalorieAssignment))&exclude=\(recipeExclusion)&diet=\(diet)"
            generateWeeklyMeal.fetchPostData(completionHandler: { (response) in
                DispatchQueue.main.async {
                    self.breakfastCollection![0].text! = response.week.monday.meals[0].title
                    self.mBfLink = response.week.monday.meals[0].sourceURL
                    self.breakfastCollection![1].text! = response.week.tuesday.meals[0].title
                    self.tBfLink = response.week.tuesday.meals[0].sourceURL
                    self.breakfastCollection![2].text! = response.week.wednesday.meals[0].title
                    self.wBfLink = response.week.wednesday.meals[0].sourceURL
                    self.breakfastCollection![3].text! = response.week.thursday.meals[0].title
                    self.thBfLink = response.week.thursday.meals[0].sourceURL
                    self.breakfastCollection![4].text! = response.week.friday.meals[0].title
                    self.fBfLink = response.week.friday.meals[0].sourceURL
                    self.breakfastCollection![5].text! = response.week.saturday.meals[0].title
                    self.sBfLink = response.week.saturday.meals[0].sourceURL
                    self.breakfastCollection![6].text! = response.week.sunday.meals[0].title
                    self.suBfLink = response.week.sunday.meals[0].sourceURL
                    
                    self.lunchCollection![0].text! = response.week.monday.meals[1].title
                    self.mLLink = response.week.monday.meals[1].sourceURL
                    self.lunchCollection![1].text! = response.week.tuesday.meals[1].title
                    self.tLLink = response.week.tuesday.meals[1].sourceURL
                    self.lunchCollection![2].text! = response.week.wednesday.meals[1].title
                    self.wLLink = response.week.wednesday.meals[1].sourceURL
                    self.lunchCollection![3].text! = response.week.thursday.meals[1].title
                    self.thLLink = response.week.thursday.meals[1].sourceURL
                    self.lunchCollection![4].text! = response.week.friday.meals[1].title
                    self.fLLink = response.week.friday.meals[1].sourceURL
                    self.lunchCollection![5].text! = response.week.saturday.meals[1].title
                    self.sLLink = response.week.saturday.meals[1].sourceURL
                    self.lunchCollection![6].text! = response.week.sunday.meals[1].title
                    self.suLLink = response.week.sunday.meals[1].sourceURL
                    
                    self.dinnerCollection![0].text! = response.week.monday.meals[2].title
                    self.mDLink = response.week.monday.meals[2].sourceURL
                    self.dinnerCollection![1].text! = response.week.tuesday.meals[2].title
                    self.tDLink = response.week.tuesday.meals[2].sourceURL
                    self.dinnerCollection![2].text! = response.week.wednesday.meals[2].title
                    self.wDLink = response.week.wednesday.meals[2].sourceURL
                    self.dinnerCollection![3].text! = response.week.thursday.meals[2].title
                    self.thDLink = response.week.thursday.meals[2].sourceURL
                    self.dinnerCollection![4].text! = response.week.friday.meals[2].title
                    self.fDLink = response.week.friday.meals[2].sourceURL
                    self.dinnerCollection![5].text! = response.week.saturday.meals[2].title
                    self.sDLink = response.week.saturday.meals[2].sourceURL
                    self.dinnerCollection![6].text! = response.week.sunday.meals[2].title
                    self.suDLink = response.week.sunday.meals[2].sourceURL
                }
            }, url: newApiUrl)
            
        }
        if initialWeight > targetWeight {
            randomCalorieAssignment = Int.random(in: 800...1400)
            currentCalorieLabel.text = "Current daily calorie: \(randomCalorieAssignment)"
            let newApiUrl = "\(apiUrl)\(String(randomCalorieAssignment))&exclude=\(recipeExclusion)&diet=\(diet)"
            generateWeeklyMeal.fetchPostData(completionHandler: { (response) in
                DispatchQueue.main.async {
                    self.breakfastCollection![0].text! = response.week.monday.meals[0].title
                    self.mBfLink = response.week.monday.meals[0].sourceURL
                    self.breakfastCollection![1].text! = response.week.tuesday.meals[0].title
                    self.tBfLink = response.week.tuesday.meals[0].sourceURL
                    self.breakfastCollection![2].text! = response.week.wednesday.meals[0].title
                    self.wBfLink = response.week.wednesday.meals[0].sourceURL
                    self.breakfastCollection![3].text! = response.week.thursday.meals[0].title
                    self.thBfLink = response.week.thursday.meals[0].sourceURL
                    self.breakfastCollection![4].text! = response.week.friday.meals[0].title
                    self.fBfLink = response.week.friday.meals[0].sourceURL
                    self.breakfastCollection![5].text! = response.week.saturday.meals[0].title
                    self.sBfLink = response.week.saturday.meals[0].sourceURL
                    self.breakfastCollection![6].text! = response.week.sunday.meals[0].title
                    self.suBfLink = response.week.sunday.meals[0].sourceURL
                    
                    self.lunchCollection![0].text! = response.week.monday.meals[1].title
                    self.mLLink = response.week.monday.meals[1].sourceURL
                    self.lunchCollection![1].text! = response.week.tuesday.meals[1].title
                    self.tLLink = response.week.tuesday.meals[1].sourceURL
                    self.lunchCollection![2].text! = response.week.wednesday.meals[1].title
                    self.wLLink = response.week.wednesday.meals[1].sourceURL
                    self.lunchCollection![3].text! = response.week.thursday.meals[1].title
                    self.thLLink = response.week.thursday.meals[1].sourceURL
                    self.lunchCollection![4].text! = response.week.friday.meals[1].title
                    self.fLLink = response.week.friday.meals[1].sourceURL
                    self.lunchCollection![5].text! = response.week.saturday.meals[1].title
                    self.sLLink = response.week.saturday.meals[1].sourceURL
                    self.lunchCollection![6].text! = response.week.sunday.meals[1].title
                    self.suLLink = response.week.sunday.meals[1].sourceURL
                    
                    self.dinnerCollection![0].text! = response.week.monday.meals[2].title
                    self.mDLink = response.week.monday.meals[2].sourceURL
                    self.dinnerCollection![1].text! = response.week.tuesday.meals[2].title
                    self.tDLink = response.week.tuesday.meals[2].sourceURL
                    self.dinnerCollection![2].text! = response.week.wednesday.meals[2].title
                    self.wDLink = response.week.wednesday.meals[2].sourceURL
                    self.dinnerCollection![3].text! = response.week.thursday.meals[2].title
                    self.thDLink = response.week.thursday.meals[2].sourceURL
                    self.dinnerCollection![4].text! = response.week.friday.meals[2].title
                    self.fDLink = response.week.friday.meals[2].sourceURL
                    self.dinnerCollection![5].text! = response.week.saturday.meals[2].title
                    self.sDLink = response.week.saturday.meals[2].sourceURL
                    self.dinnerCollection![6].text! = response.week.sunday.meals[2].title
                    self.suDLink = response.week.sunday.meals[2].sourceURL
                }
            }, url: newApiUrl)
            
            
        }
        
        
    }
    
    
    
    //MARK: - UILabel link handlers
    
    
    
    @objc func openMBfLink (sender: UIGestureRecognizer){
        UIApplication.shared.open(URL(string: mBfLink)!, options: [:], completionHandler: nil)
    }
    @objc func openTBfLink (sender: UIGestureRecognizer){
        UIApplication.shared.open(URL(string: tBfLink)!, options: [:], completionHandler: nil)
    }
    @objc func openWBfLink (sender: UIGestureRecognizer){
        UIApplication.shared.open(URL(string: wBfLink)!, options: [:], completionHandler: nil)
    }
    @objc func openThBfLink (sender: UIGestureRecognizer){
        UIApplication.shared.open(URL(string: thBfLink)!, options: [:], completionHandler: nil)
    }
    @objc func openFBfLink (sender: UIGestureRecognizer){
        UIApplication.shared.open(URL(string: fBfLink)!, options: [:], completionHandler: nil)
    }
    @objc func openSBfLink (sender: UIGestureRecognizer){
        UIApplication.shared.open(URL(string: sBfLink)!, options: [:], completionHandler: nil)
    }
    @objc func openSuBfLink (sender: UIGestureRecognizer){
        UIApplication.shared.open(URL(string: suBfLink)!, options: [:], completionHandler: nil)
    }
    
    
    
    @objc func openMLLink (sender: UIGestureRecognizer){
        UIApplication.shared.open(URL(string: mLLink)!, options: [:], completionHandler: nil)
    }
    @objc func openTLLink (sender: UIGestureRecognizer){
        UIApplication.shared.open(URL(string: tLLink)!, options: [:], completionHandler: nil)
    }
    @objc func openWLLink (sender: UIGestureRecognizer){
        UIApplication.shared.open(URL(string: wLLink)!, options: [:], completionHandler: nil)
    }
    @objc func openThLLink (sender: UIGestureRecognizer){
        UIApplication.shared.open(URL(string: thLLink)!, options: [:], completionHandler: nil)
    }
    @objc func openFLLink (sender: UIGestureRecognizer){
        UIApplication.shared.open(URL(string: fLLink)!, options: [:], completionHandler: nil)
    }
    @objc func openSLLink (sender: UIGestureRecognizer){
        UIApplication.shared.open(URL(string: sLLink)!, options: [:], completionHandler: nil)
    }
    @objc func openSuLLink (sender: UIGestureRecognizer){
        UIApplication.shared.open(URL(string: suLLink)!, options: [:], completionHandler: nil)
    }
    
    
    
    
    @objc func openMDLink (sender: UIGestureRecognizer){
        UIApplication.shared.open(URL(string: mDLink)!, options: [:], completionHandler: nil)
    }
    @objc func openTDLink (sender: UIGestureRecognizer){
        UIApplication.shared.open(URL(string: tDLink)!, options: [:], completionHandler: nil)
    }
    @objc func openWDLink (sender: UIGestureRecognizer){
        UIApplication.shared.open(URL(string: wDLink)!, options: [:], completionHandler: nil)
    }
    @objc func openThDLink (sender: UIGestureRecognizer){
        UIApplication.shared.open(URL(string: thDLink)!, options: [:], completionHandler: nil)
    }
    @objc func openFDLink (sender: UIGestureRecognizer){
        UIApplication.shared.open(URL(string: fDLink)!, options: [:], completionHandler: nil)
    }
    @objc func openSDLink (sender: UIGestureRecognizer){
        UIApplication.shared.open(URL(string: sDLink)!, options: [:], completionHandler: nil)
    }
    @objc func openSuDLink (sender: UIGestureRecognizer){
        UIApplication.shared.open(URL(string: suDLink)!, options: [:], completionHandler: nil)
    }
    
    
    
    
    
    
    @IBAction func todaysSpecialButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toTodaysSpecial", sender: self)
    }
    
    @IBAction func saveMealPressed(_ sender: UIButton) {
        
        let mealPlan = WeeklyMealStored()
        
        mealPlan.calorie = currentCalorieLabel.text!
        
        mealPlan.mBf = breakfastCollection[0].text!
        mealPlan.mBfUrl = mBfLink
        
        mealPlan.tBf = breakfastCollection[1].text!
        mealPlan.tBfUrl = tBfLink
        
        mealPlan.wBf = breakfastCollection[2].text!
        mealPlan.wBfUrl = wBfLink
        
        mealPlan.thBf = breakfastCollection[3].text!
        mealPlan.thBfUrl = thBfLink
        
        mealPlan.fBf = breakfastCollection[4].text!
        mealPlan.fBfUrl = fBfLink
        
        mealPlan.sBf = breakfastCollection[5].text!
        mealPlan.sBfUrl = sBfLink
        
        mealPlan.suBf = breakfastCollection[6].text!
        mealPlan.suBfUrl = suBfLink
        
        
        
        mealPlan.mL = lunchCollection[0].text!
        mealPlan.mLUrl = mLLink
        
        mealPlan.tL = lunchCollection[1].text!
        mealPlan.tLUrl = tLLink
        
        mealPlan.wL = lunchCollection[2].text!
        mealPlan.wLUrl = wLLink
        
        mealPlan.thL = lunchCollection[3].text!
        mealPlan.thLUrl = thLLink
        
        mealPlan.fL = lunchCollection[4].text!
        mealPlan.fLUrl = fLLink
        
        mealPlan.sL = lunchCollection[5].text!
        mealPlan.sLUrl = sLLink
        
        mealPlan.suL = lunchCollection[6].text!
        mealPlan.suLUrl = suLLink
        
        
        
        mealPlan.mD = dinnerCollection[0].text!
        mealPlan.mDUrl = mDLink
        
        mealPlan.tD = dinnerCollection[1].text!
        mealPlan.tDUrl = tDLink
        
        mealPlan.wD = dinnerCollection[2].text!
        mealPlan.wDUrl = wDLink
        
        mealPlan.thD = dinnerCollection[3].text!
        mealPlan.thDUrl = thDLink
        
        mealPlan.fD = dinnerCollection[4].text!
        mealPlan.fDUrl = fDLink
        
        mealPlan.sD = dinnerCollection[5].text!
        mealPlan.sDUrl = sDLink
        
        mealPlan.suD = dinnerCollection[6].text!
        mealPlan.suDUrl = suDLink
        
        if accessToWeeklyMealStored!.count == 0 {
            if let realm = try? Realm(){
                try! realm.write{
                    realm.add(mealPlan)
                }
            }
        }else{
            let realm = try! Realm()
            let updatedPlan = realm.objects(WeeklyMealStored.self).last
            try! realm.write{
                updatedPlan?.calorie = mealPlan.calorie
                updatedPlan?.mBf = mealPlan.mBf
                updatedPlan?.mBfUrl = mealPlan.mBfUrl
                
                updatedPlan?.tBf = mealPlan.tBf
                updatedPlan?.tBfUrl = mealPlan.tBfUrl
                
                updatedPlan?.wBf = mealPlan.wBf
                updatedPlan?.wBfUrl = mealPlan.wBfUrl
                
                updatedPlan?.thBf = mealPlan.thBf
                updatedPlan?.thBfUrl = mealPlan.thBfUrl
                
                updatedPlan?.fBf = mealPlan.fBf
                updatedPlan?.fBfUrl = mealPlan.fBfUrl
                
                updatedPlan?.sBf = mealPlan.sBf
                updatedPlan?.sBfUrl = mealPlan.sBfUrl
                
                updatedPlan?.suBf = mealPlan.suBf
                updatedPlan?.suBfUrl = mealPlan.suBfUrl
                
                updatedPlan?.mL = mealPlan.mL
                updatedPlan?.mLUrl = mealPlan.mLUrl
                
                updatedPlan?.tL = mealPlan.tL
                updatedPlan?.tLUrl = mealPlan.tLUrl
                
                updatedPlan?.wL = mealPlan.wL
                updatedPlan?.wLUrl = mealPlan.wLUrl
                
                updatedPlan?.thL = mealPlan.thL
                updatedPlan?.thLUrl = mealPlan.thLUrl
                
                updatedPlan?.fL = mealPlan.fL
                updatedPlan?.fLUrl = mealPlan.fLUrl
                
                updatedPlan?.sL = mealPlan.sL
                updatedPlan?.sLUrl = mealPlan.sLUrl
                
                updatedPlan?.suL = mealPlan.suL
                updatedPlan?.suLUrl = mealPlan.suLUrl
                
                updatedPlan?.mD = mealPlan.mD
                updatedPlan?.mDUrl = mealPlan.mDUrl
                
                updatedPlan?.tD = mealPlan.tD
                updatedPlan?.tDUrl = mealPlan.tDUrl
                
                updatedPlan?.wD = mealPlan.wD
                updatedPlan?.wDUrl = mealPlan.wDUrl
                
                updatedPlan?.thD = mealPlan.thD
                updatedPlan?.thDUrl = mealPlan.thDUrl
                
                updatedPlan?.fD = mealPlan.fD
                updatedPlan?.fDUrl = mealPlan.fDUrl
                
                updatedPlan?.sD = mealPlan.sD
                updatedPlan?.sDUrl = mealPlan.sDUrl
                
                updatedPlan?.suD = mealPlan.suD
                updatedPlan?.suDUrl = mealPlan.suDUrl
            }
        }
        
    }
    
    
    func loadStoredWeeklyPlan(){
        if let realm = try? Realm(){
            accessToWeeklyMealStored = realm.objects(WeeklyMealStored.self)
        }
    }
}

