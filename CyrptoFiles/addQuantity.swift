//
//  addQuantity.swift
//  CryptoAnalysis
//
//  Created by Affan on 12/29/21.
//

import Foundation
import SwiftUI

struct addQuantity: View {
    

    var defaults = UserDefaults.standard
    
    @State var quantity: String = ""
    @Binding var isModal: Bool
    @Binding var currentCurrency: String
    @State var currencyListQuantity: [String:String] = ["":""]
    @State var emptyDict: [String:String] = ["":""]
    
    
    var body: some View {

        VStack{
            
            Text("Add Quantity").font(.largeTitle)
            
            TextField("Search", text: $quantity)
                .padding(7)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            
            
            Button(action: {
              
                UserDefaults.standard.set(emptyDict, forKey: "CurrencyListQuantity")
                //UserDefaults.standard.set([String](), forKey: "CurrencyListPrices")
               // UserDefaults.standard.set([String](), forKey: "CurrencyListPrices2")
                
                print("new currency list quantity", defaults.dictionary(forKey: "CurrencyListQuantity")!, currentCurrency)
            }) {
                Text("Clear Quantity")
                
            }
            
            
            Button(action: {
                self.isModal.toggle()
                
                
                if (defaults.dictionary(forKey: "CurrencyListQuantity") == nil){
                    UserDefaults.standard.set(emptyDict, forKey: "CurrencyListQuantity")
                
                    
                }
                
                
                currencyListQuantity = defaults.dictionary(forKey: "CurrencyListQuantity") as! [String:String]
               
                currencyListQuantity[currentCurrency] = quantity
                //currencyListQuantity.append(quantity)
                //currencyListQuantity = Array(Set(currencyListQuantity))
                //currencyListQuantity.sort()
                
                defaults.set(currencyListQuantity, forKey: "CurrencyListQuantity")
                print("new currency list quantity", defaults.dictionary(forKey: "CurrencyListQuantity")!, currentCurrency)
                
                
            }) {
                Text("Add")
            
                
            }
            
            Spacer()
        }.padding()

    }
    
}
