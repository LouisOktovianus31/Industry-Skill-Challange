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
    
    private let fetcher: InviteTravelerFetcherProtocol?
    
    init(fetcher: InviteTravelerFetcherProtocol? = InviteTravelerFetcher()) {
        self.fetcher = fetcher
    }
    
    private var data: TripBookingDetails? = nil
    
    private lazy var emailInputViewModel: HomeSearchBarViewModel = HomeSearchBarViewModel(
        leadingIcon: nil,
        placeholderText: "Email",
        currentTypedText: currentTypedText,
        trailingIcon: nil,
        isTypeAble: true,
        onSubmit: {  [weak self] email in
            guard let self = self else { return }
            self.onInviteTravelerDidTap(email)
        },
        delegate: self
    )
    
    private(set) lazy var collectionViewModel: InviteTravellerCollectionViewModelProtocol = {
        let viewModel: InviteTravelerCollectionViewModel = InviteTravelerCollectionViewModel()
        
        return viewModel
    }()
    @Published var currentTypedText: String = ""
}

private extension InviteTravelerViewModel {
    func setCollectionViewModelData() {
        collectionViewModel.resetData()
        data?.memberEmails.forEach({ email in
            collectionViewModel.onAddEmailTraveler(email)
        })
    }
}

extension InviteTravelerViewModel: InviteTravelerViewModelProtocol {
    func sendInviteTravelerRequest() {
        Task { @MainActor in
            action?.setStateViewData(StateViewData(.loading))

            do {
                let bookingId = data?.bookingId ?? 0
                let emails = collectionViewModel.emailTravelerListData.map { $0.email }
                
                let _: [CreateBookingByEmailsResponse]? = try await fetcher?.fetchCreateBookingByEmails(
                    bookingId: bookingId,
                    emails: emails
                ).values
                
                action?.setStateViewData(nil)
                delegate?.notifyInviteTravellerComplete()
            } catch {
                
            }
        }

    }
    
    func setData(_ data: TripBookingDetails?) {
        self.data = data
        setCollectionViewModelData()
    }
    
    func viewDidLoad() {
        action?.configureInputEmailView(viewModel: emailInputViewModel)
        action?.configureListEmailView(viewModel: collectionViewModel)
    }
    
    func onInviteTravelerDidTap(_ email: String) {
        self.currentTypedText = email
        
        guard email.contains("@") else {
            emailInputViewModel.error = true
            emailInputViewModel.errorMessage = "Invalid email: must contain '@'"
            return
        }
        
        guard !collectionViewModel.emailTravelerListData.contains(where: { $0.email.lowercased() == email.lowercased() }) else {
            emailInputViewModel.error = true
            emailInputViewModel.errorMessage = "Email already exists in the list"
            return
        }
        
        guard collectionViewModel.emailTravelerListData.count < (data?.participants ?? 0) else {
            emailInputViewModel.error = true
            emailInputViewModel.errorMessage = "Cannot add more travelers."
            return
        }
        
        emailInputViewModel.error = false
        emailInputViewModel.errorMessage = nil
        collectionViewModel.onAddEmailTraveler(email)
    }
}

extension InviteTravelerViewModel: HomeSearchBarViewModelDelegate {
    func notifyHomeSearchBarDidTap(isTypeAble: Bool, viewModel: HomeSearchBarViewModel) {
        // no-op
    }
}
