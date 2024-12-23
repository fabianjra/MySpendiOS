//
//  CategoryIcons.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 21/10/24.
//

public enum CategoryIcons: String, CaseIterable, Identifiable {
    public var id: Self { self }
    
    case bills = "Bills"
    case foodAndDrink = "Food and Drink"
    case household = "Household"
    case travel = "Travel"
    
    var list: [String] {
        switch self {
        case .bills:
            return [
                "lightbulb.fill", "spigot.fill", "play.tv.fill", "tv.badge.wifi.fill",
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
                "tag.fill", "house.fill", "creditcard.fill", "banknote.fill", "wallet.pass.fill",
                "bag.fill", "gym.bag.fill", "handbag.fill", "person.fill", "figure.arms.open",
                "figure.2.arms.open", "figure.2.and.child.holdinghands", "figure.and.child.holdinghands",
                "envelope.fill", "paperclip", "list.clipboard.fill"
            ]
        case .travel:
            return ["figure.walk", "figure.walk.diamond.fill", "figure.walk.triangle.fill", "figure.wave",
                    "figure.wave.circle.fill", "airplane.circle.fill", "airplane", "airplane.arrival", "airplane.departure",
                    "car.fill", "car.badge.gearshape.fill", "bolt.car.fill", "car.2.fill", "bus.fill", "tram.fill", "cablecar.fill",
                    "lightrail.fill", "ferry.fill", "car.ferry.fill", "sailboat.fill", "truck.box.fill", "bicycle", "moped.fill",
                    "motorcycle.fill", "scooter", "fuelpump.fill", "ev.charger.fill",
            ]
        }
    }
}

