import SwiftUI
import Observation

@Observable
final class KeepAvailableViewModel {
    var intervalSeconds = 100
    var stopHour = 0
    var stopMinute = 0
    var isRunning = false
    var hasAccessibilityPermission = false
    var lastToggleTime: Date?

    private var task: Task<Void, Never>?

    private static let capsLockKey: CGKeyCode = 0x39

    var nextToggleTime: Date? {
        guard let last = lastToggleTime else { return nil }
        return last.addingTimeInterval(TimeInterval(intervalSeconds))
    }

    var stopTimeToday: Date {
        let now = Date()
        var components = Calendar.current.dateComponents([.year, .month, .day], from: now)
        components.hour = stopHour
        components.minute = stopMinute
        return Calendar.current.date(from: components) ?? now
    }

    func checkAccessibilityPermission() {
        let options = [kAXTrustedCheckOptionPrompt.takeRetainedValue() as String: false]
        hasAccessibilityPermission = AXIsProcessTrustedWithOptions(options as CFDictionary)
    }

    func requestAccessibilityPermission() {
        let options = [kAXTrustedCheckOptionPrompt.takeRetainedValue() as String: true]
        hasAccessibilityPermission = AXIsProcessTrustedWithOptions(options as CFDictionary)
    }

    func start() {
        checkAccessibilityPermission()
        isRunning = true
        lastToggleTime = Date()

        task = Task {
            while !Task.isCancelled {
                toggleCapsLock()
                try? await Task.sleep(for: .milliseconds(80))
                toggleCapsLock()

                lastToggleTime = Date()

                let now = Date()
                let components = Calendar.current.dateComponents([.hour, .minute], from: now)
                if components.hour == stopHour && components.minute == stopMinute {
                    break
                }

                do {
                    try await Task.sleep(for: .seconds(intervalSeconds))
                } catch {
                    break
                }
            }

            await MainActor.run {
                ensureCapsLockOff()
                isRunning = false
                lastToggleTime = nil
            }
        }
    }

    func stop() {
        task?.cancel()
        task = nil
        ensureCapsLockOff()
        isRunning = false
        lastToggleTime = nil
    }

    private func toggleCapsLock() {
        postCapsLockKeyDown()
        postCapsLockKeyUp()
    }

    private func postCapsLockKeyDown() {
        guard let event = CGEvent(
            keyboardEventSource: nil,
            virtualKey: Self.capsLockKey,
            keyDown: true
        ) else { return }
        event.flags = .maskNonCoalesced
        event.post(tap: .cgSessionEventTap)
    }

    private func postCapsLockKeyUp() {
        guard let event = CGEvent(
            keyboardEventSource: nil,
            virtualKey: Self.capsLockKey,
            keyDown: false
        ) else { return }
        event.flags = .maskNonCoalesced
        event.post(tap: .cgSessionEventTap)
    }

    private func isCapsLockOn() -> Bool {
        CGEventSource.flagsState(.hidSystemState).contains(.maskAlphaShift)
    }

    private func ensureCapsLockOff() {
        if isCapsLockOn() {
            toggleCapsLock()
        }
    }
}
