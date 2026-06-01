import Foundation
import Observation

@Observable
final class UserPreferences {
    var showWeather:    Bool { didSet { save("pref.showWeather",    showWeather) } }
    var showRuta:       Bool { didSet { save("pref.showRuta",       showRuta) } }
    var showHorario:    Bool { didSet { save("pref.showHorario",    showHorario) } }
    var showTraductor:  Bool { didSet { save("pref.showTraductor",  showTraductor) } }
    var showMapa:       Bool { didSet { save("pref.showMapa",       showMapa) } }
    var showTareas:     Bool { didSet { save("pref.showTareas",     showTareas) } }
    var showStats:      Bool { didSet { save("pref.showStats",      showStats) } }

    init() {
        let d = UserDefaults.standard
        showWeather   = d.object(forKey: "pref.showWeather")   as? Bool ?? true
        showRuta      = d.object(forKey: "pref.showRuta")      as? Bool ?? true
        showHorario   = d.object(forKey: "pref.showHorario")   as? Bool ?? true
        showTraductor = d.object(forKey: "pref.showTraductor") as? Bool ?? true
        showMapa      = d.object(forKey: "pref.showMapa")      as? Bool ?? true
        showTareas    = d.object(forKey: "pref.showTareas")    as? Bool ?? true
        showStats     = d.object(forKey: "pref.showStats")     as? Bool ?? true
    }

    private func save(_ key: String, _ value: Bool) {
        UserDefaults.standard.set(value, forKey: key)
    }
}
