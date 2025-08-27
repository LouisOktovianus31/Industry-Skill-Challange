//
//  TripDetailViewModelTest.swift
//  Coco
//
//  Created by Grachia Uliari on 21/08/25.
//

import Foundation
import Testing
@testable import Coco

struct TripDetailViewModelTest {
    private struct TestContext {
        let fetcher: MockTripDetailFetcher
        let actionDelegate: MockTripDetailViewModelAction
        let viewModel: TripDetailViewModel
        let seeded: TripBookingDetails
        
        static func setupWithSeededData(date: Date = Date()) -> TestContext {
            let seeded = TripBookingDetails.mock(
                bookingId: 42,
                date: date,
                participants: 3,
                totalPrice: 1_800_000,
                status: "upcoming",
                plannerName: "Arin",
                isPlanner: true,
                activityTitle: "Regular Temple Tour",
                packageName: "Group Package",
                destinationName: "Yogyakarta, DI Yogyakarta",
                destinationImage: "https://picsum.photos/seed/dest-yogyakarta/800/600",
                latitude: -7.797068,
                longitude: 110.370529,
                vendorName: "Coco Host",
                vendorContact: "08123456789",
                includedAccessories: ["Guide", "Water"],
                memberEmails: ["arin@gmail.com", "chia@gmail.com"]
            )
            let vm = TripDetailViewModel(data: seeded)
            let fetcher = MockTripDetailFetcher()
            let action = MockTripDetailViewModelAction()
            //            let invites = MockTripDetailInvitesOutput()
            
            vm.actionDelegate = action
            //            vm.invitesOutput = invites
            
            return TestContext(fetcher: fetcher, actionDelegate: action, viewModel: vm, seeded: seeded)
        }
        
        static func setupWithFetcherReturning(_ details: TripBookingDetails) -> TestContext {
            let fetcher = MockTripDetailFetcher()
            fetcher.stubbedDetails = details
            
            let action = MockTripDetailViewModelAction()
            let invites = MockTripDetailInvitesOutput()
            
            // init by bookingId agar code path fetchData() berjalan
            let vm = TripDetailViewModel(bookingId: details.bookingId, fetcher: fetcher)
            vm.actionDelegate = action
            vm.invitesOutput = invites
            
            return TestContext(fetcher: fetcher, actionDelegate: action, viewModel: vm, seeded: details)
        }
    }
    
    // MARK: - onViewDidLoad (seeded) - render awal
    @Test("onViewDidLoad (seeded data) – render state awal tanpa fetcher")
    func onViewDidLoad_seeded_shouldRenderInitialState() async throws {
        // --- GIVEN ---
        let context = TestContext.setupWithSeededData(date: Date().addingTimeInterval(24*3600))
        
        // --- WHEN ---
        context.viewModel.onViewDidLoad()
        
        // --- THEN ---
        #expect(context.actionDelegate.invokedConfigureViewCount >= 1)
        let state = context.actionDelegate.lastConfiguredState
        #expect(state?.title == context.seeded.activityTitle)
        #expect(state?.locationText == context.seeded.destinationName)
        #expect(state?.paxText == "\(context.seeded.participants) person")
    }
    
    // MARK: - Fetch Data (update state, footer, traveller)
    @Test("berhasil fetch data – update state")
    func fetch_success_shouldUpdateState() async throws {
        // --- GIVEN ---
        let future = Calendar.current.date(byAdding: .day, value: 2, to: Date())!
        let details = TripBookingDetails.mock(
            bookingId: 100,
            date: future,
            participants: 4,
            totalPrice: 2_500_000,
            status: "upcoming",
            plannerName: "Arin",
            isPlanner: true,
            activityTitle: "Snorkeling in Piaynemo",
            packageName: "Group Package",
            destinationName: "Raja Ampat, West Papua",
            destinationImage: "https://picsum.photos/seed/dest-raja-ampat/800/600",
            latitude: -0.234,
            longitude: 130.507,
            vendorName: "Oceanic Odyssey",
            vendorContact: "081287110028",
            includedAccessories: ["Certified Guide", "Snorkeling Gear"],
            memberEmails: [
                "arin@gmail.com",
                "chia@gmail.com",
                "test@example.com"
            ]
        )
        let context = TestContext.setupWithFetcherReturning(details)
        
        // --- WHEN ---
        context.viewModel.onViewDidLoad()
        
        // --- THEN ---
        #expect(context.actionDelegate.invokedConfigureViewCount >= 1)
        #expect(context.actionDelegate.invokedConfigureFooterCount == 1)
        let state = context.actionDelegate.lastConfiguredState
        
        #expect(state?.title == "Snorkeling in Piaynemo")
        #expect(state?.locationText == "Raja Ampat, West Papua")
        #expect(state?.status.text == "Upcoming")
        #expect(state?.plannerName == "Arin")
        //        #expect(state?.priceText == "Rp 2.500.000")
        #expect(state?.vendorName == "Oceanic Odyssey")
        #expect(state?.vendorContact == "081287110028")
        #expect(state?.includedAccessories == ["Certified Guide", "Snorkeling Gear"])
        #expect(state?.showFooter == true)
        
    }
    
    // MARK: - Status Mapping
    @Test("status logic - Completed jika tanggal lewat")
    func status_completed_whenDatePassed() async throws {
        let past = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let context = TestContext.setupWithFetcherReturning(.mock(date: past))
        context.viewModel.onViewDidLoad()
        try await Task.sleep(nanoseconds: 150_000_000)
        
        let statusValue = context.actionDelegate.lastConfiguredState
        #expect(statusValue?.status.text == "Completed")
    }
    @Test("status logic – Upcoming jika tanggal di masa depan")
    func status_shouldBeUpcoming_whenDateIsFuture() async throws {
        let future = Calendar.current.date(byAdding: .day, value: 3, to: Date())!
        let context = TestContext.setupWithFetcherReturning(.mock(date: future))
        context.viewModel.onViewDidLoad()
        try await Task.sleep(nanoseconds: 150_000_000)
        
        let statusValue = context.actionDelegate.lastConfiguredState
        #expect(statusValue?.status.text == "Upcoming")
    }
    
    // MARK: - Footer logic
    @Test("footer logic – is displayed if (participants>1 && isPlanner && upcoming)")
    func footer_shouldBeVisible_whenAllConditionsMet() async throws {
        let future = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        let context = TestContext.setupWithFetcherReturning(.mock(
            date: future,
            participants: 3,
            isPlanner: true
        ))
        context.viewModel.onViewDidLoad()
        try await Task.sleep(nanoseconds: 150_000_000)
        
        let state = context.actionDelegate.lastConfiguredState
        #expect(state?.showFooter == true)
    }
    
    @Test("footer logic – hidden jika participants <= 1")
    func footer_shouldBeHidden_whenParticipantsIsOne() async throws {
        let future = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        let context = TestContext.setupWithFetcherReturning(.mock(
            date: future,
            participants: 1,
            isPlanner: true
        ))
        context.viewModel.onViewDidLoad()
        try await Task.sleep(nanoseconds: 150_000_000)
        
        let state = context.actionDelegate.lastConfiguredState
        #expect(state?.showFooter == false)
    }
    
    @Test("footer logic – if not a planner")
    func footer_shouldBeHidden_whenNotPlanner() async throws {
        let future = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        let context = TestContext.setupWithFetcherReturning(.mock(
            date: future,
            participants: 3,
            isPlanner: false
        ))
        context.viewModel.onViewDidLoad()
        try await Task.sleep(nanoseconds: 150_000_000)
        
        let state = context.actionDelegate.lastConfiguredState
        #expect(state?.showFooter == false)
    }
    
    @Test("footer logic – if its history")
    func footer_shouldBeHidden_whenPast() async throws {
        let past = Calendar.current.date(byAdding: .day, value: -2, to: Date())!
        let context = TestContext.setupWithFetcherReturning(.mock(
            date: past,
            participants: 3,
            isPlanner: true
        ))
        context.viewModel.onViewDidLoad()
        try await Task.sleep(nanoseconds: 150_000_000)
        
        let state = context.actionDelegate.lastConfiguredState
        #expect(state?.showFooter == false)
    }
    
    // MARK: - Location Test
    @Test("open maps – FE memakai feLatitude/feLongitude (swap dari BE)")
    func openMaps_shouldUseSwappedCoordinates() throws {
        // --- GIVEN ---
        let seeded = TripBookingDetails.mock(latitude: 110.45, longitude: -5.85)
        let mapMock = MockMapOpener()
        let viewModel = TripDetailViewModel(data: seeded, mapOpener: mapMock)

        // WHEN
        viewModel.didTapLocation()

        // THEN: FE membalik -> lat = longitude (4.56), lon = latitude (1.23)
        #expect(mapMock.openCount == 1)
        #expect(mapMock.lastLat == seeded.longitude)
        #expect(mapMock.lastLon == seeded.latitude)
        #expect(mapMock.lastName == seeded.destinationName)
    }
    
    @Test("state.mapCoordinate – use feLatitude/feLongitude")
    func state_mapCoordinate_shouldUseSwappedCoordinates() throws {
        // --- GIVEN ---
        let seeded = TripBookingDetails.mock(latitude: 1.11, longitude: 2.22)
        let action = MockTripDetailViewModelAction()
        let viewModel = TripDetailViewModel(data: seeded, mapOpener: MockMapOpener())
        viewModel.actionDelegate = action
        
        // --- WHEN ---
        viewModel.onViewDidLoad()
        
        // --- THEN ---
        let coord = action.lastConfiguredState?.mapCoordinate
        #expect(coord?.lat == seeded.longitude)
        #expect(coord?.lon == seeded.latitude)
        #expect(coord?.name == seeded.destinationName)
    }
}


// MARK: - Test Helpers
private final class MockTripDetailFetcher: TripDetailFetcherProtocol{
    var stubbedDetails: TripBookingDetails = .mock()
    func fetchTripDetail(bookingId: Int) async throws -> TripBookingDetails {
        return stubbedDetails
    }
}

private final class MockTripDetailViewModelAction: TripDetailViewModelAction {
    private(set) var lastConfiguredState: TripDetailViewState?
    private(set) var invokedConfigureViewCount: Int = 0
    func configureView(state: TripDetailViewState) {
        invokedConfigureViewCount += 1
        lastConfiguredState = state
    }
    
    private(set) var invokedConfigureFooterCount: Int = 0
    private(set) var lastFooterVM: InviteTravelerViewModelProtocol?
    func configureFooter(viewModel: InviteTravelerViewModelProtocol) {
        invokedConfigureFooterCount += 1
        lastFooterVM = viewModel
    }
    
    func openExternalURL(_ url: URL) {}
    
    // nanti
    func onAddCalendarDidTap() {}
    func closeInviteTravelerView() {}
}

private final class MockTripDetailInvitesOutput: TripDetailInvitesOutput {
    private(set) var invokedDidUpdateTravelersCount: Int = 0
    private(set) var lastTravelers: [Traveler]?
    func didUpdateTravelers(_ travelers: [Traveler]) {
        invokedDidUpdateTravelersCount += 1
        lastTravelers = travelers
    }
}

private extension TripBookingDetails {
    static func mock(
        bookingId: Int = 1,
        date: Date = Date(),
        participants: Int = 2,
        totalPrice: Decimal = 1_000_000,
        status: String = "upcoming",
        plannerName: String = "Arin",
        isPlanner: Bool = true,
        activityTitle: String = "Activity",
        packageName: String = "Package",
        destinationName: String = "Dest",
        destinationImage: String? = nil,
        latitude: Double = -6.2,
        longitude: Double = 106.8,
        vendorName: String = "Vendor",
        vendorContact: String = "0812",
        includedAccessories: [String] = [],
        memberEmails: [String] = ["a@a.com"]
    ) -> TripBookingDetails {
        return TripBookingDetails(
            bookingId: bookingId,
            date: date,
            isPlanner: isPlanner,
            plannerName: plannerName,
            participants: participants,
            totalPrice: totalPrice,
            status: status,
            activityTitle: activityTitle,
            packageName: packageName,
            destinationName: destinationName,
            destinationImage: destinationImage,
            longitude: longitude,
            latitude: latitude,
            importantNotice: vendorName,
            includedAccessories: includedAccessories,
            memberEmails: memberEmails,
            vendorName: vendorName,
            vendorContact: vendorContact
        )
    }
}

private final class MockMapOpener: MapOpener {
    private(set) var lastLat: Double?
    private(set) var lastLon: Double?
    private(set) var lastName: String?
    private(set) var openCount = 0

    func open(lat: Double, lon: Double, name: String) {
        openCount += 1
        lastLat = lat
        lastLon = lon
        lastName = name
    }
}
