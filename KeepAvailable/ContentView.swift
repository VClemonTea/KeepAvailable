import SwiftUI
import Combine

struct ContentView: View {
    @State private var viewModel = KeepAvailableViewModel()
    @State private var now = Date()

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 0) {
            headerSection
            Divider().padding(.horizontal)
            settingsSection
            Divider().padding(.horizontal)
            statusSection
            Divider().padding(.horizontal)
            controlSection
        }
        .frame(minWidth: 360, maxWidth: 420, minHeight: 370)
        .onReceive(timer) { date in
            now = date
            viewModel.checkAccessibilityPermission()
        }
        .onAppear {
            viewModel.checkAccessibilityPermission()
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        HStack(spacing: 12) {
            Image(systemName: "clock.badge")
                .font(.system(size: 28))
                .foregroundStyle(.blue)
            Text(String(localized: "Keep Available"))
                .font(.title2)
                .fontWeight(.semibold)
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }

    // MARK: - Settings

    private var settingsSection: some View {
        VStack(spacing: 12) {
            HStack {
                Text(String(localized: "Settings"))
                    .font(.headline)
                    .foregroundStyle(.secondary)
                Spacer()
            }

            LabeledContent(String(localized: "Interval")) {
                HStack(spacing: 8) {
                    Button {
                        viewModel.intervalSeconds = max(10, viewModel.intervalSeconds - 10)
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .font(.title3)
                    }
                    .buttonStyle(.plain)
                    .disabled(viewModel.isRunning)

                    TextField("", value: $viewModel.intervalSeconds, format: .number)
                        .frame(width: 60)
                        .textFieldStyle(.roundedBorder)
                        .multilineTextAlignment(.center)
                        .disabled(viewModel.isRunning)

                    Button {
                        viewModel.intervalSeconds = min(3600, viewModel.intervalSeconds + 10)
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                    }
                    .buttonStyle(.plain)
                    .disabled(viewModel.isRunning)

                    Text(String(localized: "sec"))
                        .foregroundStyle(.secondary)
                }
            }

            LabeledContent(String(localized: "Stop at")) {
                DatePicker(
                    "",
                    selection: Binding(
                        get: { viewModel.stopTimeToday },
                        set: { date in
                            let comps = Calendar.current.dateComponents([.hour, .minute], from: date)
                            viewModel.stopHour = comps.hour ?? 0
                            viewModel.stopMinute = comps.minute ?? 0
                        }
                    ),
                    displayedComponents: .hourAndMinute
                )
                .labelsHidden()
                .disabled(viewModel.isRunning)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }

    // MARK: - Status

    private var statusSection: some View {
        VStack(spacing: 12) {
            HStack {
                Text(String(localized: "Status"))
                    .font(.headline)
                    .foregroundStyle(.secondary)
                Spacer()
            }

            LabeledContent(String(localized: "State")) {
                HStack(spacing: 6) {
                    Circle()
                        .fill(viewModel.isRunning ? Color.green : Color.secondary)
                        .frame(width: 8, height: 8)
                    Text(viewModel.isRunning
                         ? String(localized: "Running")
                         : String(localized: "Stopped"))
                        .foregroundStyle(viewModel.isRunning ? .green : .secondary)
                }
            }

            if viewModel.isRunning {
                LabeledContent(String(localized: "Next toggle")) {
                    Text(nextToggleText)
                        .foregroundStyle(.secondary)
                }

                LabeledContent(String(localized: "Auto-stop")) {
                    Text(stopTimeText)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }

    // MARK: - Control

    private var controlSection: some View {
        VStack(spacing: 12) {
            if !viewModel.hasAccessibilityPermission {
                VStack(spacing: 8) {
                    HStack(spacing: 6) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundStyle(.yellow)
                        Text(String(localized: "Accessibility Permission Required"))
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    Text(String(localized: "This app needs Accessibility permission to simulate Caps Lock key events."))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                    Button(String(localized: "Open System Settings")) {
                        viewModel.requestAccessibilityPermission()
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.small)
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.yellow.opacity(0.1))
                )
                .padding(.horizontal, 8)
            }

            Button {
                if viewModel.isRunning {
                    viewModel.stop()
                } else {
                    viewModel.start()
                }
            } label: {
                Label(
                    viewModel.isRunning
                        ? String(localized: "Stop")
                        : String(localized: "Start"),
                    systemImage: viewModel.isRunning ? "stop.fill" : "play.fill"
                )
                .frame(maxWidth: .infinity)
                .frame(height: 16)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .tint(viewModel.isRunning ? .red : .blue)
            .disabled(!viewModel.hasAccessibilityPermission && !viewModel.isRunning)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }

    // MARK: - Helpers

    private var nextToggleText: String {
        guard let next = viewModel.nextToggleTime else { return "--" }
        let remaining = next.timeIntervalSince(now)
        if remaining <= 0 { return String(localized: "now") }
        return String(localized: "in \(formattedDuration(remaining))")
    }

    private var stopTimeText: String {
        let stop = viewModel.stopTimeToday
        let remaining = stop.timeIntervalSince(now)
        if remaining <= 0 {
            return String(localized: "tomorrow at \(formattedTime(stop))")
        }
        return String(localized: "in \(formattedDuration(remaining))")
    }

    private func formattedDuration(_ interval: TimeInterval) -> String {
        let totalSeconds = Int(max(0, interval))
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        if hours > 0 {
            return String(format: "%dh %02dm %02ds", hours, minutes, seconds)
        } else if minutes > 0 {
            return String(format: "%dm %02ds", minutes, seconds)
        }
        return String(format: "%ds", seconds)
    }

    private func formattedTime(_ date: Date) -> String {
        date.formatted(date: .omitted, time: .shortened)
    }
}

#Preview {
    ContentView()
}
