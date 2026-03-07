import SwiftUI

struct Mock2RouteGuideView: View {
    private let primary = Color(campusHex: "#FFE11F")
    private let sectionBG = Color(campusHex: "#F5F5F5")
    private let textMain = Color(campusHex: "#202020")
    private let textDim = Color(campusHex: "#757575")
    private let borderLight = Color(campusHex: "#E0E0E0")

    private let steps: [RouteStep] = [
        .init(icon: "rectangle.portrait.and.arrow.forward", title: "Exit Building A", detail: "Head North through the Main Entrance", alert: nil, highlighted: true),
        .init(icon: "arrow.up", title: "Walk 200m", detail: "Follow the path towards the Central Plaza", alert: nil, highlighted: false),
        .init(icon: "arrow.turn.up.right", title: "Turn right at Student Union", detail: "", alert: "Busy area. Watch for campus shuttle crossing.", highlighted: false),
        .init(icon: "mappin.circle.fill", title: "Arrive at Building B", detail: "Main Hall entrance is on your left", alert: nil, highlighted: false)
    ]

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                statusBar
                header
                mapAndSheet
            }
            .ignoresSafeArea(edges: .top)

            bottomCTA
        }
        .background(.white)
    }

    private var statusBar: some View {
        HStack {
            Text("9:41")
                .font(.caption.weight(.semibold))
            Spacer()
            HStack(spacing: 4) {
                Image(systemName: "antenna.radiowaves.left.and.right")
                Image(systemName: "wifi")
                Image(systemName: "battery.100")
            }
            .font(.caption)
        }
        .foregroundStyle(textMain)
        .padding(.horizontal, 24)
        .padding(.top, 8)
        .frame(height: 44)
        .background(.white.opacity(0.95))
    }

    private var header: some View {
        HStack {
            HStack(spacing: 10) {
                Circle()
                    .fill(.black.opacity(0.05))
                    .frame(width: 36, height: 36)
                    .overlay(Image(systemName: "chevron.left").font(.subheadline.bold()))
                VStack(alignment: .leading, spacing: 2) {
                    Text("Route to Building B")
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(textMain)
                    Text("From Building A, Room 302")
                        .font(.caption)
                        .foregroundStyle(textDim)
                }
            }

            Spacer()

            HStack(spacing: 10) {
                Circle()
                    .fill(.black.opacity(0.05))
                    .frame(width: 34, height: 34)
                    .overlay(Image(systemName: "globe"))
                Circle()
                    .fill(.black.opacity(0.05))
                    .frame(width: 34, height: 34)
                    .overlay(Image(systemName: "ellipsis"))
            }
            .foregroundStyle(textMain)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.white)
        .overlay(Rectangle().frame(height: 1).foregroundStyle(borderLight), alignment: .bottom)
    }

    private var mapAndSheet: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .topTrailing) {
                AsyncImage(url: URL(string: "https://lh3.googleusercontent.com/aida-public/AB6AXuC2Re6g28v-uGNzJmIcyx1tt4nDaQlitC0pi8VzRZgspfkkjV9ISeIg_zzR-ZmjQaQAh3zRYe8t3kq-CH5hhnSe9kR-8_qUzFDzYer3bHYM-awhVo9x3eSjqq9gfd2-Qrwdw1Dfm701uhu8RHuiAS1ICtJiT6IRNbSWEQoYBvBeVc4wVslwy1zRxGS1rS_W0B_rNKkrnj6HC3w_Mq5yzcJe7wShWiE9yEdGIHlsUITNtucbc1JkcDwONmsZJtSZPh3FGjnZSg8O9t0s")) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    sectionBG
                }
                .overlay(Color.white.opacity(0.35))

                Path { path in
                    path.move(to: .init(x: 80, y: 300))
                    path.addLine(to: .init(x: 130, y: 260))
                    path.addLine(to: .init(x: 240, y: 240))
                    path.addLine(to: .init(x: 290, y: 90))
                }
                .stroke(
                    primary,
                    style: .init(lineWidth: 8, lineCap: .round, lineJoin: .round, dash: [1, 12])
                )

                Group {
                    Circle()
                        .fill(.white)
                        .overlay(Circle().stroke(primary, lineWidth: 3))
                        .frame(width: 20, height: 20)
                        .position(x: 80, y: 300)

                    Circle()
                        .fill(primary)
                        .overlay(Circle().stroke(.white, lineWidth: 3))
                        .frame(width: 20, height: 20)
                        .position(x: 290, y: 90)
                }

                VStack(spacing: 8) {
                    mapAction(icon: "location.fill")
                    mapAction(icon: "square.3.layers.3d")
                }
                .padding(16)
            }
            .frame(height: 270)
            .overlay(
                LinearGradient(colors: [.clear, .white], startPoint: .top, endPoint: .bottom)
                    .frame(height: 60),
                alignment: .bottom
            )

            bottomSheet
        }
    }

    private var bottomSheet: some View {
        VStack(spacing: 0) {
            Capsule()
                .fill(.black.opacity(0.1))
                .frame(width: 42, height: 6)
                .padding(.top, 10)
                .padding(.bottom, 14)

            VStack(alignment: .leading, spacing: 14) {
                HStack(alignment: .center) {
                    HStack(spacing: 10) {
                        RoundedRectangle(cornerRadius: 14)
                            .fill(primary.opacity(0.2))
                            .frame(width: 54, height: 54)
                            .overlay(Image(systemName: "figure.walk").font(.title2))
                        VStack(alignment: .leading, spacing: 4) {
                            HStack(spacing: 8) {
                                Text("8 min").font(.title2.bold())
                                Text("•").foregroundStyle(.black.opacity(0.2))
                                Text("650 m").font(.title3).foregroundStyle(textDim)
                            }
                            Text("Mostly flat • Clear path")
                                .font(.caption)
                                .foregroundStyle(textDim)
                        }
                    }
                    Spacer()
                    Circle()
                        .fill(sectionBG)
                        .frame(width: 42, height: 42)
                        .overlay(Image(systemName: "square.and.arrow.up"))
                }

                HStack(spacing: 8) {
                    modeChip("Fastest", active: true)
                    modeChip("Indoor Route", active: false)
                    modeChip("Accessible", active: false)
                }
            }
            .padding(.horizontal, 18)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
                        routeStep(step, isLast: index == steps.count - 1)
                    }
                }
                .padding(.horizontal, 18)
                .padding(.top, 10)
                .padding(.bottom, 130)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(maxHeight: .infinity)
        .background(.white, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(borderLight)
        )
    }

    private var bottomCTA: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                Button {} label: {
                    HStack(spacing: 8) {
                        Image(systemName: "location.north.fill")
                        Text("Start Navigation")
                    }
                    .font(.headline.bold())
                    .foregroundStyle(textMain)
                    .frame(maxWidth: .infinity, minHeight: 60)
                    .background(primary, in: RoundedRectangle(cornerRadius: 16))
                }

                Button {} label: {
                    Image(systemName: "calendar")
                        .foregroundStyle(textMain)
                        .frame(width: 60, height: 60)
                        .background(sectionBG, in: RoundedRectangle(cornerRadius: 16))
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(borderLight))
                }
            }

            Capsule()
                .fill(.black.opacity(0.1))
                .frame(width: 120, height: 5)
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 10)
        .background(
            LinearGradient(colors: [.white.opacity(0), .white.opacity(0.95), .white], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea(edges: .bottom)
        )
    }

    private func mapAction(icon: String) -> some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(.white.opacity(0.92))
            .frame(width: 48, height: 48)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(borderLight)
            )
            .overlay(
                Image(systemName: icon)
                    .foregroundStyle(textMain)
            )
    }

    private func modeChip(_ text: String, active: Bool) -> some View {
        Text(text)
            .font(.caption.weight(active ? .bold : .semibold))
            .foregroundStyle(textMain)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(active ? primary : sectionBG, in: Capsule())
    }

    private func routeStep(_ step: RouteStep, isLast: Bool) -> some View {
        HStack(alignment: .top, spacing: 14) {
            VStack(spacing: 0) {
                Circle()
                    .fill(step.highlighted ? primary : sectionBG)
                    .overlay(Circle().stroke(step.highlighted ? .clear : borderLight))
                    .frame(width: 44, height: 44)
                    .overlay(
                        Image(systemName: step.icon)
                            .foregroundStyle(textMain)
                    )
                if !isLast {
                    Rectangle()
                        .fill(borderLight)
                        .frame(width: 2, height: 58)
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                Text(step.title)
                    .font(.headline.bold())
                    .foregroundStyle(textMain)
                if !step.detail.isEmpty {
                    Text(step.detail)
                        .font(.subheadline)
                        .foregroundStyle(textDim)
                }
                if let alert = step.alert {
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "info.circle")
                        Text(alert)
                            .font(.caption.weight(.medium))
                    }
                    .foregroundStyle(textMain)
                    .padding(10)
                    .background(primary.opacity(0.18), in: RoundedRectangle(cornerRadius: 12))
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(primary.opacity(0.3)))
                }
            }
            .padding(.top, 4)
            .padding(.bottom, isLast ? 0 : 12)

            Spacer()
        }
    }
}

private struct RouteStep {
    let icon: String
    let title: String
    let detail: String
    let alert: String?
    let highlighted: Bool
}

struct Mock2RouteGuideView_Previews: PreviewProvider {
    static var previews: some View {
        Mock2RouteGuideView()
    }
}
