import Foundation

final class SessionManager {
    private static var instance: SessionManager?
    private init() {}
    class func getInstance() -> SessionManager {
        if instance == nil { instance = SessionManager() }
        return instance!
    }
    var idToken: String?
    var localId: String?
    var email: String?
    func set(idToken: String, localId: String, email: String) {
        self.idToken = idToken
        self.localId = localId
        self.email = email
    }
    func clear() {
        idToken = nil
        localId = nil
        email = nil
    }
}
