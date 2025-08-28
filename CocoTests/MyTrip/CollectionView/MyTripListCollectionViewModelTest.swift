//
//  MyTripListCollectionViewModelTest.swift
//  Coco
//
//  Created by Arin Juan Sari on 27/08/25.
//

import Foundation
import Testing
@testable import Coco

struct MyTripListCollectionViewModelTest {
    private struct TestContext {
        let viewModel: MyTripListCollectionViewModel
        let delegate: MockMyTripListCollectionViewModelDelegate
        
        static func setup() throws -> TestContext {
            let viewModel = MyTripListCollectionViewModel()
            let delegate = MockMyTripListCollectionViewModelDelegate()
            
            viewModel.delegate = delegate
            
            return TestContext(viewModel: viewModel, delegate: delegate)
        }
    }
    
    @Test("on trip item rebook did tap - should invoke delegate rebook")
    func onTripItemRebookDidTap_shouldInvokeDelegateRebook() async throws {
        // --- GIVEN ---
        let context = try TestContext.setup()
        let id = 1
        
        // --- WHEN ---
        context.viewModel.onTripItemRebookDidTap(id)
        
        // --- THEN ---
        #expect(context.delegate.invokeNotifyCollectionViewTripItemRebookDidTap)
        #expect(context.delegate.invokeNotifyCollectionVIewTripItemRebookDidTapCount == 1)
        #expect(context.delegate.invokeNotifyCollectionVIewTripItemRebookDidTapParameter?.0 == id)
    }
    
    @Test("update my trip list data - should update data correctly")
    func updateMyTripListData_shouldUpdateDataCorrectly() async throws {
        // --- GIVEN ---
        let context = try TestContext.setup()
        let mockData = [MyTripListCardDataModel(bookingDetail: BookingDetails(trip: getMockTripBookingDetails()))]
        
        // --- WHEN ---
        context.viewModel.updateMyTripListData(mockData)
        
        // --- THEN ---
        #expect(context.viewModel.myTripListData.count == mockData.count)
    }
    
    @Test("on trip item did tap - should invoke delegate")
    func onTripItemDidTap_shouldInvokeDelegate() async throws {
        // --- GIVEN ---
        let context = try TestContext.setup()
        let id = 1
        
        // --- WHEN ---
        context.viewModel.onTripItemDidTap(id)
        
        // --- THEN ---
        #expect(context.delegate.invokeNotifyCollectionViewTripItemDidTap)
        #expect(context.delegate.invokeNotifyCollectionViewTripItemDidTapCount == 1)
        #expect(context.delegate.invokeNotifyCollectionViewTripItemCancelDidTapParameter?.0 == id)
    }
}

private extension MyTripListCollectionViewModelTest {
    func getMockTripBookingDetails() -> TripBookingDetails {
        return TripBookingDetails(bookingId: 1, date: Date(), isPlanner: true, plannerName: "arin", participants: 3, totalPrice: 4000, status: "upcoming", activityTitle: "borobudur", packageName: "individual", destinationName: "candi", destinationImage: nil, longitude: 107, latitude: 205, importantNotice: nil, includedAccessories: [], memberEmails: [], vendorName: "jojo", vendorContact: "email@email.com")
    }
}

private final class MockMyTripListCollectionViewModelDelegate: MyTripListCollectionViewModelDelegate {
    
    var invokeNotifyCollectionViewTripItemDidTap: Bool = false
    var invokeNotifyCollectionViewTripItemDidTapCount: Int = 0
    var invokeNotifyCollectionViewTripItemCancelDidTapParameter: (Int, Void)?
    
    func notifyCollectionViewTripItemDidTap(_ id: Int) {
        invokeNotifyCollectionViewTripItemDidTap = true
        invokeNotifyCollectionViewTripItemDidTapCount += 1
        invokeNotifyCollectionViewTripItemCancelDidTapParameter = (id, ())
    }
    
    var invokeNotifyCollectionViewTripItemRebookDidTap: Bool = false
    var invokeNotifyCollectionVIewTripItemRebookDidTapCount: Int = 0
    var invokeNotifyCollectionVIewTripItemRebookDidTapParameter: (Int, Void)?
    
    func notifyCollectionViewTripItemRebookDidTap(_ id: Int) {
        invokeNotifyCollectionViewTripItemRebookDidTap = true
        invokeNotifyCollectionVIewTripItemRebookDidTapCount += 1
        invokeNotifyCollectionVIewTripItemRebookDidTapParameter = (id, ())
    }
}
