//
//  ConstantIcons.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 21/10/24.
//

struct Icons: Hashable {
    let name: String
    let list: [String]
}

struct ConstantIcons {
    
    static let iconList: [Icons] = [billsFillModel, foodDrinkFillModel, householdFillModel]
    
    static let defaultIcon: String = "tag.fill"
    
    private static let billsFillModel: Icons = Icons(name: "Bills", list: billsFill)
    private static let billsFill: [String] = ["lightbulb.fill",
                                      "spigot.fill",
                                      "house.fill",
                                      "play.tv.fill",
                                      "tv.badge.wifi.fill",
                                      "appletvremote.gen4.fill",
                                      "wifi",
                                      "wifi.router.fill",
                                      "phone.fill",
                                      "flame.fill",
                                      "umbrella.fill",
                                      "chart.bar.fill",
                                      "bolt.horizontal.fill",
                                      "externaldrive.connected.to.line.below.fill",
                                      "icloud.fill" ]
    
    private static let foodDrinkFillModel: Icons = Icons(name: "Food and Drink", list: foodDrinkFill)
    private static let foodDrinkFill: [String] = ["fork.knife",
                                          "wineglass.fill",
                                          "cup.and.saucer.fill",
                                          "mug.fill",
                                          "waterbottle.fill",
                                          "birthday.cake.fill",
                                          "carrot.fill",
                                          "fireplace.fill",
                                          "oven.fill",
                                          "microwave.fill",
                                          "refrigerator.fill",
                                          "popcorn.fill",
                                          "frying.pan.fill", "cart.fill", "basket.fill"]
    
    private static let householdFillModel: Icons = Icons(name: "Household", list: householdFill)
    private static let householdFill: [String] = ["house.fill",
                                          "tag.fill",
                                          "creditcard.fill",
                                          "banknote.fill",
                                          "wallet.pass.fill",
                                          "bag.fill",
                                          "gym.bag.fill",
                                          "handbag.fill",
                                          "person.fill",
                                          "figure.arms.open",
                                          "figure.2.arms.open",
                                          "figure.2.and.child.holdinghands",
                                          "figure.and.child.holdinghands",
                                          "envelope.fill",
                                          "paperclip",
                                          "list.clipboard.fill"]
}
