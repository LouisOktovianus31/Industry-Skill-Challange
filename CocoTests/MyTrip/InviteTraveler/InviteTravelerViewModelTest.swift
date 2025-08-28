//
//  InviteTravelerViewModelTest.swift
//  Coco
//
//  Created by Arin Juan Sari on 27/08/25.
//

import Foundation
import Testing
@testable import Coco

struct InviteTravelerViewModelTest {
    private struct TestContext {
        let viewModel: InviteTravelerViewModel
        let delegate: MockInviteTravelerViewModelDelegate
        let action: MockInviteTravelerViewModelAction
        let fetcher: MockInviteTravelerFetcher
        let createBookingByEmailsResponse: JSONArray<CreateBookingByEmailsResponse>
        
        static func setup() throws -> TestContext {
            let fetcher = MockInviteTravelerFetcher()
            let delegate = MockInviteTravelerViewModelDelegate()
            let action = MockInviteTravelerViewModelAction()
            let viewModel = InviteTravelerViewModel(fetcher: fetcher)
            viewModel.delegate = delegate
            viewModel.action = action
            
            let createBookingByEmailsResponse: JSONArray<CreateBookingByEmailsResponse> = try JSONReader.getObjectFromJSON(with: "create-booking-by-emails-response")
            fetcher.stubbedFetchCreateBookingByEmailsCompletionResult = (createBookingByEmailsResponse, ())
            
            return TestContext(viewModel: viewModel, delegate: delegate, action: action, fetcher: fetcher, createBookingByEmailsResponse: createBookingByEmailsResponse)
        }
    }
    
    @Test("send invite traveler request - should set up initial state")
    func sendInviteTravelerRequest_whenSuccessful_shouldSetupInitialState() async throws {
        // --- GIVEN ---
        let context = try TestContext.setup()
        
        // --- WHEN ---
        let task = context.viewModel.sendInviteTravelerRequest()
            await task.value
        
        // --- THEN ---
        #expect(context.delegate.invokedNotifyInviteTravellerComplete)
        #expect(context.delegate.invokedNotifyInviteTravellerCompleteCount == 1)
        
        #expect(context.action.invokedSetStateViewData)
        #expect(context.action.invokedSetStateViewDataCount == 2)
        
    }
    
    @Test("view did load - should configure input email view")
    func viewDidLoad_shouldConfigureInputEmailView() async throws {
        // --- GIVEN ---
        let context = try TestContext.setup()
        
        // --- WHEN ---
        context.viewModel.viewDidLoad()
        
        // --- THEN ---
        #expect(context.action.invokedConfigureInputEmailView)
        #expect(context.action.invokedConfigureInputEmailViewCount == 1)
        
        #expect(context.action.invokedConfigureListEmailView)
        #expect(context.action.invokedConfigureListEmailViewCount == 1)
    }
    
    @Test("on invite traveler did tap - should add email traveler when email valid")
    func onInviteTravelerDidTap_shouldAddEmailTravelerWhenEmailValid() async throws {
        // --- GIVEN ---
        let context = try TestContext.setup()
        let mockEmail = "email@example.com"
        let mockData = getMockTripBookingDetails()
        
        context.viewModel.action?.configureInputEmailView(viewModel: context.viewModel.emailInputViewModel)
        context.viewModel.action?.configureListEmailView(viewModel: context.viewModel.collectionViewModel)
        context.viewModel.setData(mockData)
        
        // --- WHEN ---
        context.viewModel.onInviteTravelerDidTap(mockEmail)
        
        // --- THEN ---
        #expect(context.viewModel.collectionViewModel.emailTravelerListData.isEmpty == false)
        #expect(context.viewModel.emailInputViewModel.error == false)
    }
    
    @Test("on invite traveler did tap - should not add email traveler when emailt not valid")
    func onInviteTravelerDidTap_shouldNotAddEmailTravelerWhenEmailNotValid() async throws {
        // --- GIVEN ---
        let context = try TestContext.setup()
        let mockEmail = "email"
        let mockData = getMockTripBookingDetails()
        
        context.viewModel.action?.configureInputEmailView(viewModel: context.viewModel.emailInputViewModel)
        context.viewModel.action?.configureListEmailView(viewModel: context.viewModel.collectionViewModel)
        context.viewModel.setData(mockData)
        
        // --- WHEN ---
        context.viewModel.onInviteTravelerDidTap(mockEmail)
        
        // --- THEN ---
        #expect(context.viewModel.collectionViewModel.emailTravelerListData.isEmpty)
        #expect(context.viewModel.emailInputViewModel.error)
    }
}

private extension InviteTravelerViewModelTest {
    func getMockTripBookingDetails() -> TripBookingDetails {
        return TripBookingDetails(bookingId: 1, date: Date(), isPlanner: true, plannerName: "arin", participants: 3, totalPrice: 4000, status: "upcoming", activityTitle: "borobudur", packageName: "individual", destinationName: "candi", destinationImage: nil, longitude: 107, latitude: 205, importantNotice: nil, includedAccessories: [], memberEmails: [], vendorName: "jojo", vendorContact: "email@email.com")
    }
}

private final class MockInviteTravelerViewModelDelegate: InviteTravelerViewModelDelegate {
    
    var invokedNotifyInviteTravellerComplete: Bool = false
    var invokedNotifyInviteTravellerCompleteCount: Int = 0
    
    func notifyInviteTravellerComplete() {
        invokedNotifyInviteTravellerComplete = true
        invokedNotifyInviteTravellerCompleteCount += 1
    }
}

private final class MockInviteTravelerViewModelAction: InviteTravelerViewModelAction {
    
    var invokedConfigureInputEmailView: Bool = false
    var invokedConfigureInputEmailViewCount: Int = 0
    
    func configureInputEmailView(viewModel: Coco.HomeSearchBarViewModel) {
        invokedConfigureInputEmailView = true
        invokedConfigureInputEmailViewCount += 1
    }
    
    var invokedConfigureListEmailView: Bool = false
    var invokedConfigureListEmailViewCount: Int = 0
    
    func configureListEmailView(viewModel: any Coco.InviteTravellerCollectionViewModelProtocol) {
        invokedConfigureListEmailView = true
        invokedConfigureListEmailViewCount += 1
    }
    
    var invokedOnConfirmInviteTravelerDidTap: Bool = false
    var invokedOnConfirmInviteTravelerDidTapCount: Int = 0
    
    func onConfirmInviteTravelerDidTap() {
        invokedOnConfirmInviteTravelerDidTap = true
        invokedOnConfirmInviteTravelerDidTapCount += 1
    }
    
    var invokedSetStateViewData: Bool = false
    var invokedSetStateViewDataCount: Int = 0
    var invokedSetStateViewDataParameters: (stateData: Coco.StateViewData?, Void)?
    var invokedSetStateViewDataParametersList = [(stateData: Coco.StateViewData?, Void)]()
    
    func setStateViewData(_ stateData: Coco.StateViewData?) {
        invokedSetStateViewData = true
        invokedSetStateViewDataCount += 1
        invokedSetStateViewDataParameters = (stateData, ())
        invokedSetStateViewDataParametersList.append((stateData, ()))
    }
}
