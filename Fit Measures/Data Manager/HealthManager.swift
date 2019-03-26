 
 import UIKit
 import HealthKit
 
 class HealthManager {
    
    
    private enum HealthkitSetupError: Error {
        case notAvailableOnDevice
        case dataTypeNotAvailable
    }
    class func authorizeHealthKit(completion: @escaping (Bool, Error?) -> Swift.Void) {
        
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, HealthkitSetupError.notAvailableOnDevice)
            return
        }
        
        if HKHealthStore.isHealthDataAvailable() {
            guard //WRITE
                let bodyFatPercentage = HKSampleType.quantityType(forIdentifier: .bodyFatPercentage),
                let bodyMass = HKSampleType.quantityType(forIdentifier: .bodyMass),
                let leanBodyMass = HKSampleType.quantityType(forIdentifier: .leanBodyMass),
                let waistCircumference = HKSampleType.quantityType(forIdentifier: .waistCircumference),
                //READ
                let dateOfBirth = HKObjectType.characteristicType(forIdentifier: .dateOfBirth),
                let height = HKObjectType.quantityType(forIdentifier: .height),
                let biologicalSex = HKObjectType.characteristicType(forIdentifier: .biologicalSex)
                else {
                    
                    completion(false, HealthkitSetupError.dataTypeNotAvailable)
                    return
            }
            
            
            let shareSet = Set<HKSampleType>([bodyFatPercentage,bodyMass,leanBodyMass,waistCircumference])
            
            let read = Set<HKObjectType>([dateOfBirth,height,biologicalSex])
            
            HKHealthStore().requestAuthorization(toShare: shareSet,
                                                 read: read) { (success, error) in
                                                    completion(success, error)
//                                                    if (success) {
//                                                        print("OK DATO PERMESSO")
//                                                    } else {
//                                                        print("NO PERMESSO")
//                                                        if let e = error {
//                                                            print(e)
//                                                        }
//                                                    }
            }
            
            
        }
        
    }
    
    class func saveBodyMassIndexSample(bodyMassIndex: Double, date: Date) {
        //1.  Make sure the body mass type exists
        guard let bodyMassIndexType = HKQuantityType.quantityType(forIdentifier: .bodyMassIndex) else {
            fatalError("Body Mass Index Type is no longer available in HealthKit")
        }
        
        //2.  Use the Count HKUnit to create a body mass quantity
        let bodyMassQuantity = HKQuantity(unit: HKUnit.count(),
                                          doubleValue: bodyMassIndex)
        let bodyMassIndexSample = HKQuantitySample(type: bodyMassIndexType,
                                                   quantity: bodyMassQuantity,
                                                   start: date,
                                                   end: date)
        
        //3.  Save the same to HealthKit
        HKHealthStore().save(bodyMassIndexSample) { (success, error) in
            if let error = error {
                print("Error Saving BMI Sample: \(error.localizedDescription)")
            } else {
                print("Successfully saved BMI Sample")
            }
        }
    }
    
    class func addToHealthKit(DataToSave: HKQuantityTypeIdentifier, unitMeasure: HKQuantity,date : Date, closure: @escaping ()->()) {
        guard let hkqt = HKQuantityType.quantityType(forIdentifier: DataToSave) else {  return }
        let dataToSave = HKQuantitySample(type: hkqt, quantity: unitMeasure, start: date, end: date)
        HKHealthStore().save(dataToSave) { (success, error) in
            if success {
                closure()
            } else {
                print(error!)
            }
        }
    }
    
    
 }
 
class ProfileDataStore {
    class func getAgeSexAndBloodType() throws -> (age: Int,
        biologicalSex: HKBiologicalSex ) {
            
            let healthKitStore = HKHealthStore()
            
            do {
                //1. This method throws an error if these data are not available.
                let biologicalSex = try healthKitStore.biologicalSex()
                let birthdayComponents =  try healthKitStore.dateOfBirthComponents()
                
                
                
                //2. Use Calendar to calculate age.
                let today = Date()
                let calendar = Calendar.current
                let todayDateComponents = calendar.dateComponents([.year],
                                                                  from: today)
                let thisYear = todayDateComponents.year!
                let age = thisYear - birthdayComponents.year!
                
                //3. Unwrap the wrappers to get the underlying enum values.
                let unwrappedBiologicalSex = biologicalSex.biologicalSex 
                return (age, unwrappedBiologicalSex)
            }
    }
    
    
    class func getMostRecentSample(for sampleType: HKSampleType,
                                   completion: @escaping (HKQuantitySample?, Error?) -> Swift.Void) {
        
        //1. Use HKQuery to load the most recent samples.
        let mostRecentPredicate = HKQuery.predicateForSamples(withStart: Date.distantPast,
                                                              end: Date(),
                                                              options: .strictEndDate)
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate,
                                              ascending: false)
        
        let limit = 1
        
        let sampleQuery = HKSampleQuery(sampleType: sampleType,
                                        predicate: mostRecentPredicate,
                                        limit: limit,
                                        sortDescriptors: [sortDescriptor]) { (query, samples, error) in
                                            
                                            //2. Always dispatch to the main thread when complete.
                                            DispatchQueue.main.async {
                                                
                                                guard let samples = samples,
                                                    let mostRecentSample = samples.first as? HKQuantitySample else {
                                                        
                                                        completion(nil, error)
                                                        return
                                                }
                                                
                                                completion(mostRecentSample, nil)
                                            }
        }
        
        HKHealthStore().execute(sampleQuery)
    }
 }
 class UserHealthProfile {
    
    var age: Int?
    var biologicalSex: HKBiologicalSex?
    var bloodType: HKBloodType?
    var heightInMeters: Double?
    var weightInKilograms: Double?
    
    var bodyMassIndex: Double? {
        
        guard let weightInKilograms = weightInKilograms,
            let heightInMeters = heightInMeters,
            heightInMeters > 0 else {
                return nil
        }
        
        return (weightInKilograms/(heightInMeters*heightInMeters))
    }
 }
