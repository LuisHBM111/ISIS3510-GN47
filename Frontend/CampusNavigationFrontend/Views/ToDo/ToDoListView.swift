import SwiftUI
import SwiftData

struct ToDoListView: View {

    // guardada en BD SQLite de SwiftData
    @Query private var items: [ToDoItem]
    @Environment(\.modelContext) private var context

    // @AppStorage
    @AppStorage("toDoSortByCompleted") private var sortCompletedLast: Bool = true

    // UserDefaults
    @State private var draftText: String = UserDefaults.standard.string(forKey: "todo.draft") ?? ""

    // Eventual connectivity
    @State private var networkMonitor = NetworkMonitor()

    private var sortedItems: [ToDoItem] {
        if sortCompletedLast {
            return items.sorted { !$0.isCompleted && $1.isCompleted }
        }
        return items.sorted { $0.createdAt > $1.createdAt }
    }

    var body: some View {
        ZStack {
            Color(hex: "F2F3F5").ignoresSafeArea()

            VStack(spacing: 0) {
                TopBarView()
                
                //Conectividad
                if !networkMonitor.isConnected {
                    HStack(spacing: 8) {
                        Image(systemName: "wifi.slash")
                        Text("Sin conexión — tus tareas se guardan localmente y están disponibles offline")
                            .font(.subheadline)
                    }
                    .foregroundStyle(CampusTheme.ink)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(CampusTheme.primary.opacity(0.35))
                }

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        

                        // MARK: Header
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Tareas")
                                .font(.system(size: 28, weight: .black))
                                .foregroundStyle(CampusTheme.ink)
                            Text("\(items.filter { !$0.isCompleted }.count) pendientes")
                                .font(.subheadline)
                                .foregroundStyle(CampusTheme.muted)
                        }

                        // MARK: Add task — draft saved in UserDefaults
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Nueva tarea")
                                .font(.caption)
                                .foregroundStyle(.secondary)

                            HStack(spacing: 10) {
                                TextField("Escribe una tarea...", text: $draftText)
                                    .padding(10)
                                    .background(Color.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .shadow(color: .black.opacity(0.04), radius: 3)
                                    .onChange(of: draftText) { _, newValue in
                                        // UserDefaults — persist draft as the user types
                                        UserDefaults.standard.set(newValue, forKey: "todo.draft")
                                    }

                                Button {
                                    addItem()
                                } label: {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.system(size: 36))
                                        .foregroundStyle(draftText.trimmingCharacters(in: .whitespaces).isEmpty
                                                         ? Color.gray.opacity(0.4)
                                                         : Color(hex: "D4A017"))
                                }
                                .disabled(draftText.trimmingCharacters(in: .whitespaces).isEmpty)
                            }
                        }

                        // MARK: Sort toggle — @AppStorage
                        if !items.isEmpty {
                            Toggle(isOn: $sortCompletedLast) {
                                Text("Pendientes primero")
                                    .font(.subheadline)
                                    .foregroundStyle(CampusTheme.ink)
                            }
                            .tint(Color(hex: "D4A017"))
                            .padding(.horizontal, 4)
                        }

                        // MARK: Task list — SwiftData via @Query
                        if sortedItems.isEmpty {
                            ContentUnavailableView(
                                "Sin tareas",
                                systemImage: "checkmark.circle",
                                description: Text("Agrega tu primera tarea arriba.")
                            )
                            .padding(.top, 40)
                        } else {
                            VStack(spacing: 10) {
                                ForEach(sortedItems) { item in
                                    taskRow(item)
                                }
                            }
                        }
                    }
                    .padding(20)
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Subviews

    private func taskRow(_ item: ToDoItem) -> some View {
        HStack(spacing: 12) {
            Button {
                item.isCompleted.toggle()
                // SwiftData persists the change automatically
            } label: {
                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 22))
                    .foregroundStyle(item.isCompleted ? Color(hex: "10B981") : CampusTheme.muted)
            }

            Text(item.title)
                .font(.subheadline)
                .foregroundStyle(item.isCompleted ? CampusTheme.muted : CampusTheme.ink)
                .strikethrough(item.isCompleted, color: CampusTheme.muted)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(14)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.04), radius: 3)
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                context.delete(item)
            } label: {
                Label("Borrar", systemImage: "trash")
            }
        }
    }

    // MARK: - Intents

    private func addItem() {
        let title = draftText.trimmingCharacters(in: .whitespaces)
        guard !title.isEmpty else { return }

        // SwiftData — insert new item into the model context
        let newItem = ToDoItem(title: title)
        context.insert(newItem)

        // Clear draft from UserDefaults
        draftText = ""
        UserDefaults.standard.removeObject(forKey: "todo.draft")
    }
}

#Preview {
    ToDoListView()
        .modelContainer(for: ToDoItem.self, inMemory: true)
}
