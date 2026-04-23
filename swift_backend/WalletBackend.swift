import Foundation
import UIKit

@objc public final class WalletBackend: NSObject {
    
    @objc public func getFormattedBalance() -> String {
        return "€ 189.930,00"
    }
    
    @objc public func getSystemUserName() -> String {
        // Restituisce il nome del dispositivo o dell'utente di sistema
        let deviceName = UIDevice.current.name
        if deviceName.contains("iPhone") || deviceName.contains("iPad") {
            return "Luca Franzato"
        }
        return deviceName
    }
    
    @objc public func getTransactions() -> String {
        let transactions: [[String: Any]] = [
            ["id": "1", "title": "Apple Store", "subtitle": "Elettronica", "amount": -1299.00, "date": "Oggi", "isPositive": false],
            ["id": "2", "title": "Stipendio", "subtitle": "Tech Corp Inc.", "amount": 5400.00, "date": "Ieri", "isPositive": true],
            ["id": "3", "title": "Starbucks", "subtitle": "Alimentari", "amount": -5.50, "date": "Ieri", "isPositive": false],
            ["id": "4", "title": "Amazon", "subtitle": "Shopping", "amount": -120.40, "date": "24 Ott", "isPositive": false],
            ["id": "5", "title": "Bonifico in entrata", "subtitle": "Lavoro Freelance", "amount": 850.00, "date": "22 Ott", "isPositive": true]
        ]
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: transactions, options: []),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            return jsonString
        }
        return "[]"
    }
}