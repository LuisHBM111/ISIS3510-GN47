import Foundation

enum CampusMockData {
    static let templates: [ScheduleTemplate] = [
        ScheduleTemplate(
            name: "Horario Base",
            semester: "2026-1",
            classes: [
                ScheduleClass(day: "Lunes", title: "Desarrollo Móvil", code: "ISIS3510", startTime: "08:00", endTime: "09:20", building: "ML", room: "203"),
                ScheduleClass(day: "Martes", title: "Arquitectura de Software", code: "ISIS3204", startTime: "10:00", endTime: "11:20", building: "W", room: "101"),
                ScheduleClass(day: "Miércoles", title: "Tesis", code: "ISIS2007", startTime: "14:00", endTime: "15:20", building: "SD", room: "409")
            ]
        ),
        ScheduleTemplate(
            name: "Horario con Laboratorio",
            semester: "2026-1",
            classes: [
                ScheduleClass(day: "Lunes", title: "Desarrollo Móvil", code: "ISIS3510", startTime: "08:00", endTime: "09:20", building: "ML", room: "203"),
                ScheduleClass(day: "Jueves", title: "Laboratorio Móvil", code: "ISIS3510L", startTime: "16:00", endTime: "17:50", building: "ML", room: "Lab 2"),
                ScheduleClass(day: "Viernes", title: "Optimización Avanzada", code: "IIND3810", startTime: "11:00", endTime: "12:20", building: "AU", room: "305")
            ]
        )
    ]

    static let routeSteps: [String] = [
        "Sal por la entrada principal del edificio SD.",
        "Camina hacia el parque Espinoza.",
        "Sube por el parque hasta llegar al ML.",
        "Usa la entrada principal y llegarás al piso 2"
    ]

    static func dayIndex(_ day: String) -> Int {
        ["Lunes", "Martes", "Miércoles", "Jueves", "Viernes"].firstIndex(of: day) ?? 99
    }
}
