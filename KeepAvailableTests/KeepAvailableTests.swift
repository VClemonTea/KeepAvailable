import Foundation
import Testing
@testable import KeepAvailable

struct KeepAvailableTests {

    @Test func defaultValues() {
        let vm = KeepAvailableViewModel()

        #expect(vm.intervalSeconds == 100)
        #expect(vm.stopHour == 0)
        #expect(vm.stopMinute == 0)
        #expect(vm.isRunning == false)
        #expect(vm.lastToggleTime == nil)
        #expect(vm.nextToggleTime == nil)
    }

    @Test func settingInterval() {
        let vm = KeepAvailableViewModel()
        vm.intervalSeconds = 200

        #expect(vm.intervalSeconds == 200)
    }

    @Test func settingStopTime() {
        let vm = KeepAvailableViewModel()
        vm.stopHour = 23
        vm.stopMinute = 59

        #expect(vm.stopHour == 23)
        #expect(vm.stopMinute == 59)
    }

    @Test func stopTimeTodayIsInFuture() {
        let vm = KeepAvailableViewModel()
        vm.stopHour = 23
        vm.stopMinute = 59

        let now = Date()
        let stop = vm.stopTimeToday

        #expect(stop > now)
        let comps = Calendar.current.dateComponents([.hour, .minute], from: stop)
        #expect(comps.hour == 23)
        #expect(comps.minute == 59)
    }

    @Test func stopTimeTodayUsesToday() {
        let vm = KeepAvailableViewModel()
        vm.stopHour = 0
        vm.stopMinute = 0

        let stop = vm.stopTimeToday
        let now = Date()
        let dayComps = Calendar.current.dateComponents([.year, .month, .day], from: stop)
        let nowComps = Calendar.current.dateComponents([.year, .month, .day], from: now)

        #expect(dayComps.year == nowComps.year)
        #expect(dayComps.month == nowComps.month)
        #expect(dayComps.day == nowComps.day)
    }

    @Test func nextToggleTimeAfterStart() {
        let vm = KeepAvailableViewModel()
        vm.intervalSeconds = 100

        // Simulate what start does — set lastToggleTime directly
        vm.lastToggleTime = Date()

        guard let next = vm.nextToggleTime else {
            Issue.record("nextToggleTime should not be nil when lastToggleTime is set")
            return
        }

        let diff = next.timeIntervalSince(vm.lastToggleTime!)
        #expect(diff == 100)
    }

    @Test func nextToggleTimeNilWhenNoLastToggle() {
        let vm = KeepAvailableViewModel()
        #expect(vm.nextToggleTime == nil)
    }

    @Test func accessibilityPermissionDefaultsToFalse() {
        let vm = KeepAvailableViewModel()
        #expect(vm.hasAccessibilityPermission == false)
    }
}
