//
//  TextPlainLocalized.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 26/7/25.
//

import SwiftUI

/**
 A flexible text component that renders **either**
 1. a `LocalizedStringKey` coming from any enum that conforms to `LocalizableProtocol`, **or**
 2. an ad-hoc `LocalizedStringKey` supplied directly, while exposing a single, uniform API for colour, font and line-breaking options.
 
 The view is generic over `E`, constrained to `LocalizableProtocol`.
 When you pass an enum case (`E`), the view pulls both the
 *key* **and** its *table name* from that case.
 When you need a literal `LocalizedStringKey` instead, use the
 `init(textLocalized:table: …)` overload; the generic type is
 inferred as `Never`, thanks to the conformance below.

 ### Usage

 ```swift
 // 1️⃣ Enum-based (table resolved automatically)
 TextPlainLocalized(Localizable.Onboarding.title)

 // 2️⃣ Literal key + table
 TextPlainLocalized(
     textLocalized: "greet \(username) \(emoji)",
     table: Tables.transaction,
     family: .semibold,
     size: .big)
 ```

 > **Note**
 > `LocalizedStringKey` honours `Environment(\.locale)` in Previews,
 > so this view localises correctly inside `#Preview` blocks.

 ### Generic Parameters
 * `E` – any type that conforms to `LocalizableProtocol`.
   Use `Never` implicitly when you initialise with
   `textLocalized:`.

 ### Initialisers
 * `init(_:table:colour:family:size:aligment:lineLimit:truncateMode:)`
   Accepts an optional enum case (`E`) **or** a `LocalizedStringKey`.
 * `init(textLocalized:table:colour:family:size:aligment:lineLimit:truncateMode:)`
   Convenience overload for the “plain key” scenario
   (available when `E == Never`).

 ### Styling parameters
 * `colour`      – foreground colour (default `Color.textPrimaryForeground`)
 * `family`      – custom Montserrat weight
 * `size`        – custom semantic size
 * `aligment`    – multiline text alignment
 * `lineLimit`   – maximum number of lines
 * `truncateMode` – tail/middle/head truncation

 ### Implementation notes
 * `Text` chooses the key and table at runtime:

   ```swift
   Text(
     (localizedEnum == nil ? textLocalized : localizedEnum?.key) ?? "",
     tableName: localizedEnum == nil ? table : localizedEnum?.table)
   ```

 * `Never` is extended to conform to `LocalizableProtocol` so the
   overload can specialise `E == Never` without boiler-plate.
 */
struct TextPlainLocalized<E: LocalizableProtocol>: View {
    private let localizedEnum: E?
    private let textLocalized: LocalizedStringKey?
    private let table: String?
    
    private let color: Color
    private let family: Font.Family
    private let size: Font.Sizes
    private let aligment: TextAlignment
    private let lineLimit: Int
    private let truncateMode: Text.TruncationMode
    
    init(_ localizedEnum: E? = nil,
         textLocalized: LocalizedStringKey? = nil,
         table: String? = nil,
         
         color: Color = Color.textPrimaryForeground,
         family: Font.Family = Font.Family.regular,
         size: Font.Sizes = Font.Sizes.body,
         aligment: TextAlignment = TextAlignment.leading,
         lineLimit: Int = ConstantViews.singleTextMaxLines,
         truncateMode: Text.TruncationMode = Text.TruncationMode.tail) {
        self.localizedEnum = localizedEnum
        self.textLocalized = textLocalized
        self.table = table
        
        self.color = color
        self.family = family
        self.size = size
        self.aligment = aligment
        self.lineLimit = lineLimit
        self.truncateMode = truncateMode
    }
    
    var body: some View {
        Text((localizedEnum == nil ? textLocalized : localizedEnum?.key) ?? "", tableName: localizedEnum == nil ? table : localizedEnum?.table)
            .foregroundColor(color)
            .font(.montserrat(family, size: size))
            .multilineTextAlignment(aligment)
            .truncationMode(truncateMode)
            .lineLimit(lineLimit)
    }
}

extension Never: LocalizableProtocol {
    var rawValue: String { "" }
    var key: LocalizedStringKey { "" }
    var table: String { "" }
}

extension TextPlainLocalized where E == Never {
    init(textLocalized: LocalizedStringKey,
         table: String? = nil,
         color: Color = .textPrimaryForeground,
         family: Font.Family = .regular,
         size: Font.Sizes = .body,
         aligment: TextAlignment = .leading,
         lineLimit: Int = ConstantViews.singleTextMaxLines,
         truncateMode: Text.TruncationMode = .tail) {
        
        self.localizedEnum = nil
        self.textLocalized = textLocalized
        self.table = table
        self.color = color
        self.family = family
        self.size = size
        self.aligment = aligment
        self.lineLimit = lineLimit
        self.truncateMode = truncateMode
    }
}


#Preview("ESPA") {
    VStack {
        TextPlainLocalized(Localizable.Onboarding.title)
            .padding()
    }
    .background(Color.backgroundBottom)
    .environment(\.locale, .init(identifier: Previews.localeES))
}

#Preview(Previews.localeES) {
    VStack {
        Spacer()
        
        TextPlainLocalized(textLocalized: "This is a plain message without localized key")
            .padding()
        
        TextPlainLocalized(textLocalized: "large text large text large text large text large text large text",
                  lineLimit: 2,
                  truncateMode: .middle)
        .padding()
            
        Spacer()
    }
    .background(Color.backgroundBottom)
    .environment(\.locale, .init(identifier: Previews.localeES))
}

#Preview(Previews.localeEN) {
    VStack {
        TextPlainLocalized(textLocalized: "title")
            .padding()
    }
    .background(Color.backgroundBottom)
    .environment(\.locale, .init(identifier: Previews.localeEN))
}
