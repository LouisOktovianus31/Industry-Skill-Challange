//
//  InviteTravelerCollectionViewModelTest.swift
//  Coco
//
//  Created by Arin Juan Sari on 27/08/25.
//

import Foundation
import Testing
@testable import Coco

struct InviteTravelerCollectionViewModelTest {
    private struct TextContext {
        let viewModel: InviteTravelerCollectionViewModel
        let travelers: [Traveler]
        
        static func setup() throws -> TextContext {
            let viewModel = InviteTravelerCollectionViewModel()
            let travelers: [Traveler] = [
                            Traveler(name: "Alice", email: "alice@email.com"),
                            Traveler(name: "Bob", email: "bob@email.com")
                        ]
            
            travelers.forEach { viewModel.onAddEmailTraveler($0.email) }
            
            return TextContext(viewModel: viewModel, travelers: travelers)
        }
    }
    
    @Test("reset data - should empty")
    func resetData_shouldEmpty() async throws {
        // --- GIVEN ---
        let context = try TextContext.setup()
        #expect(context.viewModel.emailTravelerListData.count == 2)
        
        // --- WHEN ---
        context.viewModel.resetData()
        
        // --- THEN ---
        #expect(context.viewModel.emailTravelerListData.isEmpty)
    }
    
    @Test("on add email traveler - should append email")
    func onAddEmailTraveler_shouldAppendEmail() async throws {
        // --- GIVEN ---
        let context = try TextContext.setup()
        let newEmail = "alexandra@email.com"
        
        // --- WHEN ---
        context.viewModel.onAddEmailTraveler(newEmail)
        
        // --- THEN ---
        #expect(context.viewModel.emailTravelerListData.last?.email == newEmail)
    }
    
    @Test("on remove email traveler - should remove email")
    func onRemoveEmailTraveler_shouldRemoveEmail() async throws {
        // --- GIVEN ---
        let context = try TextContext.setup()
        let initialCount = context.viewModel.emailTravelerListData.count
        
        // --- WHEN ---
        context.viewModel.onRemoveEmailTraveler(at: 0)
        
        // --- THEN ---
        #expect(context.viewModel.emailTravelerListData.count == initialCount - 1)
    }
}
