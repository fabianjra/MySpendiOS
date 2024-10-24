//
//  Icons.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 21/10/24.
//

public enum Icons: String, CaseIterable {
    case defaultIcon = "tag.fill"
    case bills = "Bills"
    case foodAndDrink = "Food and Drink"
    case household = "Household"
    
    var list: [String] {
        switch self {
        case .defaultIcon: return []
        case .bills:
            return [
                "lightbulb.fill", "spigot.fill", "house.fill", "play.tv.fill", "tv.badge.wifi.fill",
                "appletvremote.gen4.fill", "wifi", "wifi.router.fill", "phone.fill", "flame.fill",
                "umbrella.fill", "chart.bar.fill", "bolt.horizontal.fill", "externaldrive.connected.to.line.below.fill",
                "icloud.fill"
            ]
        case .foodAndDrink:
            return [
                "fork.knife", "wineglass.fill", "cup.and.saucer.fill", "mug.fill", "waterbottle.fill",
                "birthday.cake.fill", "carrot.fill", "fireplace.fill", "oven.fill", "microwave.fill",
                "refrigerator.fill", "popcorn.fill", "frying.pan.fill", "cart.fill", "basket.fill"
            ]
        case .household:
            return [
                "house.fill", "tag.fill", "creditcard.fill", "banknote.fill", "wallet.pass.fill",
                "bag.fill", "gym.bag.fill", "handbag.fill", "person.fill", "figure.arms.open",
                "figure.2.arms.open", "figure.2.and.child.holdinghands", "figure.and.child.holdinghands",
                "envelope.fill", "paperclip", "list.clipboard.fill"
            ]
        }
    }
}

