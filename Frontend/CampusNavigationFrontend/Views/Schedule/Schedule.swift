//
//  Schedule.swift
//  CampusNavigationFrontend
//
//  Created by Ana Cristina Rodriguez on 20/03/26.
//

import SwiftUI

// MARK: - Models
struct ClassEntry: Identifiable {
    let id = UUID()
    let title: String
    let code: String
    let type: String
    let startTime: String
    let endTime: String
    let location: String
    let room: String
    let color: String
}

struct DayEntry: Identifiable {
    let id = UUID()
    let shortName: String
    let number: Int
}


struct ScheduleView: View {
    @State private var selectedDay = 2

    let days: [DayEntry] = [
        DayEntry(shortName: "MON", number: 12),
        DayEntry(shortName: "TUE", number: 13),
        DayEntry(shortName: "WED", number: 14),
        DayEntry(shortName: "THU", number: 15),
        DayEntry(shortName: "FRI", number: 16),
    ]

    let classes: [ClassEntry] = [
        ClassEntry(
            title: "Móviles",
            code: "ISIS 3510",
            type: "Lecture",
            startTime: "08:30",
            endTime: "10:00",
            location: "Science Bldg, Hall B",
            room: "H-24",
            color: "FFFFFF"
        ),
        ClassEntry(
            title: "Proyecto de Grado",
            code: "ISIS 102",
            type: "Clase",
            startTime: "10:30",
            endTime: "12:00",
            location: "R 301",
            room: "",
            color: "F5C518"
        ),
        ClassEntry(
            title: "Machine Learning",
            code: "IBIO 220",
            type: "Clase",
            startTime: "13:00",
            endTime: "15:00",
            location: "ML 615",
            room: "Lab",
            color: "FFFFFF"
        ),
    ]

    let hours = ["08:00", "09:00", "10:00", "11:00", "12:00", "13:00", "14:00", "15:00"]

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Color(hex: "F2F3F5").ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                headerView

                // Day Selector
                daySelectorView
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                    .padding(.bottom, 8)

                // Timeline
                ScrollView {
                    timelineView
                        .padding(.bottom, 100)
                }
            }
        }
    }

    // Header
    var headerView: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 2) {
                Text("My Schedule")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.black)
                Text("Semester 2026-1")
                    .font(.system(size: 13))
                    .foregroundColor(Color(hex: "9CA3AF"))
            }
            Spacer()
            HStack(spacing: 10) {
                
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 8)
    }

    // MARK: - Day Selector
    var daySelectorView: some View {
        HStack(spacing: 8) {
            ForEach(Array(days.enumerated()), id: \.offset) { index, day in
                Button(action: { withAnimation(.spring(response: 0.3)) { selectedDay = index } }) {
                    VStack(spacing: 4) {
                        Text(day.shortName)
                            .font(.system(size: 11, weight: .semibold))
                            .tracking(0.5)
                        Text("\(day.number)")
                            .font(.system(size: 20, weight: .bold))
                    }
                    .foregroundColor(selectedDay == index ? .black : Color(hex: "9CA3AF"))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(
                        selectedDay == index
                            ? Color(hex: "F5C518")
                            : Color.white
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .shadow(
                        color: selectedDay == index
                            ? Color(hex: "F5C518").opacity(0.4)
                            : Color.black.opacity(0.04),
                        radius: selectedDay == index ? 8 : 4,
                        x: 0, y: 2
                    )
                }
            }
        }
    }

    // MARK: - Timeline
    var timelineView: some View {
        ZStack(alignment: .topLeading) {
            // Hour labels + grid lines
            VStack(spacing: 0) {
                ForEach(hours, id: \.self) { hour in
                    HStack(alignment: .top, spacing: 0) {
                        Text(hour)
                            .font(.system(size: 11))
                            .foregroundColor(Color(hex: "9CA3AF"))
                            .frame(width: 44, alignment: .leading)
                            .padding(.leading, 16)

                        Rectangle()
                            .fill(Color(hex: "E5E7EB"))
                            .frame(height: 1)
                            .padding(.top, 7)
                    }
                    .frame(height: 80)
                }
            }

            // Clases y separadores
            VStack(alignment: .leading, spacing: 0) {

                // Moviles
                Spacer().frame(height: 10)
                HStack(alignment: .top, spacing: 0) {
                    Spacer().frame(width: 60)
                    ClassCard(entry: classes[0])
                        .padding(.trailing, 16)
                }
                .frame(height: 120)

                //caminar
                Spacer().frame(height: 8)
                HStack {
                    Spacer().frame(width: 60)
                    WalkIndicator(text: "camina 8 minutos a tu próxima clase ")
                    Spacer()
                }
                Spacer().frame(height: 8)

                // proyecto grado
                HStack(alignment: .top, spacing: 0) {
                    // Current time indicator
                    VStack(spacing: 0) {
                        Spacer().frame(width: 44)
                    }
                    .frame(width: 60)

                    ClassCard(entry: classes[1])
                        .padding(.trailing, 16)
                }
                .frame(height: 160)
                .overlay(
                    HStack(spacing: 0) {
                        Rectangle()
                            .fill(Color(hex: "F5C518"))
                            .frame(width: 3)
                            .padding(.leading, 57)
                        Spacer()
                    }
                    .offset(y: 30)
                    , alignment: .leading
                )

                // Almuerzo
                Spacer().frame(height: 8)
                HStack {
                    Spacer().frame(width: 60)
                    LunchIndicator(text: "Almuerzo • 45 min")
                    Spacer()
                }
                Spacer().frame(height: 8)

                //ML
                HStack(alignment: .top, spacing: 0) {
                    Spacer().frame(width: 60)
                    ClassCard(entry: classes[2])
                        .padding(.trailing, 16)
                }
                .frame(height: 120)
            }
        }
        .padding(.top, 8)
    }

   
}

// MARK: - Class Card
struct ClassCard: View {
    let entry: ClassEntry

    var isYellow: Bool { entry.color != "FFFFFF" }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(entry.title)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.black)
                    Text("\(entry.code) • \(entry.type)")
                        .font(.system(size: 12))
                        .foregroundColor(isYellow ? .black.opacity(0.6) : Color(hex: "6B7280"))
                }
                Spacer()
            }

            HStack(spacing: 16) {
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.system(size: 11))
                    if isYellow {
                        VStack(alignment: .leading, spacing: 0) {
                            Text(entry.startTime + " -")
                                .font(.system(size: 13, weight: .semibold))
                            Text(entry.endTime)
                                .font(.system(size: 13, weight: .semibold))
                        }
                    } else {
                        Text("\(entry.startTime) - \(entry.endTime)")
                            .font(.system(size: 12))
                    }
                }
                .foregroundColor(isYellow ? .black : Color(hex: "6B7280"))

                HStack(spacing: 4) {
                    Image(systemName: "mappin")
                        .font(.system(size: 11))
                    Text(entry.location)
                        .font(.system(size: 12))
                        .lineLimit(2)
                }
                .foregroundColor(isYellow ? .black : Color(hex: "6B7280"))
            }

            
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(hex: entry.color))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    isYellow ? Color(hex: "F5C518") : Color(hex: "E5E7EB"),
                    lineWidth: isYellow ? 2 : 1
                )
        )
        .shadow(
            color: isYellow ? Color(hex: "F5C518").opacity(0.3) : Color.black.opacity(0.05),
            radius: isYellow ? 10 : 4,
            x: 0, y: 3
        )
    }
}

// MARK: - Live Badge
struct LiveBadge: View {
    @State private var pulse = false

    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(Color.green)
                .frame(width: 7, height: 7)
                .scaleEffect(pulse ? 1.3 : 1.0)
                .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: pulse)
                .onAppear { pulse = true }
            Text("LIVE")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.black)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.white.opacity(0.6))
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}

// MARK: - Walk Indicator
struct WalkIndicator: View {
    let text: String
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "figure.walk")
                .font(.system(size: 11))
                .foregroundColor(Color(hex: "9CA3AF"))
            Text(text)
                .font(.system(size: 12))
                .foregroundColor(Color(hex: "6B7280"))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color.white)
        .clipShape(Capsule())
        .overlay(Capsule().stroke(Color(hex: "E5E7EB"), lineWidth: 1))
    }
}

// MARK: - Lunch Indicator
struct LunchIndicator: View {
    let text: String
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "fork.knife")
                .font(.system(size: 11))
                .foregroundColor(Color(hex: "9CA3AF"))
            Text(text)
                .font(.system(size: 12))
                .foregroundColor(Color(hex: "6B7280"))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color.white)
        .clipShape(Capsule())
        .overlay(Capsule().stroke(Color(hex: "E5E7EB"), lineWidth: 1))
    }
}

// MARK: - Tab Bar Item
struct TabBarItem: View {
    let icon: String
    let label: String
    let isSelected: Bool
    var hasDot: Bool = false

    var body: some View {
        VStack(spacing: 4) {
            ZStack(alignment: .topTrailing) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(isSelected ? Color(hex: "F5C518") : Color(hex: "9CA3AF"))
                if hasDot {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 7, height: 7)
                        .offset(x: 4, y: -2)
                }
            }
            Text(label)
                .font(.system(size: 9, weight: .semibold))
                .tracking(0.5)
                .foregroundColor(isSelected ? Color(hex: "F5C518") : Color(hex: "9CA3AF"))
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Preview
#Preview {
    ScheduleView()
}
