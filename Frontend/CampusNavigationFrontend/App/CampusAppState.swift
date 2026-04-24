import Foundation
import Observation

@MainActor
@Observable
final class CampusAppState {
    var isLoggedIn = false
    var currentUser: CampusUser?
    var currentSchedule: ScheduleTemplate = CampusMockData.templates[0]
    var editableClasses: [ScheduleClass] = CampusMockData.templates[0].classes

    func login(email: String, password: String) {
        guard !email.isEmpty, !password.isEmpty else { return }
        let prefix = email.split(separator: "@").first.map(String.init) ?? "Estudiante"
        currentUser = CampusUser(name: prefix.capitalized, email: email)
        isLoggedIn = true
    }

    func loadSchedule(_ template: ScheduleTemplate) {
        currentSchedule = template
        editableClasses = template.classes
    }

    func addClass(_ draft: ScheduleDraft) {
        let newClass = ScheduleClass(
            day: draft.day,
            title: draft.title,
            code: draft.code,
            startTime: draft.startTime,
            endTime: draft.endTime,
            building: draft.building,
            room: draft.room
        )
        editableClasses.append(newClass)
        editableClasses.sort { lhs, rhs in
            if lhs.day == rhs.day {
                return lhs.startTime < rhs.startTime
            }
            return CampusMockData.dayIndex(lhs.day) < CampusMockData.dayIndex(rhs.day)
        }
        currentSchedule = ScheduleTemplate(
            name: "Horario Personalizado",
            semester: currentSchedule.semester,
            classes: editableClasses
        )
    }
}
