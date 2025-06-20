//
//  DateIntervalNavigatorViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 23/11/24.
//

import Foundation

struct DateIntervalNavigatorViewModel {
    
    /// Manipulate the Date value selected by navigation on an specific TeimInterval
    func navigateDateTime(_ selectedDate: Date, to timeNavigate: TimeNavigate, byAdding dateTimeInterval: DateTimeInterval) -> Date {
        
        if timeNavigate == .today {
            return .now
        } else {
            let timeToMove = timeNavigate == .next ? 1 : timeNavigate == .previous ? -1 : .zero
            
            if let newDate = Calendar.current.date(byAdding: dateTimeInterval.componentType, value: timeToMove, to: selectedDate) {
                return newDate
            } else {
                return selectedDate
            }
        }
    }
    
    func getHeader(_ selectedDate: Date, by timeInterval: DateTimeInterval) -> String {
        var header = ""
        
        let formatStyle = UtilsDate.getDateFormatStyleLocale
        let calendar = Calendar.current
        
        let isCurrentMonth = calendar.isDate(selectedDate, equalTo: .now, toGranularity: .month)
        let isCurrentYear = calendar.isDate(selectedDate, equalTo: .now, toGranularity: .year)
        
        switch timeInterval {
            
        case .day:
            header = getFormatDay(selectedDate, style: formatStyle, isCurrentMonth: isCurrentMonth, isCurrentYear: isCurrentYear)
            
        case .week:
            header = getFormatWeekday(selectedDate, style: formatStyle, calendar: calendar, isCurrentMonth: isCurrentMonth, isCurrentYear: isCurrentYear)
            
        case .month:
            header = getFormatMonth(selectedDate, style: formatStyle, isCurrentYear: isCurrentYear)
            
        case .year:
            header = getFormatYear(selectedDate, style: formatStyle)
        }
        
        return header
    }
    
    private func getFormatDay(_ selectedDate: Date, style formatStyle: Date.FormatStyle, isCurrentMonth: Bool, isCurrentYear: Bool) -> String {
        var format = isCurrentMonth ? formatStyle.day().weekday(.wide) : formatStyle.day().weekday().month()
        
        if !isCurrentYear {
            format = format.year()
        }
        
        return selectedDate.formatted(format)
    }
    
    private func getFormatWeekday(_ selectedDate: Date, style formatStyle: Date.FormatStyle, calendar: Calendar, isCurrentMonth: Bool, isCurrentYear: Bool) -> String {
        guard let weekInterval = Calendar.current.dateInterval(of: .weekOfYear, for: selectedDate) else {
            // It is supposed to no get here, this is only beacasue dateInterval is optional.
            return selectedDate.formatted(.dateTime.week().locale(Locale.current))
        }
        
        let startOfWeek = weekInterval.start
        // Gets the weekOfYear minus the monday.
        let endOfWeekSunday = calendar.date(byAdding: .second, value: -1, to: weekInterval.end) ?? weekInterval.end
        
        let isWeekInSameMonth = calendar.isDate(startOfWeek, equalTo: endOfWeekSunday, toGranularity: .month)

        let formatStyleLeading = isWeekInSameMonth ? formatStyle.day() : formatStyle.day().month()
        
        var formatStyleTrailing = UtilsDate.getDateFormatStyleLocale.day().month()
        
        if !isCurrentYear {
            formatStyleTrailing = formatStyleTrailing.year()
        }
        
        return startOfWeek.formatted(formatStyleLeading) + " - " + endOfWeekSunday.formatted(formatStyleTrailing)
    }
    
    private func getFormatMonth(_ selectedDate: Date, style formatStyle: Date.FormatStyle, isCurrentYear: Bool) -> String {
        let format = isCurrentYear ? formatStyle.month(.wide) : formatStyle.month().year()
        return selectedDate.formatted(format)
    }
    
    private func getFormatYear(_ selectedDate: Date, style formatStyle: Date.FormatStyle) -> String {
        let format = formatStyle.year()
        return selectedDate.formatted(format)
    }
}
