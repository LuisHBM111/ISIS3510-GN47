import Foundation

struct CampusUser {
    let name: String
    let email: String
}

struct ScheduleClass: Identifiable, Hashable {
    let id = UUID()
    let day: String
    let title: String
    let code: String
    let startTime: String
    let endTime: String
    let building: String
    let room: String

    var locationText: String {
        "\(building) • \(room)"
    }
}

struct ScheduleTemplate: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let semester: String
    let classes: [ScheduleClass]
}

struct ScheduleDraft {
    var title = ""
    var code = ""
    var day = "Lunes"
    var startTime = "08:00"
    var endTime = "09:20"
    var building = ""
    var room = ""
}

enum CampusDestination: Hashable {
    case route
    case createSchedule
    case loadSchedule
}
