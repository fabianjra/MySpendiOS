//
//  UtilsDate.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 23/11/24.
//

import Foundation

struct UtilsDate {
    
    /**
     Convert a given date to string in short format: dd/MM/yyy. Ejem: 29/05/1990
     
     **Example:**
     ```swift
     DatePicker(selection: $selectedDate, displayedComponents: .date) {
         
     }
     .onChange(of: selectedDate, perform: { _ in

         dateString = Utils.dateToStringShort(date: selectedDate)
         
         let day = selectedDate.formatted(.dateTime.day())
     })
     ```
     
     - Returns: String short date: dd/MM/yyy
     
     - Authors: Fabian Rodriguez
     
     - Date: Sep 2023
     */
    private static func dateToStringShort(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "es_CR")
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: date)
    }
    
    private static func stringShortDateToDate(dateShort: String) -> Date {
        let dateFormatter = DateFormatter()
        //dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.locale = Locale(identifier: "es_CR")
        dateFormatter.dateFormat = "dd/MM/yyy"
        let date = dateFormatter.date(from:dateShort) ?? .now
        return date
    }
    
    /**
     Retrieves the current locale's language code or a default value.
     
     This function provides the current language code based on the user's preferred languages.
     If the preferred languages list is empty, it falls back to the device's current locale.
     If neither is available, it defaults to `"en_US"`.
     
     **Example:**
     ```swift
     let format = Date.FormatStyle().locale(Locale(identifier: UtilsDate.getLocaleCurrentCode)).day().weekday()
     
     let dateToShow = Date().formatted(format)
     ```

     - Returns: A `String` representing the language code of the current locale or the fallback `"en_US"`
     
     - Authors: Fabian Rodriguez
     - Date: November 2024
     */
    private static var getLocaleCurrentCode: String {
        return Locale.preferredLanguages.first ?? Locale.current.language.languageCode?.identifier ?? "en_US"
    }
    
    /**
     Creates a localized `Date.FormatStyle` configured with the current locale.
     
     This function generates a `Date.FormatStyle` object with the appropriate locale settings
     based on the device's user preferences or a default value (`"en_US"`).
     The locale assignment customizes the date format to the user's language and regional preferences.
     
     **Example:**
     ```swift
     let dateFormatStyle = UtilsDate.getDateFormatStyleLocale
     let formattedDate = Date.now.formatted(dateFormatStyle.day().month().year())
     print(formattedDate) // Outputs a localized date string based on the current locale
     ```

     - Returns: A `Date.FormatStyle` configured with the user's preferred locale
     
     - Authors: Fabian Rodriguez
     - Date: November 2024
     */
    public static var getDateFormatStyleLocale: Date.FormatStyle {
        let dateFormatStyle = Date.FormatStyle().locale(Locale(identifier: getLocaleCurrentCode))
        
        // Add new properties if needed.
        //dateFormatStyle.timeZone = TimeZone.current
        //dateFormatStyle.capitalizationContext = .beginningOfSentence
        
        return dateFormatStyle
    }
    
    /**
     Normalizes a given date by adjusting its time depending on whether it is in the past or not.
     - If the date is **before today** (ignoring hours/minutes/seconds), its time will be set to the **end of the day (23:59:59)**.
     - If the date is **today or in the future**, the original time will be preserved.
     
     Esto se hace asi, porque si se agrega una transaccion en un dia anterior a hoy, debe qudar totalmente arriba ya que la fecha ya pasó y seria la ultima(s).
     Si la transacción se agrega a futuro, entonces debe ser al inicio del dia y en la vista de `DateIntervalNavigatorView` ya se maneja la logica de set a 00:00:00
     
     - Parameters:
        - date: The `Date` to normalize.
     
     - Returns: A normalized `Date` with adjusted time.
     
     - Authors: Fabian Rodriguez.
     - Date: Sep 2025
     */
    static func normalizeTransactionDate(_ date: Date) -> Date {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date.now)
        let transactionDay = calendar.startOfDay(for: date)
        
        if transactionDay < today {
            // Date is in the past -> set to last second of the day (23:59:59)
            return calendar.date(bySettingHour: 23, minute: 59, second: 59, of: date) ?? date
        } else {
            // Date is today or in the future -> keep as is
            return date
        }
    }
}
