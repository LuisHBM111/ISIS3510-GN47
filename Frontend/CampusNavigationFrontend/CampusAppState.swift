import Foundation
import Combine

@MainActor
final class CampusAppState: ObservableObject {
    @Published var isLoggedIn = false
    @Published var currentUser: CampusUser?
    @Published var currentSchedule: ScheduleTemplate = CampusMockData.templates[0]
    @Published var editableClasses: [ScheduleClass] = CampusMockData.templates[0].classes
    @Published var currentRoute: RouteResponse?
    @Published var isLoggingIn = false
    @Published var isLoadingRoute = false
    @Published var isUploadingSchedule = false
    @Published var lastError: String?
    func login(email: String, password: String) async {
        let trimmed = email.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, !password.isEmpty else {
            lastError = "Debes ingresar correo y contraseña."
            return
        }
        isLoggingIn = true; lastError = nil
        defer { isLoggingIn = false }

        do {
            try await CampusAPI.login(email: trimmed, password: password)
            let name = trimmed.split(separator: "@").first.map(String.init)?.capitalized ?? "Estudiante"
            currentUser = CampusUser(name: name, email: trimmed)
            isLoggedIn = true
        } catch {
            lastError = error.localizedDescription
        }
    }

    func logout() {
        isLoggedIn = false
        currentUser = nil
        currentRoute = nil
    }
    func loadSchedule(_ template: ScheduleTemplate) {
        currentSchedule = template
        editableClasses = template.classes
    }

    func addClass(_ draft: ScheduleDraft) {
        let newClass = ScheduleClass(
            day: draft.day, title: draft.title, code: draft.code,
            startTime: draft.startTime, endTime: draft.endTime,
            building: draft.building, room: draft.room
        )
        editableClasses.append(newClass)
        editableClasses.sort { lhs, rhs in
            lhs.day == rhs.day
                ? lhs.startTime < rhs.startTime
                : CampusMockData.dayIndex(lhs.day) < CampusMockData.dayIndex(rhs.day)
        }
        currentSchedule = ScheduleTemplate(
            name: "Horario Personalizado",
            semester: currentSchedule.semester,
            classes: editableClasses
        )
    }

    func calculateRoute(origin: String, destination: String) async {
        let o = origin.trimmingCharacters(in: .whitespacesAndNewlines)
        let d = destination.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !o.isEmpty, !d.isEmpty else {
            lastError = "Debes ingresar origen y destino."
            return
        }
        isLoadingRoute = true; lastError = nil
        defer { isLoadingRoute = false }

        do {
            currentRoute = try await CampusAPI.route(from: o, to: d)
        } catch {
            currentRoute = nil
            lastError = error.localizedDescription
        }
    }

    func uploadScheduleFile(_ fileURL: URL) async {
        isUploadingSchedule = true; lastError = nil
        defer { isUploadingSchedule = false }

        let needsStop = fileURL.startAccessingSecurityScopedResource()
        defer { if needsStop { fileURL.stopAccessingSecurityScopedResource() } }

        do {
            let classes = try await CampusAPI.uploadSchedule(fileURL: fileURL)
            loadSchedule(ScheduleTemplate(
                name: "Horario Cargado",
                semester: currentSchedule.semester,
                classes: classes
            ))
        } catch {
            lastError = error.localizedDescription
        }
    }
}
