import SwiftUI

struct CampusInputField: View {
    let title: String
    @Binding var text: String
    let icon: String
    var isSecure = false

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(CampusTheme.charcoal)
                .frame(width: 18)

            if isSecure {
                SecureField(title, text: $text)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            } else {
                TextField(title, text: $text)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            }
        }
        .padding(16)
        .background(.white, in: RoundedRectangle(cornerRadius: 18))
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(CampusTheme.border, lineWidth: 1)
        )
    }
}

struct HomeActionCard: View {
    let title: String
    let subtitle: String
    let icon: String

    var body: some View {
        HStack(spacing: 14) {
            RoundedRectangle(cornerRadius: 18)
                .fill(CampusTheme.primary)
                .frame(width: 58, height: 58)
                .overlay(
                    Image(systemName: icon)
                        .font(.title2.bold())
                        .foregroundStyle(CampusTheme.ink)
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline.bold())
                    .foregroundStyle(CampusTheme.ink)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(CampusTheme.muted)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundStyle(CampusTheme.muted)
        }
        .padding(18)
        .background(CampusTheme.surface, in: RoundedRectangle(cornerRadius: 24))
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(CampusTheme.border, lineWidth: 1)
        )
    }
}

struct ScheduleRowView: View {
    let item: ScheduleClass

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(item.title)
                    .font(.headline)
                    .foregroundStyle(CampusTheme.ink)
                Spacer()
                Text(item.day)
                    .font(.footnote.bold())
                    .foregroundStyle(CampusTheme.ink)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(CampusTheme.primary.opacity(0.8), in: Capsule())
            }

            Text("\(item.code) • \(item.startTime) - \(item.endTime)")
                .font(.subheadline)
                .foregroundStyle(CampusTheme.charcoal)

            Text(item.locationText)
                .font(.footnote)
                .foregroundStyle(CampusTheme.muted)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white, in: RoundedRectangle(cornerRadius: 18))
    }
}

struct CurrentScheduleListView: View {
    let title: String
    let subtitle: String
    let classes: [ScheduleClass]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title3.bold())
                .foregroundStyle(CampusTheme.ink)

            Text(subtitle)
                .font(.footnote)
                .foregroundStyle(CampusTheme.muted)

            if classes.isEmpty {
                Text("No hay materias cargadas.")
                    .font(.subheadline)
                    .foregroundStyle(CampusTheme.muted)
            } else {
                ForEach(classes) { item in
                    ScheduleRowView(item: item)
                }
            }
        }
        .padding(18)
        .background(CampusTheme.surface, in: RoundedRectangle(cornerRadius: 24))
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(CampusTheme.border, lineWidth: 1)
        )
    }
}
