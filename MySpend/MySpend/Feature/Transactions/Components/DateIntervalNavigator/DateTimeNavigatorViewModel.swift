//
//  DateTimeNavigatorViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 23/11/24.
//

import Foundation

struct DateTimeNavigatorViewModel {
    
    /**
     Navigates between dates according to the selected interval.
     
     - Day: Moves one day forward or backward.
     - Week: Moves to the beginning of the previous or next week.
     - Month: Moves to the first day of the previous or next month.
     - Year: Moves to the first day of the previous or next year.
     
     When navigating to the current week, month, or year, the selected date is restored to the current date.
     
     - Parameters:
     - selectedDate: The currently selected date.
     - timeNavigate: The navigation direction.
     - dateTimeInterval: The interval used for navigation.
     - Returns: The new selected date.
     */
    func navigateDateTime(_ selectedDate: Date, to timeNavigate: TimeNavigate, byAdding dateTimeInterval: DateTimeInterval) -> Date {
        
        let calendar = Calendar.current
        let now = Date.now
        
        // Return to the current date when the user selects Today.
        if timeNavigate == .today {
            return now
        }
        
        let timeToMove: Int
        
        switch timeNavigate {
            
        case .previous:
            timeToMove = -1
            
        case .next:
            timeToMove = 1
            
        case .today:
            return now
        }
        
        // Get the beginning of the selected period.
        // This avoids carrying over the original day when navigating
        // between months or years (e.g., January 31 -> February 1).
        guard let currentInterval = calendar.dateInterval(of: dateTimeInterval.componentType, for: selectedDate) else {
            return selectedDate
        }
        
        // Navigate from the beginning of the period.
        guard let newDate = calendar.date(byAdding: dateTimeInterval.componentType, value: timeToMove, to: currentInterval.start) else {
            return selectedDate
        }
        
        // Daily navigation must preserve the selected day
        // without automatically returning to Today.
        if dateTimeInterval == .day {
            return calendar.startOfDay(for: newDate)
        }
        
        // When navigating to the current week, month, or year,
        // restore the actual current date instead of the period's first day.
        if let newInterval = calendar.dateInterval(of: dateTimeInterval.componentType, for: newDate), newInterval.contains(now) {
            return now
        }
        
        /*
         `Calendar.startOfDay(for:)` returns the beginning of the
         specified day according to the current calendar and time zone.
         
         This helper is used to:
         
         • Ensure navigation ends at the beginning of the selected day,
         without carrying over the original hours, minutes, or seconds.
         
         • Avoid manually setting hour, minute, and second components,
         reducing potential issues with daylight saving time.
         
         Example:
         
         January 31, 2026 at 18:42 + 1 month -> February 1, 2026
         startOfDay(...) -> February 1, 2026 at the start of the day.
         */
        return calendar.startOfDay(for: newDate)
    }
    
    /**
     Restores the current date when switching to the current
     week, month, or year.

     Daily navigation preserves the selected date.
     */
    func normalizeDateTime(_ selectedDate: Date, for dateTimeInterval: DateTimeInterval) -> Date {
        guard dateTimeInterval != .day,
              let interval = Calendar.current.dateInterval(of: dateTimeInterval.componentType,
                                                           for: selectedDate),
              interval.contains(Date.now) else {
            
            return selectedDate
        }

        return .now
    }
    
    /**
     Returns a localized date header according to the selected interval.
     
     The date format adapts to the current year and the selected
     interval to avoid displaying unnecessary information.
     */
    func getHeader(_ selectedDate: Date, by timeInterval: DateTimeInterval) -> String {
        
        let identifier = Locale.preferredLanguages.first ?? Locale.current.identifier
        let formatStyle = Date.FormatStyle().locale(Locale(identifier: identifier))
        
        let calendar = Calendar.current
        let now = Date.now
        
        let isCurrentYear = calendar.isDate(selectedDate, equalTo: now, toGranularity: .year)
        
        switch timeInterval {
            
        case .day:
            return getFormatDay(selectedDate, style: formatStyle, isCurrentYear: isCurrentYear)
            
        case .week:
            return getFormatWeekday(selectedDate, style: formatStyle, calendar: calendar, isCurrentYear: isCurrentYear)
            
        case .month:
            return getFormatMonth(selectedDate, style: formatStyle, isCurrentYear: isCurrentYear)
            
        case .year:
            return getFormatYear(selectedDate, style: formatStyle)
        }
    }
    
    /**
     Formats the selected day.
     
     Includes the year only when the selected date
     belongs to a different year.
     */
    private func getFormatDay(_ selectedDate: Date, style formatStyle: Date.FormatStyle, isCurrentYear: Bool) -> String {
        
        let format = isCurrentYear
        ? formatStyle.day().weekday(.wide).month()
        : formatStyle.day().weekday().month().year()
        
        return selectedDate.formatted(format)
    }
    
    /**
     Formats the selected week as a localized date range.
     
     Includes the month in the starting date only when the
     week spans multiple months.
     
     Includes the year in the ending date when the week
     belongs to a different year.
     */
    private func getFormatWeekday(_ selectedDate: Date, style formatStyle: Date.FormatStyle, calendar: Calendar, isCurrentYear: Bool) -> String {
        
        guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: selectedDate) else {
            
            // It is not expected to reach this point.
            // This fallback handles a missing calendar interval.
            return selectedDate.formatted(
                .dateTime.week().locale(Locale.current)
            )
        }
        
        let startOfWeek = weekInterval.start
        
        // The end of a DateInterval is exclusive.
        // Subtract one calendar day to obtain the last day of the week.
        let endOfWeek = calendar.date(byAdding: .day, value: -1, to: weekInterval.end) ?? startOfWeek
        
        let isWeekInSameMonth = calendar.isDate(startOfWeek, equalTo: endOfWeek, toGranularity: .month)
        
        let formatStyleLeading = isWeekInSameMonth
        ? formatStyle.day()
        : formatStyle.day().month()
        
        var formatStyleTrailing = formatStyle.day().month()
        
        if !isCurrentYear {
            formatStyleTrailing = formatStyleTrailing.year()
        }
        
        return startOfWeek.formatted(formatStyleLeading) + " - " + endOfWeek.formatted(formatStyleTrailing)
    }
    
    /**
     Formats the selected month.
     
     Includes the year only when the selected month
     belongs to a different year.
     */
    private func getFormatMonth(_ selectedDate: Date, style formatStyle: Date.FormatStyle, isCurrentYear: Bool) -> String {
        
        let format = isCurrentYear
        ? formatStyle.month(.wide)
        : formatStyle.month().year()
        
        return selectedDate.formatted(format)
    }
    
    /**
     Formats the selected year using the current locale.
     */
    private func getFormatYear(_ selectedDate: Date, style formatStyle: Date.FormatStyle) -> String {

        return selectedDate.formatted(formatStyle.year())
    }
}
