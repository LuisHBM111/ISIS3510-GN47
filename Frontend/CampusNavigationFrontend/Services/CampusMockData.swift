//
//  CampusMockData.swift
//  CampusNavigationFrontend
//

import Foundation
import MapKit

enum CampusMockData {

    // MARK: - Buildings

    static let buildings: [CampusBuilding] = [
        CampusBuilding(
            name: "Edificio ML",
            shortName: "ML",
            coordinate: CLLocationCoordinate2D(latitude: 4.6030, longitude: -74.0651),
            category: .academic,
            description: "Facultad de Ingeniería y Ciencias",
            icon: "building.fill"
        ),
        CampusBuilding(
            name: "Edificio B",
            shortName: "B",
            coordinate: CLLocationCoordinate2D(latitude: 4.6015, longitude: -74.0664),
            category: .academic,
            description: "Facultad de Ciencias Sociales",
            icon: "building.fill"
        ),
        CampusBuilding(
            name: "Edificio R",
            shortName: "R",
            coordinate: CLLocationCoordinate2D(latitude: 4.6015, longitude: -74.0640),
            category: .academic,
            description: "Aulas generales y posgrados",
            icon: "building.fill"
        ),
        CampusBuilding(
            name: "Edificio Henry Yerli",
            shortName: "O",
            coordinate: CLLocationCoordinate2D(latitude: 4.6015, longitude: -74.0640),
            category: .academic,
            description: "Aulas generales y posgrados",
            icon: "building.fill"
        ),
        CampusBuilding(
            name: "Biblioteca General Ramón de Zubiría",
            shortName: "Biblioteca",
            coordinate: CLLocationCoordinate2D(latitude: 4.603145124835193, longitude: -74.06511214436118),
            category: .library,
            description: "Biblioteca central y salas de estudio",
            icon: "books.vertical.fill"
        ),
        CampusBuilding(
            name: "Sede Julio Mario Santo Domingo",
            shortName: "SD",
            coordinate: CLLocationCoordinate2D(latitude: 4.6031, longitude: -74.0649),
            category: .academic,
            description: "Auditorio y centros culturales",
            icon: "building.fill"
        ),
        CampusBuilding(
            name: "Edificio Arte y Diseño Tx",
            shortName: "TX",
            coordinate: CLLocationCoordinate2D(latitude: 4.601118603281187, longitude: -74.0636527660052),
            category: .academic,
            description: "Aulas , laboratorios y talleres",
            icon: "building.fill"
        ),
        CampusBuilding(
            name: "Edificio Arquitectura y Diseño",
            shortName: "C",
            coordinate: CLLocationCoordinate2D(latitude: 4.601347079437167, longitude: -74.065219450908),
            category: .academic,
            description: "Aulas y talleres",
            icon: "building.fill"
        ),
        CampusBuilding(
            name: "Centro Deportivo",
            shortName: "La Caneca",
            coordinate: CLLocationCoordinate2D(latitude: 4.600087848729064, longitude: -74.06259413809),
            category: .sports,
            description: "Gimnasio, piscina y canchas",
            icon: "figure.run"
        ),
        CampusBuilding(
            name: "Plaza de Comidas Bloque Z",
            shortName: "Plazoleta Z",
            coordinate: CLLocationCoordinate2D(latitude: 4.602720193216494, longitude: -74.06550224839602),
            category: .food,
            description: "Restaurantes y cafeterías del campus",
            icon: "fork.knife"
        ),
        CampusBuilding(
            name: "Saudade",
            shortName: "Saudade",
            coordinate: CLLocationCoordinate2D(latitude: 4.603372222323348, longitude: -74.06415097196215),
            category: .food,
            description: "Restaurantes y cafeterías del campus",
            icon: "fork.knife"
        ),
        CampusBuilding(
            name: "Ajiaco & Frijoles",
            shortName: "A&F",
            coordinate: CLLocationCoordinate2D(latitude: 4.603650235170581, longitude: -74.06565300928278),
            category: .food,
            description: "Restaurantes y cafeterías del campus",
            icon: "fork.knife"
        ),
        CampusBuilding(
            name: "Starbucks",
            shortName: "Starbucks",
            coordinate: CLLocationCoordinate2D(latitude: 4.602388278858029, longitude: -74.06537405985544),
            category: .food,
            description: "Restaurantes y cafeterías del campus",
            icon: "fork.knife"
        ),
    ]

    // MARK: - Schedules

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

    // MARK: - Routes

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
