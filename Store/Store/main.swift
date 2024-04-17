//
//  main.swift
//  Store
//
//  Created by Ted Neward on 2/29/24.
//

import Foundation

protocol SKU {
    var name: String {get}
    func price() -> Int
}

protocol PricingScheme {
    func apply(items: [SKU]) -> Int
}


class TwoForOne: PricingScheme {
    var itemName: String
    var itemPrice: Int

    init(itemName: String, itemPrice: Int) {
        self.itemName = itemName
        self.itemPrice = itemPrice
    }

    func apply(items: [SKU]) -> Int {
           let filteredItems = items.filter { $0.name == itemName }
           let countOfFilteredItems = filteredItems.count
           
           // Calculate the number of free items. One free item for every three purchased.
           let numberOfFreeItems = countOfFilteredItems / 3
           // Calculate number of paid items (you pay for two each time you buy three).
           let numberOfPaidItems = countOfFilteredItems - numberOfFreeItems
           
           let totalForEligibleItems = numberOfPaidItems * itemPrice
           
           // Compute the total for non-eligible items.
           let otherItems = items.filter { $0.name != itemName }
           let totalForOtherItems = otherItems.reduce(0) { $0 + $1.price() }
           
           return totalForEligibleItems + totalForOtherItems
       }
}

    
    
    
    
    class Item: SKU {
        var name: String
        private var itemPrice: Int
        
        init(name: String, priceEach: Int){
            self.name = name
            self.itemPrice = priceEach
        }
        
        func price() -> Int {
            return itemPrice
        }
    }
    
    class Receipt {
        private var itemsList: [SKU] = []
        private var pricingScheme: PricingScheme? //it can be nil
        
        func addItem(_ item: SKU) {
            itemsList.append(item)
        }
        
        func subTotal() -> Int {
            return itemsList.reduce(0){$0 + $1.price()}
        }
        
        func applyPricingScheme(_ scheme: PricingScheme) {
            pricingScheme = scheme
        }
        
        func total() -> Int {
            // Checks if a pricing scheme is set and applies it to calculate the total.
            // If no scheme is set, it defaults to the subtotal.
            return pricingScheme?.apply(items: itemsList) ?? subTotal()
        }
        
        func items() -> [SKU] {
            return itemsList
        }
        
        func output() -> String {
            var receiptOutput = "Receipt:\n"
            for item in itemsList {
                // Format the price with two decimal places.
                let price = String(format: "$%.2f", Double(item.price()) / 100.0)
                receiptOutput += "\(item.name): \(price)\n"
            }
            receiptOutput += "------------------\n"
            // Use the `total()` method that checks for applied pricing schemes.
            let total = String(format: "$%.2f", Double(self.total()) / 100.0)
            receiptOutput += "TOTAL: \(total)"
            return receiptOutput
        }

        
        func finalizeAndClear() -> Receipt {
            let clonedReceipt = Receipt()
            clonedReceipt.itemsList = self.itemsList
            self.itemsList = []  // Clear the items list
            return clonedReceipt
        }
        
        
        
    }
    
    class Register {
        public var receipt = Receipt()
        
        func scan(_ item: SKU){
            receipt.addItem(item)
        }
        
        func subtotal() -> Int {
            return receipt.subTotal()
        }
        
        func total() -> Receipt {
            return receipt.finalizeAndClear()
        }
        
        func applyPricingScheme(_ scheme: PricingScheme) {
               receipt.applyPricingScheme(scheme)
           }
        
        
        
    }
    
    class Store {
        let version = "0.1"
        func helloWorld() -> String {
            return "Hello world"
        }
    }
