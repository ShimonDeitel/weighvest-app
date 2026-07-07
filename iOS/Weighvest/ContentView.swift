import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var purchases: PurchaseManager
    @State private var showAddSheet = false
    @State private var showPaywall = false
    @State private var showSettings = false

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                List {
                    ForEach(store.entries) { entry in
                        EntryRow(entry: entry)
                            .listRowBackground(Theme.background)
                    }
                    .onDelete { offsets in
                        store.delete(at: offsets)
                    }
                }
                .scrollContentBackground(.hidden)
                .listStyle(.plain)
            }
            .navigationTitle("Weighvest")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "gearshape")
                    }
                    .accessibilityIdentifier("settingsButton")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if store.canAddMore {
                            showAddSheet = true
                        } else {
                            showPaywall = true
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                    .accessibilityIdentifier("addButton")
                }
            }
            .sheet(isPresented: $showAddSheet) {
                AddEntrySheet()
                    .environmentObject(store)
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
                    .environmentObject(store)
                    .environmentObject(purchases)
            }
            .sheet(isPresented: $showPaywall) {
                PaywallView()
                    .environmentObject(purchases)
            }
        }
        .tint(Theme.accent)
    }
}

struct EntryRow: View {
    let entry: RuckSession

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(entry.date, style: .date)
                .font(Theme.captionFont)
                .foregroundStyle(Theme.accentSecondary)
            Text("\(entry.vestWeight) \(entry.distance)")
                .font(Theme.bodyFont)
                .foregroundStyle(Theme.foreground)
            if !entry.notes.isEmpty {
                Text(entry.notes)
                    .font(Theme.captionFont)
                    .foregroundStyle(Theme.foreground.opacity(0.7))
            }
        }
        .padding(.vertical, 4)
    }
}

struct AddEntrySheet: View {
    @EnvironmentObject var store: Store
    @Environment(\.dismiss) var dismiss
    @State private var date = Date()
    @State private var vestWeightText: String = ""
    @State private var distanceText: String = ""
    @State private var durationText: String = ""
    @State private var notes: String = ""
    @FocusState private var focusedField: Bool

    var body: some View {
        NavigationStack {
            Form {
                DatePicker("Date", selection: $date, displayedComponents: .date)
                TextField("VestWeight (lb)", text: $vestWeightText)
                    .keyboardType(.decimalPad)
                    .focused($focusedField)
                TextField("Distance (mi)", text: $distanceText)
                    .keyboardType(.decimalPad)
                    .focused($focusedField)
                TextField("Duration (min)", text: $durationText)
                    .keyboardType(.decimalPad)
                    .focused($focusedField)
                TextField("Notes", text: $notes)
                    .focused($focusedField)
            }
            .navigationTitle("Add Ruck")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .accessibilityIdentifier("cancelAddButton")
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        save()
                        dismiss()
                    }
                    .accessibilityIdentifier("saveEntryButton")
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                focusedField = false
            }
        }
    }

    private func save() {
        let entry = RuckSession(
            date: date,
            vestWeight: Double(vestWeightText) ?? 0,
            distance: Double(distanceText) ?? 0,
            duration: Double(durationText) ?? 0,
            notes: notes
        )
        store.add(entry)
    }
}
