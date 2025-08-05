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
            return Date.now
        }
        
        let timeToMove = timeNavigate == .next ? 1 : timeNavigate == .previous ? -1 : .zero
        
        guard let newDate = Calendar.current.date(byAdding: dateTimeInterval.componentType,
                                                  value: timeToMove,
                                                  to: selectedDate)
        else { return selectedDate }
        
        // Normalise to “first unit” and 00:00
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: newDate)
        
        switch dateTimeInterval {
        case .day, .week:
            break // keep day/month, just zero the time
            
        case .month:
            components.day = 1
            break
            
        case .year:
            components.day = 1
            components.month = 1
            break
        }
        
        // Devuelve a las 00:00 h
        return calendar.date(from: components).map {
            
            /*
             `Calendar.startOfDay(for:)` devuelve la misma fecha pero **ajustada a la medianoche local (00 h 00 m 00 s)**
             Respeta calendario y zona horaria.
             
             En este helper se emplea para:
             
             • Garantizar que toda navegación (día, semana, mes o año) termine en las 00:00:00 y no arrastre la hora/minuto/segundo original.
             Evita saltos visuales inesperados y hace coherentes las comparaciones/cálculos.
             
             • Evitar rellenar manualmente los componentes `hour`, `minute`, `second`, reduciendo errores con DST u otros calendarios.
             
             Ejemplo:
             4 ago 2025 18:42  +1 mes   → 4 sep 2025 18:42  (hora heredada)
             startOfDay(...)           → 1 sep 2025 00:00  (día 1 + hora 0)
             */
            calendar.startOfDay(for: $0)
            
        } ?? newDate
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
        var format = formatStyle.day()
        
        if isCurrentYear {
            format = format.weekday(.wide).month()
        } else {
            format = format.weekday().month().year()
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
