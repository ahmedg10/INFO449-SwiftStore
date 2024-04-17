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
    
    init(itemName: String, itemPrice: Int){
        self.itemName = itemName
        self.itemPrice = itemPrice
    }
    
    func apply(items: [SKU]) -> Int {
        // Filter items by the specified name.
        let filteredItems = items.filter { $0.name == itemName }
        let countOfFilteredItems = filteredItems.count
        
        // Calculate the number of groups of three from the filtered items.
        let numberOfGroups = countOfFilteredItems / 3
        let freeItemsCount = numberOfGroups
        let paidItemsCount = countOfFilteredItems - freeItemsCount
        
        // Calculate total cost for items with the special pricing.
        let totalForSpecialItems = paidItemsCount * itemPrice
        
        // Calculate the total for other items that do not qualify for the special pricing.
        let otherItems = items.filter { $0.name != itemName }
        let totalForOtherItems = otherItems.reduce(0) { $0 + $1.price() }
        
        // Sum the totals for special priced items and other items.
        return totalForSpecialItems + totalForOtherItems
        
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
            return pricingScheme?.apply(items: itemsList) ?? subTotal()
        }
        
        func items() -> [SKU] {
            return itemsList
        }
        
        func output() -> String {
            var receiptOutput = "Receipt:\n"
            for item in itemsList {
                let price = String(format: "$%.2f", Double(item.price()) / 100.0)
                receiptOutput += "\(item.name) (8oz Can): \(price)\n"
            }
            receiptOutput += "------------------\n"
            let total = String(format: "$%.2f", Double(subTotal()) / 100.0)
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
        
        
        
    }
    
    class Store {
        let version = "0.1"
        func helloWorld() -> String {
            return "Hello world"
        }
    }
