//
//  HomeFormScheduleViewModel.swift
//  Coco
//
//  Created by Jackie Leonardy on 12/07/25.
//

import Foundation

struct HomeFormScheduleViewModelInput {
    let package: ActivityDetailDataModel
    let selectedPackageId: Int
}

final class HomeFormScheduleViewModel {
    weak var delegate: (any HomeFormScheduleViewModelDelegate)?
    weak var actionDelegate: (any HomeFormScheduleViewModelAction)?
    
    init(input: HomeFormScheduleViewModelInput, fetcher: CreateBookingFetcherProtocol = CreateBookingFetcher()) {
        self.input = input
        self.fetcher = fetcher
    }
    
    private let input: HomeFormScheduleViewModelInput
    private lazy var calendarInputViewModel: HomeSearchBarViewModel = HomeSearchBarViewModel(
        leadingIcon: nil,
        placeholderText: "Input Date Visit...",
        currentTypedText: "",
        trailingIcon: (
            image: CocoIcon.icFilterIcon.image,
            didTap: openCalendar
        ),
        isTypeAble: false,
        delegate: self
    )
    private lazy var paxInputViewModel: HomeSearchBarViewModel = HomeSearchBarViewModel(
        leadingIcon: nil,
        placeholderText: "Input total Pax...",
        currentTypedText: "",
        trailingIcon: nil,
        isTypeAble: true,
        delegate: self
    )
    private var chosenDateInput: Date? {
        didSet {
            guard let chosenDateInput else { return }
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMMM, yyyy"
            calendarInputViewModel.currentTypedText = dateFormatter.string(from: chosenDateInput)
        }
    }
    private let fetcher: CreateBookingFetcherProtocol
}

extension HomeFormScheduleViewModel: HomeFormScheduleViewModelProtocol {
    func onViewDidLoad() {
        actionDelegate?.setupView(
            calendarViewModel: calendarInputViewModel,
            paxInputViewModel: paxInputViewModel
        )
        
        let data: HomeFormScheduleViewData = HomeFormScheduleViewData(
            imageString: input.package.imageUrlsString.first ?? "",
            activityName: input.package.title,
            packageName: input.package.availablePackages.content.first { $0.id == input.selectedPackageId }?.name ?? "",
            location: input.package.location
        )
        
        actionDelegate?.configureView(data: data)
    }
    
    func onCalendarDidChoose(date: Date) {
        chosenDateInput = date
    }
    
    func onCheckout() {
        Task {
            do {
                let request: CreateBookingSpec = CreateBookingSpec(
                    packageId: input.selectedPackageId,
                    bookingDate: chosenDateInput ?? Date(),
                    participants: Int(paxInputViewModel.currentTypedText) ?? 1,
                    userId: UserDefaults.standard.value(forKey: "user-id") as? String ?? ""
                )

                let response: CreateBookingResponse = try await fetcher.createBooking(request: request)
                delegate?.notifyFormScheduleDidNavigateToCheckout(with: response)
            }
            catch {
                
            }
        }
    }
}

extension HomeFormScheduleViewModel: HomeSearchBarViewModelDelegate {
    func notifyHomeSearchBarDidTap(isTypeAble: Bool, viewModel: HomeSearchBarViewModel) {
        if viewModel === calendarInputViewModel {
            actionDelegate?.showCalendarOption()
        }
        else if viewModel === paxInputViewModel {
            
        }
    }
}

private extension HomeFormScheduleViewModel {
    func openCalendar() {
        
    }
}
