//
//  ContentView.swift
//  CryptoAnalysis
//
//  Created by Affan on 12/22/21.
//

import SwiftUI
import Coinpaprika
import StockCharts



var cryptoPrice = 0

let lineChartController = LineChartController(
    prices: [0.0, 1.2],
    dates: ["yyyy-MM-dd", "2021-01-01"])

let defaults = UserDefaults.standard


let timer = Timer.publish(every:
                            0.5, on: .main, in: .common).autoconnect()


struct ContentView: View {
    
   
    @State private var price: String = ""
    @State var convertedPrices = [String: Double]()
    
    @ObservedObject private var coinClass = CoinFunctions(startValues: defaults.array(forKey: "CurrencyList") as! [String])
    //@State private var percentChange: String = returnPercentage()

    @State var isModal: Bool = false
    @State var isModal2: Bool = false
    
    @State var calculationModal: Bool = false
    @State var colorPercentage: Color = Color.blue
    
    @State var currencyListPortfolio: [String] = defaults.array(forKey: "CurrencyList") as! [String]
    
    @State var currencyListPortfolioPrices: [String:String] =  (defaults.dictionary(forKey: "CurrencyListPrices") as! [String:String])
    
    @State var currencyListPortfolioPricesChange: [String:String] =  defaults.dictionary(forKey: "CurrencyListPricesPercentChange") as! [String:String]
    
    @State var currencyListQuantity: [String:String] =  defaults.dictionary(forKey: "CurrencyListQuantity") as! [String:String]
    
    @ObservedObject var networkManager = checkClass()
    
    @State var buttonText: [String: Double] = ["":0.0]
    var body: some View {

        
        VStack(spacing: 0){
            
        
        RoundedRectangle(cornerRadius: 20)
            .frame(width: 350, height: 200)
                        .foregroundColor(.white)
                        .shadow(color: Color(.gray).opacity(0.15), radius: 10)
            .overlay(
        
            VStack{
                LineChartView(
                    lineChartController:
                        LineChartController(
                            prices: [0.0, 1.2, 0.2, 0.5, 0.25, 5],
                            dates: ["2021-01-01", "2021-01-01","2021-01-01","2021-01-01","2021-01-01","2021-01-01"],
                            hours: ["0", "1", "2", "3", "4", "5"],
                            
                            dragGesture: true
                        )
                )
                
                
            }
        
        
            )
            
            
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color(hue: 0.0, saturation: 0.003, brightness: 0.929))
                          .frame(width: 325, height: 45).overlay(
                            
                            HStack{
                                
                                
                                Button("Calculate Risk Score") {
                                            self.calculationModal = true
                                    coinClass.linearRegressionUnixOpen(coinName: "ETH")
                                    coinClass.linearRegressionUnixClose(coinName: "ETH")
                                    coinClass.linearRegressionVolClose(coinName: "ETH")
                                    //coinClass.linearRegressionVolOpen(coinName: "ETH")
                                    coinClass.polynomialRegressionUnixOpen(coinName: "ETH")
                                    coinClass.polynomialRegressionUnixClose(coinName: "ETH")
                                    coinClass.polynomialRegressionVolFiatClose(coinName: "ETH")
                                    buttonText = coinClass.returnNewPrices()
                                    
                                    
                                    
                                        }.sheet(isPresented: $calculationModal, content: {
                                            displayCalculation(calculationModal: self.$calculationModal, regressionPercentage: self.$buttonText, currentPrices: self.$currencyListPortfolioPrices)
                                        })
                                
                         
                                
                        
                            
                            
                            }
                          ).padding(.top)
            
            HStack{
                Text("Portfolio").font(.largeTitle).bold()
                Spacer()
                Button("Add +") {
                            self.isModal = true
                        }.sheet(isPresented: $isModal, content: {
                            addCurrency(isModal2: self.$isModal)
                        })
                
            }.padding()
            
            RoundedRectangle(cornerRadius: 15, style: .circular)
                .fill(Color(hue: 0.0, saturation: 0.003, brightness: 0.929))
                .frame( height: 30).overlay{
                    
                    HStack{
                        Text("Ticker")
                        Spacer()
                        Text("Value")
                        Spacer()
                        Text("Quantity")
                        Spacer()
                        Text("24Hr%")
                        
                    }.padding()
                    
                }.padding(.bottom)
            
            
            List{
                
                
                HStack{
                VStack{
                    
                    
                    
                    ForEach(currencyListPortfolio.indices, id: \.self) {index in
                        
                        
                        
                        
                        RoundedRectangle(cornerRadius: 15, style: .circular)
                            .fill(Color(hue: 0.0, saturation: 0.003, brightness: 0.929))
                                  .frame( height: 75).overlay(
                                      
                                    HStack{
                                        
                                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                                            .fill(Color.blue.opacity(0.2))
                                            .frame(width: 50, height: 40)
                                            .overlay(
                                        
                                                
                                                Text(currencyListPortfolio[index].prefix(3)).textCase(.uppercase)
                                            .foregroundColor(.black)
                                            .font(.subheadline)
                                        )
                                        
                                        
                                        Text(currencyListPortfolioPrices[currencyListPortfolio[index]] ?? "Not found")
                                            .foregroundColor(.black)
                                            .font(.subheadline).frame(width: 85, height:30)
                                       
                                        
                                        Text(currencyListQuantity[currencyListPortfolio[index]] ?? "Not found")
                                            .foregroundColor(.black)
                                            .font(.subheadline).frame(width: 30, height:30)
                                      
                                        
                                        //print(firstCard == secondCard ? "Cards are the same" : "Cards are different")
                                        
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                            .fill((currencyListPortfolioPricesChange[currencyListPortfolio[index]] ?? "Not Found").prefix(1) == "-" ? Color.red : Color.green)
                                            .frame(width: 75, height: 40)
                                            .overlay(
                                                Text(currencyListPortfolioPricesChange[currencyListPortfolio[index]]?.prefix(4) ?? "Not Found" + "%")
                                            .foregroundColor(.black)
                                            .font(.subheadline)
                                            .onReceive(timer){
                                                input in
                                                
                                                convertedPrices = convertCurrentPrices(inputDict: currencyListPortfolioPrices)
                                                coinClass.reload()
                                                coinClass.regression()
                                                currencyListPortfolio = defaults.array(forKey: "CurrencyList") as! [String]
                                                
                                                //coinClass.returnPercentage()
                                                coinClass.fetchPrices()
                                                currencyListPortfolioPricesChange = coinClass.currencyListPercentageChange
                                                currencyListPortfolioPrices = coinClass.currencyListPortfolioPrices
                                                //print("csv", coinClass.decodeData())
                                                currencyListQuantity = coinClass.currencyListQuantity
                                                
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
                                                
                                                    coinClass.percentChange = coinClass.returnPercentage()
                                                    //currencyListPortfolio = defaults.array(forKey: "CurrencyList") as! [String]
                                                    print("content", coinClass.determinePrice())
                                                    print("reloaded")
                                                    
                                                }
                                                
                                              //searchCoin()
                                                
                                                
                                                
                                                
                                            }
                                       )
                                        
                                    }
                                
                                  )
     
                    }
                }
                
                    Spacer()
                  
                }
                
            }.onReceive(timer){
                new in
                
                currencyListPortfolio = defaults.array(forKey: "CurrencyList") as! [String]
                print(currencyListPortfolio.count)
            }
                
            
            
            Spacer()
            Text("Last Updated")
          
            
        }.padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
