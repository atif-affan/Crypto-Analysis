//
//  priceRetriever.swift
//  CryptoAnalysis
//
//  Created by Affan on 12/22/21.
//

import Foundation
import Coinpaprika
import UIKit
import CryptoCurrencyKit
import CSV


class checkClass: ObservableObject{
    
    
    var finalPrices: [String] = ["0", "0"]
    
    func fetchData(){
        
        
       finalPrices = defaults.array(forKey: "CurrencyListPrices2") as! [String]
        
    }
    
    
}



class CoinFunctions: ObservableObject{
    
    var price: Decimal = 0
    var priceCoin: String = ""
    var percentChange: String = ""
    var searchResultsCoin: [String] = []
    var holdResults: [Coin] = []
    var counter: Int = 0
    var currencyPricesList: [String] = []
    var ListOfCurrencies: [String] = []
    var someDict = [String: String]()
    var currencyListPercentageChange = [String: String]()
    
    
    var predictedPricesLinRegUnixOpen = [String: String]()
    var predictedPricesLinRegUnixClose = [String: String]()
    var predictedPricesLinRegVolClose = [String: String]()
    var predictedPricesLinRegVolOpen = [String: String]()
    var predictedPricesPolRegUnixOpen = [String: String]()
    var predictedPricesPolRegUnixClose = [String: String]()
    var predictedPricesPolRegVolFiatClose = [String: String]()
    
    
    var currencyListPortfolioPrices: [String:String] = ["":""]
    var currencyListQuantity: [String:String] = ["":""]
    
    var linearRegressionUnixOpen: Double = 0.0
    var linearRegressionUnixClose: Double = 0.0
    var linearRegressionVolClose: Double = 0.0
    var linearRegressionVolOpen: Double = 0.0
    var polynomialRegressionUnixOpen: Double = 0.0
    var polynomialRegressionUnixClose: Double = 0.0
    var polynomialRegressionVolFiatClose: Double = 0.0
    var listAvailableCoins: [String] = ["BTC", "ADA", "AVAX", "DOGE", "MATIC", "LTC", "ALGO", "LINK", "BCH", "XLM", "FILU", "ICPU", "ETC", "XTZ", "AAVE", "GALA", "EOS", "LRC", "ENJ", "MKR", "QNT", "ZEC", "CHZ", "IOTX", "1INCH", "SUSHI", "YFI", "OMG", "LPT", "VGX", "ZEN", "BNT", "SNX", "ZRX", "STORJ", "UMA", "PERP", "NU", "AMP", "TRAC", "XYO", "TRIBE", "FET", "KEEP", "JASMY", "FX", "REQ", "COTI", "BTRST", "NKN", "OGN", "RLC", "ANKR", "POLS", "POWR", "BAND", "NMR", "ORN", "ALCX", "IDEX", "MLN", "BADGER", "AGLD", "SKL", "ARPA", "BAL", "COVAL", "YFII", "FORTH", "LOOM", "DNT", "QUICK", "MDT", "RARI", "ASM", "FARM", "SUKU", "GYEN", "MIR", "COMP", "SPELL", "OXT", "CLV", "TRU", "BOND", "RLY", "RGT", "REP", "POLY", "DESO", "KRL", "MANA", "CVC", "DASH", "RBN", "DAI", "REN", "RAD", "MUSD", "RAI", "ACH", "GRT", "TRB", "LCX", "WBTC", "PLA", "CRV", "DDX", "UST", "GODS", "ENS", "FOX", "BAT", "BLZ", "SOL", "ETH", "USDT", "SHIB", "CRO", "UNII", "AXS", "KNC", "GTC", "IMX", "SUPER", "ATOM", "DOT"]
    
    
    struct Team{
        
        var unix: String = ""
        var low: String = ""
        var high: String = ""
        var open: String = ""
        var close: String = ""
        var volume: String = ""
        var date: String = ""
        var vol_fiat: String = ""
        
        init(raw: [String]){
            
            unix = raw[0]
            high = raw[1]
            open = raw[2]
            close = raw[3]
            volume = raw[4]
            date = raw[6]
            vol_fiat = raw[7]
            
            
            
        }
        
        
    }
    
    func CoinFunctions(){
        
        price = 0
        priceCoin = ""
        percentChange = ""
        searchResultsCoin = []
        holdResults  = []
        counter = 0
        currencyPricesList = []
    
    }
    
    
    
    
    init(startValues: [String]){
        
       
        
        ListOfCurrencies = startValues
        print("here are the start values", ListOfCurrencies)
        
        for i in ListOfCurrencies{
            
            
            someDict = [i: ""]
            
        }
        
        print("final dictionary", ListOfCurrencies)
        
    }
    
    init(){
        
        
        
        
    }
    
    func reload(){
        
        
        
        ListOfCurrencies = defaults.array(forKey: "CurrencyList") as! [String]
        determinePrice()
        
        
        
        
        
    }
    
    func fetchPrices() {
        
        currencyListPortfolioPrices = defaults.dictionary(forKey: "CurrencyListPrices") as! [String:String]
        currencyListPercentageChange = defaults.dictionary(forKey: "CurrencyListPricesPercentChange") as! [String:String]
        
        currencyListQuantity = defaults.dictionary(forKey: "CurrencyListQuantity") as! [String:String]
        
       // print("fetched prices", currencyListPortfolioPrices)
    }
    
    func determinePrice() -> [String:String]{
        
        self.currencyPricesList = []
        UserDefaults.standard.set([String](), forKey: "CurrencyListPrices")
        
        
            // Perform the data request and JSON decoding on the background queue.
            for i in self.ListOfCurrencies{
                
                
                //print("here is the ticker", i)
            Coinpaprika.API.ticker(id: i, quotes: [.usd, .btc]).perform { (response) in
              switch response {
                case .success(let ticker):
             
                  self.priceCoin = "\(ticker[.usd].price)"
                  //self.currencyPricesList.append(self.priceCoin)
                  print("here u go", i, self.priceCoin)
                  
                  self.someDict[i] = self.priceCoin
                  //self.currencyPricesList.append(self.priceCoin)
                  //print("currency prices list", self.currencyPricesList)
                  UserDefaults.standard.set(self.someDict, forKey: "CurrencyListPrices")
                  
                  
                  //print(self.currencyPricesList)
                  break
                case .failure(let error):
                  print("failed to get", i)
                  self.someDict[i] = "0.00"
                  //self.currencyPricesList.append("0.00")
                  break
                // Failure reason as error
              
                
                
            }
            
                
            
            }
               //print("here is the final list", self.currencyPricesList)
               
           
        }
        
        

        
        //defaults.set(self.currencyPricesList, forKey: "CurrencyListPrices")
          
        print("dictionary touchdown", self.someDict)
        defaults.set(self.someDict, forKey: "CurrencyListPrices")
        
        return self.someDict
    }
    
    func regression(){
        
        let data: [[Double]] = [[1,20],[2,70],[2,45],[3,81],[5,73],[6,80],[7,110]]
        let x: Double = 4.5

        let prediction = PredictionBuilder()

        prediction.set(x: x, data: data)

        // What is the expected y value for a given x value?
        do {
            let result = try prediction.build()
            //print("here is the final prediction", result)// y = 76.65
        } catch let msg {
            print("here is the prediction", msg)
        }
        
        
        
    }
    
    
    func returnPriceRegression() -> String{
        
        var finalAverage: Double = 0.0
        
        
        finalAverage = linearRegressionVolClose + linearRegressionUnixClose + linearRegressionUnixOpen + polynomialRegressionUnixOpen + polynomialRegressionUnixClose + polynomialRegressionVolFiatClose
        
        finalAverage = finalAverage / 6.0
        
        
        print("the final average price is:", finalAverage)
        
        return String(finalAverage)
        
        
    }
    
    
    func returnNewPrices() -> Dictionary<String, Double> {
        
        var finalAverage: Double = 0.0
        
        var arrayCalculation: [String] = []
        var finalPredictions = [String: Double]()
        var counter = 0.0
        
        
        for i in ListOfCurrencies{
            
            print(i, "is is the yeah")
            arrayCalculation.append(predictedPricesLinRegUnixOpen[i] ?? "Not Found")
            arrayCalculation.append(predictedPricesLinRegUnixClose[i] ?? "Not Found")
            arrayCalculation.append(predictedPricesLinRegVolClose[i] ?? "Not Found")
            //arrayCalculation.append(predictedPricesLinRegVolOpen[i] ?? "Not Found")
            //arrayCalculation.append(predictedPricesLinRegUnixOpen[i] ?? "Not Found")
            arrayCalculation.append(predictedPricesPolRegUnixOpen[i] ?? "Not Found")
            arrayCalculation.append(predictedPricesPolRegUnixClose[i] ?? "Not Found")
            arrayCalculation.append(predictedPricesPolRegVolFiatClose[i] ?? "Not Found")
            
            
            
            var arrayCalculation2 = arrayCalculation.map { (value) -> Double in
                return Double(value)!
           
            
            }
            
            
            arrayCalculation2[3] = arrayCalculation2[3] * 0.75
            arrayCalculation2[4] = arrayCalculation2[4] * 0.75
            
            print("arrayCalculation", arrayCalculation2)
            
            arrayCalculation = []
            counter = 0
            finalAverage = 0
            
            for i in arrayCalculation2{
                
                finalAverage = finalAverage + i
                counter = counter + 1
                
                
                
            }
            
            
            arrayCalculation2 = []
            finalAverage = finalAverage / counter
            finalPredictions[i] = finalAverage
            print("final predictions yay", finalPredictions)
            
            
        }
        
        
        return finalPredictions
    }
    
    
    func polynomialRegressionVolFiatClose(coinName: String){
        
        
        for i in ListOfCurrencies{
        
            
            var coinNameFinal = "Coinbase_" + i.prefix(3) + "USD_dailydata"
            print("polynomialRegressionVolFiatClose ", coinNameFinal)
        let date = NSDate() // current date
        var unixtime = date.timeIntervalSince1970 + 604774
        unixtime = unixtime/10000000
        //print("unix time", unixtime/10000000)
    
        
        
        var points:[CGPoint] = []
        var teams = loadCSV(csvName: coinNameFinal)
        var finalArray: [String] = []
        var openData:[String] = []
        var dateUnix:[String] = []
        
        
        for i in teams{
            
           // print(i.date, i.open)
            
            openData.append(i.vol_fiat)
            dateUnix.append(i.close)
       
            
        }
    
        let sum1 = openData.map { (value) -> Double in
            return Double(value)!
        }
        let sum2 = dateUnix.map { (value) -> Double in
            return Double(value)!
        }
       
        //print("final array for polynomial", points2)
        
        

        
        for i in 0...sum1.count-1{
            
            points.append(CGPoint(x: sum1[i]/10000000, y: sum2[i]/10000000))
            
        }
        
        let regression = PolynomialRegression.regression(withPoints: points, degree: 2)

        
        var values: [Double] = []
        //print("The result is the sum of")
        for i in 0..<regression!.count {
            let coefficient = regression![i]
            //print("\(coefficient) * x^\(i)");
            values.append(coefficient)
        }
        
        
        var predictPrice = (values[0]) + (unixtime)*(values[1]) + (unixtime*unixtime)*(values[2])
        print("Polynomial Regression Prediction (Vol_Fiat, Close): $", predictPrice*10000000)
        polynomialRegressionVolFiatClose = predictPrice*10000000
        predictedPricesPolRegVolFiatClose[i] = String(polynomialRegressionVolFiatClose)
        
        }
    }
    
    
    func polynomialRegressionUnixClose(coinName: String){
        
        for i in ListOfCurrencies{
        
            var coinNameFinal = "Coinbase_" + i.prefix(3) + "USD_dailydata"
        print("polynomialRegressionUnixClose", coinNameFinal)
        let date = NSDate() // current date
        var unixtime = date.timeIntervalSince1970 + 604774
        unixtime = unixtime/10000000
        //print("unix time", unixtime/10000000)
    
        
        
        var points:[CGPoint] = []
        var teams = loadCSV(csvName: coinNameFinal)
        var finalArray: [String] = []
        var openData:[String] = []
        var dateUnix:[String] = []
        
        
        for i in teams{
            
           // print(i.date, i.open)
            
            openData.append(i.unix)
            dateUnix.append(i.close)
       
            
        }
    
        let sum1 = openData.map { (value) -> Double in
            return Double(value)!
        }
        let sum2 = dateUnix.map { (value) -> Double in
            return Double(value)!
        }
       
        //print("final array for polynomial", points2)
        
        

        
        for i in 0...sum1.count-1{
            
            points.append(CGPoint(x: sum1[i]/10000000, y: sum2[i]/10000000))
            
        }
        
        let regression = PolynomialRegression.regression(withPoints: points, degree: 2)

        
        var values: [Double] = []
        //print("The result is the sum of")
        for i in 0..<regression!.count {
            let coefficient = regression![i]
            //print("\(coefficient) * x^\(i)");
            values.append(coefficient)
        }
        
        
        var predictPrice = (values[0]) + (unixtime)*(values[1]) + (unixtime*unixtime)*(values[2])
        print("Polynomial Regression Prediction (Unix, Close): $", predictPrice*10000000)
        polynomialRegressionUnixClose = predictPrice*10000000
        predictedPricesPolRegUnixClose[i] = String(polynomialRegressionUnixClose)
        
        }
    }
    
    
    func polynomialRegressionUnixOpen(coinName: String){
        
        
        for i in ListOfCurrencies{
        
            var coinNameFinal = "Coinbase_" + i.prefix(3) + "USD_dailydata"
        
            print("polynomialRegressionUnixOpen", coinNameFinal)
        let date = NSDate() // current date
        var unixtime = date.timeIntervalSince1970 + 604774
        unixtime = unixtime/10000000
        //print("unix time", unixtime/10000000)
        
        let points2:[CGPoint] = [
            CGPoint(x: 0, y: 1),
            CGPoint(x: 9, y: -7),
            CGPoint(x: 13, y: 6),
            CGPoint(x: 15, y: 12),
            CGPoint(x: 19, y: -4),
            CGPoint(x: 20, y: -12),
            CGPoint(x: 26, y: -2),
            CGPoint(x: 26, y: 13),
            CGPoint(x: 29, y: 23),
            CGPoint(x: 30, y: 30),
        ]
        
        
        var points:[CGPoint] = []
        var teams = loadCSV(csvName: coinNameFinal)
        var finalArray: [String] = []
        var openData:[String] = []
        var dateUnix:[String] = []
        
        
        for i in teams{
            
           // print(i.date, i.open)
            
            openData.append(i.unix)
            dateUnix.append(i.open)
       
            
        }
    
        let sum1 = openData.map { (value) -> Double in
            return Double(value)!
        }
        let sum2 = dateUnix.map { (value) -> Double in
            return Double(value)!
        }
       
        //print("final array for polynomial", points2)
        
        

        
        for i in 0...sum1.count-1{
            
            points.append(CGPoint(x: sum1[i]/10000000, y: sum2[i]/10000000))
            
        }
        
        let regression = PolynomialRegression.regression(withPoints: points, degree: 2)

        
        var values: [Double] = []
        //print("The result is the sum of")
        for i in 0..<regression!.count {
            let coefficient = regression![i]
            //print("\(coefficient) * x^\(i)");
            values.append(coefficient)
        }
        
        
        var predictPrice = (values[0]) + (unixtime)*(values[1]) + (unixtime*unixtime)*(values[2])
        print("Polynomial Regression Prediction (Unix, Open): $", predictPrice*10000000)
        polynomialRegressionUnixOpen = predictPrice*10000000
            predictedPricesPolRegUnixOpen[i] = String(polynomialRegressionUnixOpen)
        
   
        }
        }
    
    
    func linearRegressionVolOpen(coinName: String){
        
        for i in ListOfCurrencies{
        
        
            var coinNameFinal = "Coinbase_" + i.prefix(3) + "USD_dailydata"
        
            print("linearRegressionVolOpen ", coinNameFinal)
        let date = NSDate() // current date
        var unixtime = date.timeIntervalSince1970 + 604800
       
        
        var teams = loadCSV(csvName: coinNameFinal)
        var openData:[String] = []
        var dateUnix:[String] = []
        
        var convertedArray:[String] = []
        
        
        var finalArray: [[String]] = [[]]
        
        
        for i in teams{
            
           // print(i.date, i.open)
            
            openData.append(i.volume)
            dateUnix.append(i.close)
           // finalArray.append([i.volume, i.close])

           
            
            
        }
        
        let sum1 = openData.map { (value) -> Double in
            return Double(value)!
        }
        
        let sum2 = dateUnix.map { (value) -> Double in
            return Double(value)!
        }
        
        for i in 0...sum1.count-1{
            
            convertedArray.append(String(sum1[i] * sum2[i]))
            
        }
        
        var counter = 0
        for i in teams{
            
            finalArray.append([convertedArray[counter],i.close])
         counter = counter + 1
        }
        
        
        
        
        
        print("size", openData.count, dateUnix.count)
        
        var doubleArray = finalArray.map { $0.compactMap(Double.init) }
        
        doubleArray[0] = doubleArray[1]
        let data: [[Double]] = finalArray as? [[Double]] ?? [[0.0, 0.0]]
        let x: Double = unixtime
        
        
        let prediction = PredictionBuilder()
        prediction.set(x: x, data: doubleArray)

        // What is the expected y value for a given x value?
        do {
            let result = try prediction.build()
            print("Linear Regression Prediction (newVol, Open): $", result.y)// y = 76.65
            linearRegressionVolOpen = result.y
            predictedPricesLinRegVolOpen[i] = String(result.y)
        } catch let msg {
            print("Error", msg)
        }
        
   
        
        }
        
    }
    
    
    func linearRegressionVolClose(coinName: String){
        
        for i in ListOfCurrencies{
        
            var coinNameFinal = "Coinbase_" + i.prefix(3) + "USD_dailydata"
            print("linearRegressionVolClose", coinNameFinal)
        let date = NSDate() // current date
        var unixtime = date.timeIntervalSince1970 + 604800
       
        
        var teams = loadCSV(csvName: coinNameFinal)
        var openData:[String] = []
        var dateUnix:[String] = []
        var finalArray: [[String]] = [[]]
        
        
        for i in teams{
            
           // print(i.date, i.open)
            
            finalArray.append([i.vol_fiat,i.close])

           
            
            
        }
        
        
        
        var doubleArray = finalArray.map { $0.compactMap(Double.init) }
        
        doubleArray[0] = doubleArray[1]
        let data: [[Double]] = finalArray as? [[Double]] ?? [[0.0, 0.0]]
        let x: Double = unixtime
        
        
        let prediction = PredictionBuilder()
        prediction.set(x: x, data: doubleArray)

        // What is the expected y value for a given x value?
        do {
            let result = try prediction.build()
            print("Linear Regression Prediction (Vol_Fiat, Close): $", result.y)// y = 76.65
            linearRegressionVolClose = result.y
            predictedPricesLinRegVolClose[i] = String(result.y)
        } catch let msg {
            print("Error", msg)
        }
        
   
      
        }
        
        
    }
    
    
    func linearRegressionUnixClose(coinName: String){
        
        
        
        for i in ListOfCurrencies{
            
            
        
            var coinNameFinal = "Coinbase_" + i.prefix(3) + "USD_dailydata"
        print("linearRegressionUnixClose ", coinNameFinal)
        let date = NSDate() // current date
        var unixtime = date.timeIntervalSince1970 + 604800
       
        
        var teams = loadCSV(csvName: coinNameFinal)
        var openData:[String] = []
        var dateUnix:[String] = []
        var finalArray: [[String]] = [[]]
        
        
        for i in teams{
            
           // print(i.date, i.open)
            
            finalArray.append([i.unix,i.close])

           
            
            
        }
        
        
        
        var doubleArray = finalArray.map { $0.compactMap(Double.init) }
        
        doubleArray[0] = doubleArray[1]
        let data: [[Double]] = finalArray as? [[Double]] ?? [[0.0, 0.0]]
        let x: Double = unixtime
        
        
        let prediction = PredictionBuilder()
        prediction.set(x: x, data: doubleArray)

        // What is the expected y value for a given x value?
        do {
            let result = try prediction.build()
            print("Linear Regression Prediction (Unix, Close): $", result.y)// y = 76.65
            linearRegressionUnixClose = result.y
            predictedPricesLinRegUnixClose[i] = String(result.y)
        } catch let msg {
            //print("here is the prediction", msg)
        }
        
   
        
        
      
        }
        
        
    }
    
    
    func linearRegressionUnixOpen(coinName: String){
        
        
        
        for i in ListOfCurrencies{
        
           
        
            var coinNameFinal = "Coinbase_" + i.prefix(3) + "USD_dailydata"
        
            print("linearRegressionUnixOpen ", coinNameFinal)
        let date = NSDate() // current date
        var unixtime = date.timeIntervalSince1970 + 604800
       
        
        var teams = loadCSV(csvName: coinNameFinal)
        var openData:[String] = []
        var dateUnix:[String] = []
        var finalArray: [[String]] = [[]]
        
        
        for i in teams{
            
           // print(i.date, i.open)
            
            finalArray.append([i.unix,i.open])

           
            
            
        }
        
        
        
        var doubleArray = finalArray.map { $0.compactMap(Double.init) }
        
        doubleArray[0] = doubleArray[1]
        let data: [[Double]] = finalArray as? [[Double]] ?? [[0.0, 0.0]]
        let x: Double = unixtime
        
        
        let prediction = PredictionBuilder()
        prediction.set(x: x, data: doubleArray)

        // What is the expected y value for a given x value?
        do {
            let result = try prediction.build()
            print("Linear Regression Prediction (Unix, Open): $", result.y)// y = 76.65
            linearRegressionUnixOpen = result.y
            predictedPricesLinRegUnixOpen[i] = String(result.y)
        } catch let msg {
            //print("here is the prediction", msg)
        }
        
   
        
        
      
        }
        
        
    
        
    }


    func returnPercentage() -> String{
        
        
        for i in self.ListOfCurrencies{
        Coinpaprika.API.ticker(id: i, quotes: [.usd, .btc]).perform { (response) in
          switch response {
            case .success(let ticker):
            // Successfully downloaded Ticker
            // ticker.id - Coin identifier, to use in ticker(id:) method
            // ticker.name - Coin name, for example Bitcoin
            // ticker.symbol - Coin symbol, for example BTC
            // ticker.rank - Position in Coinpaprika ranking (by MarketCap)
            // ticker.circulatingSupply - Circulating Supply
            // ticker.totalSupply - Total Supply
            // ticker.maxSupply - Maximum Supply
            // ticker.betaValue - Beta
            // ticker.lastUpdated - Last updated date
            //
          
              
            // Each Ticker could contain several Ticker.Quote (according to provided quotes parameter). To access to quote for given currency, use subscripting like:
            // - ticker[.usd] - Ticker.Quote in USD
            // - ticker[.btc] - Ticker.Quote in BTC
            // etc...
            //
            // So how to get this cryptocurrency price in USD and BTC?
            // - ticker[.usd].price - Coin price in USD
            // - ticker[.btc].price - Coin price in BTC
            //
            // Ticker.Quote contains following properties:
             let currency: QuoteCurrency = .usd
              
              self.percentChange = "\(ticker[currency].percentChange24h)"
              self.currencyListPercentageChange[i] = self.percentChange + "%"
              UserDefaults.standard.set(self.currencyListPercentageChange, forKey: "CurrencyListPricesPercentChange")
              
             // print("here is the change", self.percentChange)
              
              //self.currencyPricesList.append(self.priceCoin)
              //print("currency prices list", self.currencyPricesList)
              
              //print(type(of: percentChange))
            // - ticker[currency].price - Price
            // - ticker[currency].volume24h - Volume from last 24h
            // - ticker[currency].volume24hChange24h - Volume change in last 24h
            // - ticker[currency].marketCap - Market capitalization
            // - ticker[currency].marketCapChange24h - Market capitalization in last 24h
            // - ticker[currency].percentChange1h - Percentage price change in last 1 hour
            // - ticker[currency].percentChange12h - Percentage price change in last 12 hour
            // - ticker[currency].percentChange24h - Percentage price change in last 24 hour
            // - ticker[currency].percentChange7d - Percentage price change in last 7 days
            // - ticker[currency].percentChange30d - Percentage price change in last 30 days
            // - ticker[currency].percentChange1y - Percentage price change in last 1 year
            // - ticker[currency].athPrice - ATH price
            // - ticker[currency].athDate - ATH date
            // - ticker[currency].percentFromPriceAth - Percentage price change from ATH
            // - ticker[currency].volumeMarketCapRate - Volume/MarketCap rate
              break
            case .failure(let error):
              print("failed")
              break
            // Failure reason as error
          }
        }
        }
        
        UserDefaults.standard.set(self.currencyListPercentageChange, forKey: "CurrencyListPricesPercentChange")
        return percentChange
        
    }




    func priceChecker() -> String{
        
        
        return "hello"
        
        
    }
    
    
    func loadCSV(csvName: String) -> [Team]{
        
        var csvToStruct = [Team]()
        
        guard let filePath = Bundle.main.path(forResource: csvName, ofType: "csv") else{
            
            return []
        }
        var data = ""
        do {
            
            data = try String(contentsOfFile: filePath)
            
        } catch {
            print(error)
            return []
            
        }
        
        var rows = data.components(separatedBy: "\n")
        
        let columnCount = rows.first?.components(separatedBy: ",").count
        rows.removeFirst()
        
        for row in rows{
            let csvColumns = row.components(separatedBy: ",")
            if csvColumns.count == columnCount{
                let teamStruct = Team.init(raw: csvColumns)
                csvToStruct.append(teamStruct)
            }
           
        }
        
        
       
        return csvToStruct
        
    }


    func searchCoin(queryString: String) -> [String]{
        
        
        Coinpaprika.API.search(query: queryString, categories: [.currencies, .exchanges, .icos, .people, .tags], limit: 20).perform { (response) in
          switch response {
            case .success(let searchResults):
              //print(type(of: searchResults.currencies))
              self.holdResults = searchResults.currencies!
              
              self.counter = 0
              self.searchResultsCoin = []
              for i in self.holdResults{
                  
                 
                
                  if (self.listAvailableCoins.contains(String(i.symbol))){
                  
                      print("the coin was found",String(i.id))
                  self.searchResultsCoin.append(String(i.id))
                  //print(searchResultsCoin[counter])
                  self.counter = self.counter+1
                  
                  }
                  
              }
              
              
              
              //print("yes", type(of: holdResults))
           
              break
            // Successfully downloaded SearchResults
            // searchResults.currencies - list of matching coins as [Search.Coin]
            // searchResults.icos - list of matching ICOs as [Search.Ico]
            // searchResults.exchanges - list of matching exchanges as [Search.Exchange]
            // searchResults.people - list of matching people as [Search.Person]
            // searchResults.tags - list of matching tags as [Search.Tag]
            case .failure(let error):
              print("failed search results")
              break
            // Failure reason as error
          }
        }
        
        return searchResultsCoin
    }


    
    
    
}



