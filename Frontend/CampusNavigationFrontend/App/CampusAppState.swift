import Foundation
import Observation

struct FeatureStat: Identifiable {
    let id = UUID()
    let name: String
    let count: Int
}

@MainActor
@Observable
final class CampusAppState {
    var isLoggedIn = false
    var topFeatures: [FeatureStat] = []
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
            await loadCachedSchedule(for: resp.localId)
            //para multi-thread de calcular rutas
            //aca uso task detach porque es @MainActor, entonces nun task{} bloquearia el Main -> corre en thread pool
            //background le dice que priorice otras cosas
            Task.detached(priority: .background) {
                await RoutePrefetchService.prefetchTopRoutes()
            }
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
            await loadCachedSchedule(for: resp.localId)
            Task.detached(priority: .background) {
                await RoutePrefetchService.prefetchTopRoutes()
            }
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
        let start = Date()
        currentSchedule = template
        editableClasses = template.classes
        Task {
            await TimingAnalyticsViewModel.shared.record(action: "schedule", start: start)
        }
    }

    func addClass(_ draft: ScheduleDraft) {
        let start = Date()
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
        Task {
            if let userId = SessionManager.getInstance().localId {
                let key = CampusCache.scheduleKey(for: userId)
                await CampusCache.shared.save(editableClasses, key: key)
            }
            await TimingAnalyticsViewModel.shared.record(action: "schedule", start: start)
        }
    }

    func removeClass(_ item: ScheduleClass) {
        editableClasses.removeAll { $0.id == item.id }
        currentSchedule = ScheduleTemplate(
            name: "Horario Personalizado",
            semester: currentSchedule.semester,
            classes: editableClasses
        )
        if let userId = SessionManager.getInstance().localId {
            let key = CampusCache.scheduleKey(for: userId)
            Task { await CampusCache.shared.save(editableClasses, key: key) }
        }
    }

    func loadCachedSchedule(for userId: String) async {
        let key = CampusCache.scheduleKey(for: userId)
        if let saved = await CampusCache.shared.load([ScheduleClass].self, key: key), !saved.isEmpty {
            editableClasses = saved
            currentSchedule = ScheduleTemplate(
                name: "Horario Personalizado",
                semester: currentSchedule.semester,
                classes: saved
            )
        }
        await loadFeatureStats()
    }

    func trackFeature(_ name: String) async {
        var counts = await CampusCache.shared.load([String: Int].self, key: CampusCache.featureCountsKey) ?? [:]
        counts[name, default: 0] += 1
        await CampusCache.shared.save(counts, key: CampusCache.featureCountsKey)
        await loadFeatureStats()
    }

    func loadFeatureStats() async {
        let counts = await CampusCache.shared.load([String: Int].self, key: CampusCache.featureCountsKey) ?? [:]
        topFeatures = counts
            .sorted { $0.value > $1.value }
            .map { FeatureStat(name: $0.key, count: $0.value) }
    }
}
