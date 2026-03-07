import SwiftUI

struct CampusInteractivoView: View {
    private let primary = Color(campusHex: "#FFE11F")
    private let secondary = Color(campusHex: "#FFD100")
    private let surface = Color(campusHex: "#F5F5F5")
    private let darkText = Color(campusHex: "#202020")
    private let grayText = Color(campusHex: "#666666")

    private let services: [NearbyService] = [
        .init(
            name: "Starbucks (Student Union)",
            subtitle: "Until 8:00 PM • 3 min walk",
            status: "OPEN",
            statusColor: .green,
            imageURL: "https://lh3.googleusercontent.com/aida-public/AB6AXuAzNid7TQucxDWyayDi5MxLocJFnbsF1pw2KkgHnPyAOthN2ReK4q2ljoAENqTebv4DrekPsX6s8m-_WLb4oFTHEekYD5DgfSGWtaAqacWiGFYW4IREuB3ZeaPSTEA3g69X1TL1jqBM9xef-QpAeAd8EsoPpv2Wyy3NNvDrr7YQC8nULms4Tk4xyNP149fc58gdWYL0C4ePM0dvvEZ2O684t_fVH42erGxeOuD7S3hnjoc7JWIhG_8julPJzUvoeVKgGAmb4MNb2jti"
        ),
        .init(
            name: "Engineering Quiet Zone",
            subtitle: "85% full • 7 min walk",
            status: "BUSY",
            statusColor: .red,
            imageURL: "https://lh3.googleusercontent.com/aida-public/AB6AXuDuWqzTcq8YJF9uI0_nMNLJRnrOj4dV80aqTQXLEebkXO9vCLIStUFR7jxYoo-vFwkwpUm9PlGKTKoOS3uzw5JZtdwefmRT3Vqg9ulalZ065X_H51hdUBCBEgbpyVIfBhMfw-zMmRqCG2fcTLY3KMRqxZ6z_UKYbsc1sBkCJFN8XQRFAPbBdJm28z41zTNHzORxi89HRqLWBylnH1d-Ql-M5GcRk-4a7IyoqUCWDyHe_pq36PR9DH3ASMgSW5pBiuJ9JH5_Ch8gWx_z"
        )
    ]

    var body: some View {
        ZStack(alignment: .bottom) {
            mapLayer
            topControls
            rightButtons
            bottomSheet
            tabBar
        }
        .ignoresSafeArea()
        .background(.white)
    }

    private var mapLayer: some View {
        ZStack {
            AsyncImage(url: URL(string: "https://lh3.googleusercontent.com/aida-public/AB6AXuB8fblri5muZi-o-slo9HWi4kKkZZm8p_If4bzbvEvP5RCsVortsqnm55PI0wR46-1GqPE9Ro019U6CAIEJJVmp0RC3POJTvdOTU_EbTJq3miJjhY0FohCxFMNcrBSvniOOwWfdhGKa-HB3EbER5Hk-xmk_keOko8Fmbcozjj1kZDaGXQvXxNkh0nJ9mDc_F4IOd-Yqc8zTgmqiTlWdoHhxywZFJyR4Dy5bgiZ47Z-YAtH4p2SomWtII-ojFaytBx45cC8zKRdkL8Qq")) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                surface
            }
            .overlay(Color.white.opacity(0.18))

            Path { path in
                path.move(to: .init(x: 80, y: 270))
                path.addLine(to: .init(x: 170, y: 320))
                path.addLine(to: .init(x: 240, y: 400))
                path.addLine(to: .init(x: 250, y: 500))
            }
            .stroke(
                secondary,
                style: .init(lineWidth: 4, lineCap: .round, lineJoin: .round, dash: [8, 6])
            )

            Group {
                mapPin(icon: "graduationcap.fill", title: "Science Hall", filled: true)
                    .position(x: 95, y: 260)

                mapPin(icon: "book.closed.fill", title: "Central Library", filled: true)
                    .position(x: 290, y: 330)

                mapPin(icon: "fork.knife", title: "Campus Dining", filled: false)
                    .position(x: 190, y: 430)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var topControls: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                Text("Where to?")
                    .foregroundStyle(darkText.opacity(0.5))
                Spacer()
                Image(systemName: "mic.fill")
                    .foregroundStyle(grayText)
                Circle()
                    .fill(primary)
                    .frame(width: 30, height: 30)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.caption2.bold())
                    )
            }
            .padding(12)
            .background(.white, in: RoundedRectangle(cornerRadius: 16))
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(.black.opacity(0.06)))

            HStack(spacing: 8) {
                chip(icon: "globe", text: "English")
                chip(icon: "square.3.layers.3d", text: "3D Map")
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 58)
        .frame(maxHeight: .infinity, alignment: .top)
    }

    private var rightButtons: some View {
        VStack(spacing: 10) {
            floatingButton("square.3.layers.3d")
            floatingButton("location.fill")
            Button {} label: {
                Image(systemName: "arrow.triangle.turn.up.right.diamond.fill")
                    .font(.title2.bold())
                    .foregroundStyle(.black)
                    .frame(width: 56, height: 56)
                    .background(primary, in: RoundedRectangle(cornerRadius: 14))
                    .shadow(color: primary.opacity(0.45), radius: 8, y: 4)
            }
        }
        .padding(.trailing, 14)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
        .padding(.bottom, 285)
    }

    private var bottomSheet: some View {
        VStack(spacing: 0) {
            Capsule()
                .fill(.gray.opacity(0.2))
                .frame(width: 46, height: 6)
                .padding(.top, 10)
                .padding(.bottom, 14)

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 14) {
                    HStack {
                        Text("Nearby Services")
                            .font(.title3.bold())
                            .foregroundStyle(darkText)
                        Spacer()
                        Text("See all")
                            .font(.caption.bold())
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(primary, in: Capsule())
                    }

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            categoryChip(icon: "cup.and.saucer.fill", text: "Cafes", active: true)
                            categoryChip(icon: "book.fill", text: "Libraries", active: false)
                            categoryChip(icon: "chair.fill", text: "Study Spots", active: false)
                            categoryChip(icon: "printer.fill", text: "Print", active: false)
                        }
                    }

                    VStack(spacing: 12) {
                        ForEach(services) { service in
                            serviceCard(service)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 395)
        .background(.white, in: RoundedRectangle(cornerRadius: 38, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 38, style: .continuous)
                .stroke(.black.opacity(0.05))
        )
        .shadow(color: .black.opacity(0.1), radius: 18, y: -4)
    }

    private var tabBar: some View {
        HStack {
            tab(icon: "safari.fill", text: "Explore", active: true)
            tab(icon: "calendar", text: "Schedules", active: false)
            tab(icon: "bell", text: "Alerts", active: false)
            tab(icon: "gearshape", text: "Settings", active: false)
        }
        .padding(.horizontal, 22)
        .padding(.top, 10)
        .padding(.bottom, 24)
        .background(.white.opacity(0.95))
        .overlay(Rectangle().frame(height: 1).foregroundStyle(.black.opacity(0.05)), alignment: .top)
        .frame(maxHeight: .infinity, alignment: .bottom)
    }

    private func mapPin(icon: String, title: String, filled: Bool) -> some View {
        VStack(spacing: 6) {
            Circle()
                .fill(filled ? primary : .white)
                .frame(width: 38, height: 38)
                .overlay(
                    Circle()
                        .stroke(filled ? .white : primary, lineWidth: 2)
                )
                .overlay(
                    Image(systemName: icon)
                        .foregroundStyle(filled ? .black : secondary)
                        .font(.subheadline.bold())
                )
                .shadow(color: primary.opacity(0.35), radius: 8, y: 2)

            Text(title)
                .font(.caption2.bold())
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(.white, in: RoundedRectangle(cornerRadius: 8))
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(.black.opacity(0.05)))
        }
    }

    private func chip(icon: String, text: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon).foregroundStyle(secondary)
            Text(text).font(.caption.bold())
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(.white, in: Capsule())
        .overlay(Capsule().stroke(.black.opacity(0.05)))
    }

    private func floatingButton(_ icon: String) -> some View {
        Button {} label: {
            Image(systemName: icon)
                .foregroundStyle(darkText)
                .frame(width: 48, height: 48)
                .background(.white, in: RoundedRectangle(cornerRadius: 12))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(.black.opacity(0.05)))
        }
    }

    private func categoryChip(icon: String, text: String, active: Bool) -> some View {
        HStack(spacing: 7) {
            Image(systemName: icon)
            Text(text)
                .font(.caption.weight(active ? .semibold : .medium))
        }
        .foregroundStyle(active ? darkText : grayText)
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(active ? primary : surface, in: RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(.black.opacity(active ? 0 : 0.05)))
    }

    private func serviceCard(_ service: NearbyService) -> some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: service.imageURL)) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                Color.white
            }
            .frame(width: 78, height: 78)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(.black.opacity(0.05)))

            VStack(alignment: .leading, spacing: 7) {
                HStack(alignment: .top) {
                    Text(service.name)
                        .font(.subheadline.bold())
                        .foregroundStyle(darkText)
                    Spacer(minLength: 6)
                    Text(service.status)
                        .font(.system(size: 9, weight: .bold))
                        .foregroundStyle(service.statusColor)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 3)
                        .background(service.statusColor.opacity(0.12), in: Capsule())
                }

                Text(service.subtitle)
                    .font(.caption)
                    .foregroundStyle(grayText)

                HStack(spacing: 2) {
                    ForEach(0..<4, id: \.self) { _ in
                        Image(systemName: "star.fill")
                            .font(.caption2)
                            .foregroundStyle(secondary)
                    }
                    Image(systemName: "star.leadinghalf.filled")
                        .font(.caption2)
                        .foregroundStyle(secondary)
                    Text("(248)")
                        .font(.caption2)
                        .foregroundStyle(grayText)
                        .padding(.leading, 4)
                }
            }
        }
        .padding(10)
        .background(surface, in: RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(.black.opacity(0.05)))
    }

    private func tab(icon: String, text: String, active: Bool) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.subheadline.weight(active ? .bold : .regular))
            Text(text)
                .font(.caption2.weight(active ? .bold : .regular))
        }
        .foregroundStyle(active ? darkText : grayText)
        .frame(maxWidth: .infinity)
    }
}

private struct NearbyService: Identifiable {
    let id = UUID()
    let name: String
    let subtitle: String
    let status: String
    let statusColor: Color
    let imageURL: String
}

extension Color {
    init(campusHex: String, opacity: Double = 1) {
        let cleaned = campusHex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: cleaned).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255.0
        let g = Double((int >> 8) & 0xFF) / 255.0
        let b = Double(int & 0xFF) / 255.0
        self.init(.sRGB, red: r, green: g, blue: b, opacity: opacity)
    }
}

struct CampusInteractivoView_Previews: PreviewProvider {
    static var previews: some View {
        CampusInteractivoView()
    }
}
