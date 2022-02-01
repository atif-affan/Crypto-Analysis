//
//  addScreen.swift
//  CryptoAnalysis
//
//  Created by Affan on 12/24/21.
//

import Foundation
import SwiftUI
import StockCharts



struct addCurrency: View {
    
    @State private var searchText: String = ""
    @State private var sortedResults: [String] = []
    @State private var searchResults: [String] = []
    @State private var counter: Int = 0
    @State private var currencyList: [String] = []
    var defaults = UserDefaults.standard
    @State private var coinClass = CoinFunctions()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @Binding var isModal2: Bool
    
   
    
    @State var isModal: Bool = false
    
    @State var currentCurrency: String = ""
    //@State private var size: Int = searchResults.size
    
    var body: some View {
       
        VStack{
            
            HStack{
                Spacer()
                Button(action: {
                    self.isModal2.toggle()
                    
                
                }) {
                    Text("Add")
                    
                }
                
               
                
            }.padding(.trailing)

            List {
                            TextField("Search", text: $searchText)
                                .padding(7)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                
                Button(action: {
                  
                    UserDefaults.standard.set([String](), forKey: "CurrencyList")
                    UserDefaults.standard.set([String](), forKey: "CurrencyListPrices")
                   // UserDefaults.standard.set([String](), forKey: "CurrencyListPrices2")
                    
                    print("Cleared!")
                }) {
                    Text("Clear Portfolio")
                    
                }
                            
                            ForEach(
                                searchResults.filter {
                                    searchText.isEmpty ||
                                    $0.localizedStandardContains(searchText)
                                },
                                id: \.self
                            ) { eachPlanet in
                                
                                
                                Button(action: {
                                    self.isModal = true
                                   
                                    print("Selected", eachPlanet)
                                    currencyList = defaults.array(forKey: "CurrencyList") as! [String]
                                    currencyList.append(eachPlanet)
                                    currencyList = Array(Set(currencyList))
                                    currencyList.sort()
                                    defaults.set(currencyList, forKey: "CurrencyList")
                                    print("new currency list", defaults.array(forKey: "CurrencyList")!)
                                    currentCurrency = eachPlanet
                                }) {
                                    Text(eachPlanet)
                                    
                                }.sheet(isPresented: $isModal, content: {
                                    addQuantity(isModal: self.$isModal, currentCurrency: self.$currentCurrency)
                                })
                                
                                
                                
                            }
            }
            .onChange(of: searchText) {
                newValue in
                
               
                
                var unique = Array(Set(searchResults))
                searchResults = []
                searchResults = coinClass.searchCoin(queryString: searchText)
                
                //searchResults = Array(Set(searchResults))
                //searchResults.sort()
                
            }.onReceive(timer){
                index in
                if (defaults.array(forKey: "CurrencyList") == nil){
                    UserDefaults.standard.set([String](), forKey: "CurrencyList")
                    //UserDefaults.standard.set([String](), forKey: "CurrencyListPrices")
                    
                    
                    
                }
                
                
            }
           Spacer()
        
        }.padding()
    }
}
