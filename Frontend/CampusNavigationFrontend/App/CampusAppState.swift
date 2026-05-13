import Foundation
import Observation

@MainActor
@Observable
final class CampusAppState {
    var isLoggedIn = false
    var currentUser: CampusUser?
    var currentSchedule: ScheduleTemplate = CampusMockData.templates[0]
    var editableClasses: [ScheduleClass] = CampusMockData.templates[0].classes
    var loginError: String?
    var isAuthenticating = false

    func login(email: String, password: String) async {
        guard !email.isEmpty, !password.isEmpty else {
            loginError = "Debes ingresar correo y contraseña."
            return
        }
        isAuthenticating = true
        loginError = nil
        defer { isAuthenticating = false }
        do {
            let resp = try await CampusAPI.signIn(email: email, password: password)
            SessionManager.getInstance().set(idToken: resp.idToken, localId: resp.localId, email: resp.email)
            let prefix = resp.email.split(separator: "@").first.map(String.init) ?? "Estudiante"
            currentUser = CampusUser(name: prefix.capitalized, email: resp.email)
            isLoggedIn = true
        } catch {
            loginError = error.localizedDescription
        }
    }

    func signUp(email: String, password: String) async {
        guard !email.isEmpty, !password.isEmpty else {
            loginError = "Debes ingresar correo y contraseña."
            return
        }
        isAuthenticating = true
        loginError = nil
        defer { isAuthenticating = false }
        do {
            let resp = try await CampusAPI.signUp(email: email, password: password)
            SessionManager.getInstance().set(idToken: resp.idToken, localId: resp.localId, email: resp.email)
            let prefix = resp.email.split(separator: "@").first.map(String.init) ?? "Estudiante"
            currentUser = CampusUser(name: prefix.capitalized, email: resp.email)
            isLoggedIn = true
        } catch {
            loginError = error.localizedDescription
        }
    }

    func logout() {
        SessionManager.getInstance().clear()
        currentUser = nil
        isLoggedIn = false
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
