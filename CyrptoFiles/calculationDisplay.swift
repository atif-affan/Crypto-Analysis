//
//  calculationDisplay.swift
//  CryptoAnalysis
//
//  Created by Affan on 12/31/21.
//

import Foundation
import SwiftUI
import Accelerate


func addUpTotal(inputDict: Dictionary<String, Double>) -> Double{
    
    var totalValue = 0.0
    
    for (key, value) in inputDict {
        print("for loop touchdown")
        
        totalValue = inputDict[key]! + totalValue
          print("here is the total portfolio value", totalValue)
       }
    
    return totalValue
    
}


func addUpCurrent(inputDict: Dictionary<String, String>) -> Double{
    
    
    var totalValue = 0.0
    
    for (key, value) in inputDict {
        print("for loop touchdown")
        
        totalValue = Double(inputDict[key]!)! + totalValue
          print("here is the total portfolio value", totalValue)
       }
    
    return totalValue
    
}

func convertCurrentPrices(inputDict: Dictionary<String, String>) -> Dictionary<String, Double>{
    
    var newDict = [String: Double]()
    for (key, value) in inputDict{
        
        newDict[key] = Double(inputDict[key]!)
        
        
    }
    
    return newDict
    
}


func calculatePerformance(inputCurrent: Dictionary<String, Double>, inputProjected: Dictionary<String, Double>) -> Dictionary<String, Double>{
    
    var percentageDifference = [String: Double]()
    var tempHolderCurrent = 0.0
    var tempHolderProjected = 0.0
    
    for (key, value) in inputCurrent{
        
        tempHolderCurrent = inputCurrent[key] ?? 0.00
        tempHolderProjected = inputProjected[key] ?? 0.00
        
        percentageDifference[key] = ((tempHolderProjected - tempHolderCurrent) / tempHolderCurrent) * 100
        
        //percentageDifference.append(((tempHolderProjected - tempHolderCurrent) / tempHolderCurrent) * 100)
        
    }
    
    
    
    
    
    return percentageDifference
    
}


func weightedCalculation(inputPercentages: Dictionary<String, Double>, inputCurrent: Dictionary<String, Double>, inputProjected: Dictionary<String, Double>) -> Dictionary<String, String>{
    
    var quantityList: [String:String] = defaults.dictionary(forKey: "CurrencyListQuantity") as! [String:String]
    
    var finalWeights = [String: Double]()
    var finalWeightsProfits = [String: Double]()
    var finalDifferences = [String: Double]()
    
    var finalProfitsPercentage = [String: Double]()
    
    var finalGrades = [String: String]()
    
    var totalQuantity = 0.0
    var totalProfit = 0.0
    
    
    for (key, value) in inputPercentages{
        
        totalQuantity = Double(quantityList[key]!)! + totalQuantity
        finalDifferences[key] = inputProjected[key]! - inputCurrent[key]!
        print("quantity", Double(quantityList[key]!)!)
        
    }
    
    print("total quantity", totalQuantity)
    
    for (key, value) in inputPercentages{
     
        finalWeights[key] = (Double(quantityList[key]!)!) / totalQuantity
        
    
    }
    
    for (key, value) in inputPercentages{
     
        finalWeightsProfits[key] = Double(quantityList[key]!)! * finalDifferences[key]!
        totalProfit = finalWeightsProfits[key]! + totalProfit
        
    }
    
    for (key, value) in inputPercentages{
        
        finalProfitsPercentage[key] = finalWeightsProfits[key]! / totalProfit
        
    }
    
    print("here are the final ratios", finalDifferences, finalWeights, finalWeightsProfits, totalProfit, finalProfitsPercentage)
    
    for (key, value) in inputPercentages{
        
        if (finalProfitsPercentage[key] ?? 0.0 > 0.5){
            
            finalGrades[key] = "A"
            
            
        }else{
            
            finalGrades[key] = "C"
        }
        
    }
    
    
    return finalGrades
    
}


struct displayCalculation: View {
    
    @Binding var calculationModal: Bool
    @Binding var regressionPercentage: [String:Double]
    @Binding var currentPrices: [String:String]
    @State var convertedPrices = [String: Double]()
    @State var calculatedPercentages = [String: Double]()
    @State var finalGradesList = [String: String]()
    @State var totalPortfolioValue = 0.0
    @State var currentPortfolioValue = 0.0
    @State var totalPortfolioPercentage = 0.0
    @State var percentageScore = 0.99
    
   
    
    let timer = Timer.publish(every:
                                0.5, on: .main, in: .common).autoconnect()
    

    var body: some View {
        
        VStack {
            
            HStack{
                
                Spacer()
                Button(action: {
                  
                 
                    print("Closed")
                }) {
                    Text("Close")
                    
                }
                
            }
            
            Text("Portfolio Health").font(.title).bold()
            
            loadingDisplay(percentageScore: self.$percentageScore)
            
            Text("Individual Currency Score").font(.headline).padding(.top).onReceive(timer){
                index in
                
                totalPortfolioValue = addUpTotal(inputDict: regressionPercentage)
                currentPortfolioValue = addUpCurrent(inputDict: currentPrices)
                convertedPrices = convertCurrentPrices(inputDict: currentPrices)
                calculatedPercentages = calculatePerformance(inputCurrent: convertedPrices, inputProjected: regressionPercentage)
                
                totalPortfolioPercentage = ((totalPortfolioValue - currentPortfolioValue) / (totalPortfolioValue)) * 100
                percentageScore = totalPortfolioPercentage / 100.0
                finalGradesList = weightedCalculation(inputPercentages: calculatedPercentages, inputCurrent: convertedPrices, inputProjected: regressionPercentage)
            }
            
            ForEach(Array(regressionPercentage.keys.enumerated()), id:\.element) { _, key in
               
                
                RoundedRectangle(cornerRadius: 15, style: .circular)
                    .fill(Color(hue: 0.0, saturation: 0.003, brightness: 0.929))
                          .frame( height: 100).overlay(
                            
                            
                            VStack{
                                Spacer()
                                Text(key.prefix(3)).bold().textCase(.uppercase).font(.headline)
                                Text(finalGradesList[key] ?? "")
                                Spacer()
                            HStack{
                          
                                
                            Spacer()
                                VStack(alignment: .leading){
                                
                                
                            
                                    // Text("Current Value: $\(convertedPrices[key] ?? 0.00, specifier: "%.2f")").frame(alignment: .topLeading)
                            Text("Projected Value: ")
                            Text("Current Value: ")
                              
                            }
                                VStack(alignment: .trailing){
                                
                              
                               
                                Text("$\(regressionPercentage[key]!, specifier: "%.2f")")
                                Text("$\(convertedPrices[key] ?? 0.00, specifier: "%.2f")")
                                
                            }
                              Spacer()
                                
                                
                                RoundedRectangle(cornerRadius: 15, style: .circular)
                                    .fill(Color.blue)
                                    .frame(width: 85, height: 35).overlay(
                            
                                Text("\(calculatedPercentages[key] ?? 0.00, specifier: "%.2f")%")
                                    ).padding(.trailing)
                            }
                                Spacer()
                            }
                            
                           // Text(key.prefix(3) + ": $" + String(self.regressionPercentage[key]!))
                            //Text("\(key.prefix(3))" + "\(regressionPercentage[key]!, specifier: "%.2f")")
                
                )
                }
        
            
            Text("Overall Portfolio Score").font(.headline).padding(.top)
            
            RoundedRectangle(cornerRadius: 15, style: .circular)
                .fill(Color(hue: 0.0, saturation: 0.003, brightness: 0.929))
                      .frame( height: 75).overlay(
                       
                        HStack{
                       
                        Spacer()
                            VStack(alignment: .leading){
                            
                            
                        
                                // Text("Current Value: $\(convertedPrices[key] ?? 0.00, specifier: "%.2f")").frame(alignment: .topLeading)
                        Text("Projected Value: ")
                        Text("Current Value: ")
                          
                        }
                            VStack(alignment: .trailing){
                            
                          
                           
                            Text("$\(currentPortfolioValue ?? 0.00, specifier: "%.2f")")
                            Text("$\(totalPortfolioValue, specifier: "%.2f")")
                            
                        }
                          Spacer()
                            
                            RoundedRectangle(cornerRadius: 15, style: .circular)
                                .fill(Color.blue)
                                .frame(width: 85, height: 35).overlay(
                        
                            Text("\(totalPortfolioPercentage, specifier: "%.2f")%")
                                ).padding(.trailing)
                            
                        }
            )
            
            
            Spacer()
        }.padding()
            
    }
}


func determineGradeLetter(inputPercentage: Double) -> String{
    
    var returnGrade = ""
    print("input Percentage", inputPercentage*100)
    
    var inputPercentageUpdated = inputPercentage * 100
    
    if (inputPercentageUpdated > 0.0 && inputPercentageUpdated < 5.0){
        
        returnGrade = "F"
        
    }
    
    if (inputPercentageUpdated > 5.0 && inputPercentageUpdated < 15.0){
        returnGrade = "B"
        
    }
    
    if (inputPercentageUpdated > 15.0 && inputPercentageUpdated < 25.0){
    
        returnGrade = "A-"
    }
    
    
    return returnGrade
}

struct loadingDisplay: View {
 
    @State private var isLoading = false
    @State var loadingCounter: Int = 0
    @Binding var percentageScore: Double
    @State var gradeScore: String = ""
    let timer = Timer.publish(every:
                                0.5, on: .main, in: .common).autoconnect()
    
    
    
    var body: some View {
        ZStack {
 
            Circle()
                .stroke(Color(.systemGray5), lineWidth: 14)
                .frame(width: 100, height: 100)
            
            Text(gradeScore).bold().onReceive(timer){
                index in
                
                gradeScore = determineGradeLetter(inputPercentage: percentageScore)
                
            }
 
            Circle()
                .trim(from: percentageScore, to: 0.75)
                .stroke(Color.green, lineWidth: 7)
                .frame(width: 100, height: 100)
                .rotationEffect(Angle(degrees: isLoading ? 360 : 0))
                
                .onAppear() {
                    self.isLoading = true
             
                    
            }
        }
    }
}
