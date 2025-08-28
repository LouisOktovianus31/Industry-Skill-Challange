//
//  MyTripViewModelTest.swift
//  Coco
//
//  Created by Arin Juan Sari on 26/08/25.
//

import Foundation
import Testing
@testable import Coco

struct MyTripViewModelTest {
    private struct TestContext {
        let viewModel: MyTripViewModel
        let actionDelegate: MockMyTripViewModelAction
        let fetcher: MockMyTripFetcher
        let bookingDetails: JSONArray<BookingDetails>
        
        static func setup() throws -> TestContext {
            let fetcher = MockMyTripFetcher()
            let actionDelegate = MockMyTripViewModelAction()
            
            let viewModel = MyTripViewModel(fetcher: fetcher)
            viewModel.actionDelegate = actionDelegate
            
            let bookingDetails: JSONArray<BookingDetails> = try JSONReader.getObjectFromJSON(with: "booking-details")
            fetcher.stubbedFetchTripBookingCompletionResult = (bookingDetails, ())
            
            return TestContext(viewModel: viewModel, actionDelegate: actionDelegate, fetcher: fetcher, bookingDetails: bookingDetails)
        }
    }
    
    @Test("view will appear - should set up initial state")
    func onViewWillAppear_whenSuccessful_shouldSetupInitialState() async throws {
        // --- GIVEN ---
        let context = try TestContext.setup()
        
        // --- WHEN ---
        let task = context.viewModel.onViewWillAppear()
            await task.value
        
        // --- THEN ---
        #expect(context.actionDelegate.invokedConstructCollectionView)
        #expect(context.actionDelegate.invokedConstructCollectionViewCount == 1)
        
        #expect(context.actionDelegate.invokedSetStateViewData)
        #expect(context.actionDelegate.invokedSetStateViewDataCount == 3)
    }
    
    @Test("apply filter - should filter data correctly when history")
    func applyFilter_whenHistory_shouldFilterDataCorrectly() async throws {
        // --- GIVEN ---
        let context = try TestContext.setup()
        context.viewModel.actionDelegate?.contructCollectionView(viewModel: context.viewModel.collectionViewModel)
        context.viewModel.allTripData = context.bookingDetails.values.map({ MyTripListCardDataModel(bookingDetail: $0) })
        
        // --- WHEN ---
        context.viewModel.applyFilter(.history)
        
        // --- THEN ---
        #expect(context.actionDelegate.invokedConstructCollectionView)
        #expect(context.actionDelegate.invokedConstructCollectionViewCount == 1)
        
        #expect(context.actionDelegate.invokedSetStateViewData)
        #expect(context.actionDelegate.invokedSetStateViewDataCount == 1)
        
        #expect(context.viewModel.collectionViewModel.myTripListData.count > 0)
    }
    
    @Test("apply filter - should filter data correctly when upcoming")
    func applyFilter_whenUpcoming_shouldFilterDataCorrectly() async throws {
        // --- GIVEN ---
        let context = try TestContext.setup()
        context.viewModel.actionDelegate?.contructCollectionView(viewModel: context.viewModel.collectionViewModel)
        context.viewModel.allTripData = context.bookingDetails.values.map({ MyTripListCardDataModel(bookingDetail: $0) })
        
        // --- WHEN ---
        context.viewModel.applyFilter(.upcoming)
        
        // --- THEN ---
        #expect(context.actionDelegate.invokedConstructCollectionView)
        #expect(context.actionDelegate.invokedConstructCollectionViewCount == 1)
        
        #expect(context.actionDelegate.invokedSetStateViewData)
        #expect(context.actionDelegate.invokedSetStateViewDataCount == 1)
        
        #expect(context.viewModel.collectionViewModel.myTripListData.count > 0)
    }
    
    @Test("notify collection view trip item rebook did tap - should open rebook page")
    func notifyCollectionViewTripItemRebookDidTap_shouldOpenRebookPage() async throws {
        // --- GIVEN ---
        let context = try TestContext.setup()
        let mockId = 40
        context.viewModel.responses = context.bookingDetails.values
        
        // --- WHEN ---
        context.viewModel.notifyCollectionViewTripItemRebookDidTap(mockId)
        
        // --- THEN ---
        #expect(context.actionDelegate.invokedGoToRebookingDetail)
        #expect(context.actionDelegate.invokedGoToRebookingDetailCount == 1)
        #expect(context.actionDelegate.invokedGoToRebookingDetailParameters?.data.bookingId == mockId)
        #expect(context.actionDelegate.invokedGoToRebookingDetailParametersList.count == 1)
    }
    
    @Test("notify collection view trip item did tap - should open detail page")
    func notifyCollectionViewTripItemDidTap_shouldOpenDetailPage() async throws {
        // --- GIVEN ---
        let context = try TestContext.setup()
        let mockId = 40
        context.viewModel.responses = context.bookingDetails.values
        
        // --- WHEN ---
        context.viewModel.notifyCollectionViewTripItemDidTap(mockId)
        
        // --- THEN ---
        #expect(context.actionDelegate.invokedGoToBookingDetail)
        #expect(context.actionDelegate.invokedGoToBookingDetailCount == 1)
        #expect(context.actionDelegate.invokedGoToBookingDetailParameters?.data.bookingId == mockId)
        #expect(context.actionDelegate.invokedGoToBookingDetailParametersList.count == 1)
    }
}

private final class MockMyTripViewModelAction: MyTripViewModelAction {
    
    var invokedConstructCollectionView = false
    var invokedConstructCollectionViewCount = 0
    
    func contructCollectionView(viewModel: any Coco.MyTripListCollectionViewModelProtocol) {
        invokedConstructCollectionView = true
        invokedConstructCollectionViewCount += 1
    }
    
    var invokedGoToBookingDetail: Bool = false
    var invokedGoToBookingDetailCount: Int = 0
    var invokedGoToBookingDetailParameters: (data: Coco.BookingDetails, Void)?
    var invokedGoToBookingDetailParametersList = [(data: Coco.BookingDetails, Void)]()
    
    func goToBookingDetail(with data: Coco.BookingDetails) {
        invokedGoToBookingDetail = true
        invokedGoToBookingDetailCount += 1
        invokedGoToBookingDetailParameters = (data, ())
        invokedGoToBookingDetailParametersList.append((data, ()))
    }
    
    var invokedGoToRebookingDetail: Bool = false
    var invokedGoToRebookingDetailCount: Int = 0
    var invokedGoToRebookingDetailParameters: (data: Coco.BookingDetails, Void)?
    var invokedGoToRebookingDetailParametersList = [(data: Coco.BookingDetails, Void)]()
    
    func goToRebookingDetail(with data: Coco.BookingDetails) {
        invokedGoToRebookingDetail = true
        invokedGoToRebookingDetailCount += 1
        invokedGoToRebookingDetailParameters = (data, ())
        invokedGoToRebookingDetailParametersList.append((data, ()))
    }
    
    var invokedSegmentDidChange: Bool = false
    var invokedSegmentDidChangeCount: Int = 0
    var invokedSegmentDidChangeParameters: (index: Int, Void)?
    var invokedSegmentDidChangeParametersList = [(index: Int, Void)]()
    
    func segmentDidChange(to index: Int) {
        invokedSegmentDidChange = true
        invokedSegmentDidChangeCount += 1
        invokedSegmentDidChangeParameters = (index, ())
        invokedSegmentDidChangeParametersList.append((index, ()))
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
