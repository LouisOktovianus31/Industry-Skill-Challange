//
//  InviteTravelerViewModel.swift
//  Coco
//
//  Created by Arin Juan Sari on 19/08/25.
//

import Foundation

final class InviteTravelerViewModel: ObservableObject {
    weak var delegate: InviteTravelerViewModelDelegate?
    weak var action: InviteTravelerViewModelAction?
    
    private let data: BookingDetails
    
    init(data: BookingDetails) {
        self.data = data
    }
    
    private lazy var emailInputViewModel: HomeSearchBarViewModel = HomeSearchBarViewModel(
        leadingIcon: nil,
        placeholderText: "Email",
        currentTypedText: currentTypedText,
        trailingIcon: nil,
        isTypeAble: true,
        onSubmit: {  [weak self] email in
            self?.onInviteTravelerDidTap(email, data: self!.data)
        },
        delegate: self
    )
    
    private(set) lazy var collectionViewModel: InviteTravellerCollectionViewModelProtocol = {
        let viewModel: InviteTravelerCollectionViewModel = InviteTravelerCollectionViewModel()
        
        return viewModel
    }()
    @Published var currentTypedText: String = ""
}

extension InviteTravelerViewModel: InviteTravelerViewModelProtocol {
    func viewDidLoad() {
        action?.configureInputEmailView(viewModel: emailInputViewModel)
        action?.configureListEmailView(viewModel: collectionViewModel)
    }
    
    func onInviteTravelerDidTap(_ email: String, data: BookingDetails) {
        self.currentTypedText = email
        collectionViewModel.onAddEmailTraveler(email, data: self.data)
    }
}

extension InviteTravelerViewModel: HomeSearchBarViewModelDelegate {
    func notifyHomeSearchBarDidTap(isTypeAble: Bool, viewModel: HomeSearchBarViewModel) {
        // no-op
    }
}
