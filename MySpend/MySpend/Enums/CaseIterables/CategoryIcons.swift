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
    case clothes = "Clothes"
    case travel = "Travel"
    case sport = "Sports & Hobbies"
    case entertaiment = "Entertainment"
    case money = "Money"
    case animal = "Animals"
    
    var list: [String] {
        switch self {
        case .bills:
            return [
                "lightbulb.fill", "spigot.fill", "washer.fill", "powerplug.portrait.fill",
                "appletvremote.gen4.fill", "wifi", "wifi.router.fill", "phone.fill", "flame.fill",
                "umbrella.fill", "bolt.horizontal.fill", "externaldrive.connected.to.line.below.fill",
                "icloud.fill", "cross.case.fill", "stethoscope", "cross.vial.fill", "waveform.path.ecg.rectangle.fill",
                "trash.fill", "opticaldiscdrive.fill", "archivebox.fill", "document.fill", "burn"
            ]
        case .foodAndDrink:
            return [
                "fork.knife", "wineglass.fill", "cup.and.saucer.fill", "mug.fill", "waterbottle.fill",
                "birthday.cake.fill", "carrot.fill", "fireplace.fill", "oven.fill", "microwave.fill",
                "refrigerator.fill", "popcorn.fill", "frying.pan.fill", "cart.fill", "basket.fill", "fish.fill"
            ]
        case .household:
            return [
                "tag.fill", "house.fill", "wallet.pass.fill",
                "bag.fill", "gym.bag.fill", "handbag.fill", "person.fill", "figure.arms.open",
                "figure.2.arms.open", "figure.2.and.child.holdinghands", "figure.and.child.holdinghands",
                "envelope.fill", "paperclip", "list.clipboard.fill", "key.horizontal.fill",
                "at", "printer.fill", "shippingbox.fill", "screwdriver.fill", "wrench.and.screwdriver.fill",
                "paintbrush.fill", "thermometer.variable", "bed.double.fill", "heart.fill", "hammer.fill",
                "teddybear.fill"
            ]
        case .clothes:
            return [
                "tshirt.fill", "shoe.fill", "comb.fill", "mustache.fill", "hat.widebrim.fill", "hat.cap.fill", "jacket.fill",
                "coat.fill", "sunglasses.fill", "beach.umbrella.fill", "duffle.bag.fill"
            ]
        case .travel:
            return ["figure.walk", "figure.walk.diamond.fill", "figure.walk.triangle.fill", "figure.wave",
                    "figure.wave.circle.fill", "airplane.circle.fill", "airplane", "airplane.arrival", "airplane.departure",
                    "car.fill", "car.badge.gearshape.fill", "bolt.car.fill", "car.2.fill", "bus.fill", "tram.fill", "cablecar.fill",
                    "lightrail.fill", "ferry.fill", "car.ferry.fill", "sailboat.fill", "truck.box.fill", "bicycle", "moped.fill",
                    "motorcycle.fill", "scooter", "fuelpump.fill", "ev.charger.fill", "parkingsign", "car.side.rear.tow.hitch.fill",
                    "case.fill", "briefcase.fill", "suitcase.cart.fill", "suitcase.rolling.fill", "building.fill", "building.2.fill",
                    "building.columns.fill", "gauge.with.dots.needle.bottom.0percent", "engine.combustion.fill", "oilcan.fill", "backpack.fill"
            ]
        case .sport:
            return [
                "figure.skateboarding", "figure.water.fitness", "skateboard.fill", "figure.ice.skating", "figure.waterpolo", "figure.boxing",
                "figure.kickboxing", "dumbbell.fill", "soccerball", "baseball.fill", "basketball.fill", "american.football.fill", "tennis.racket",
                "tennisball.fill", "surfboard.fill", "rosette", "trophy.fill", "gamecontroller.fill", "gauge.with.needle.fill",
                "flag.2.crossed.fill", "figure.run", "figure.run.treadmill", "figure.badminton", "figure.baseball", "figure.jumprope", "figure.yoga",
                "figure.golf", "camera.fill", "tent.fill"
            ]
        case .entertaiment:
            return [
                "display", "laptopcomputer", "iphone.gen1", "ipad.gen1", "applewatch.side.right", "headphones", "airpods", "homepod.mini.fill", "hifispeaker.fill",
                "appletv.fill", "tv.fill", "play.tv.fill", "music.note.tv.fill", "tv.badge.wifi.fill", "sparkles.tv.fill", "arcade.stick.console.fill", "av.remote.fill",
                "theatermasks.fill", "balloon.fill", "formfitting.gamecontroller.fill", "movieclapper.fill", "books.vertical.fill", "photo.artframe", "puzzlepiece.fill",
                "party.popper.fill"
                ]
        case .money:
            return [
                "creditcard.fill", "banknote.fill", "centsign.bank.building.fill", "dollarsign.bank.building.fill", "bitcoinsign", "coloncurrencysign", "dollarsign",
                "eurosign", "signature", "chart.bar.fill", "chart.pie.fill", "chart.line.uptrend.xyaxis", "wallet.bifold.fill", "graduationcap.fill"
            ]
        case .animal:
            return [
                "pawprint.fill", "dog.fill", "cat.fill", "tortoise.fill", "lizard.fill", "bird.fill", "ant.fill", "fossil.shell.fill",
                "hare.fill"
            ]
        }
    }
}

