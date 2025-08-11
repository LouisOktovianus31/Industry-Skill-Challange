//
//  HomeViewModelTest.swift
//  CocoTests
//
//  Created by Jackie Leonardy on 26/07/25.
//

import Foundation
import Testing
@testable import Coco

struct HomeViewModelTest {
    private struct TestContext {
        let fetcher: MockActivityFetcher
        let actionDelegate: MockHomeViewModelAction
        let navigationDelegate: MockHomeViewModelNavigationDelegate
        let viewModel: HomeViewModel
        let activities: ActivityModelArray
        
        static func setup() throws -> TestContext {
            let fetcher = MockActivityFetcher()
            let actionDelegate = MockHomeViewModelAction()
            let navigationDelegate = MockHomeViewModelNavigationDelegate()
            
            let activities: ActivityModelArray = try JSONReader.getObjectFromJSON(with: "activities")
            fetcher.stubbedFetchActivityCompletionResult = (.success(activities), ())
            
            let viewModel = HomeViewModel(activityFetcher: fetcher)
            viewModel.actionDelegate = actionDelegate
            viewModel.navigationDelegate = navigationDelegate
            
            return TestContext(
                fetcher: fetcher,
                actionDelegate: actionDelegate,
                navigationDelegate: navigationDelegate,
                viewModel: viewModel,
                activities: activities
            )
        }
    }
    
    // MARK: - Filter Tests
    
    @Test("filter tray - should open on icon tap")
    func filterTray_whenIconTapped_shouldOpen() async throws {
        // --- GIVEN ---
        let context = try TestContext.setup()
        
        // --- WHEN ---
        context.viewModel.onViewDidLoad()
        context.viewModel.searchBarViewModel.trailingIcon?.didTap?()
        
        // --- THEN ---
        #expect(context.actionDelegate.invokedOpenFilterTrayCount == 1)
    }
    
    @Test("filter tray - should apply filters")
    func filterTray_whenFiltersApplied_shouldUpdateCollection() async throws {
        // --- GIVEN ---
        let context = try TestContext.setup()
        
        // --- WHEN ---
        context.viewModel.onViewDidLoad()
        context.viewModel.searchBarViewModel.trailingIcon?.didTap?()
        
        let filterModel = HomeSearchFilterTrayDataModel(
            filterPillDataState: [],
            priceRangeModel: HomeSearchFilterPriceRangeModel(
                minPrice: 499000.0,
                maxPrice: 200000,
                range: 0...0
            )
        )
        
        // --- THEN ---
        context.actionDelegate.invokedOpenFilterTrayParameters?.viewModel
            .filterDidApplyPublisher.send(filterModel)
        
        #expect(context.actionDelegate.invokedOpenFilterTrayCount == 1)
        #expect(context.viewModel.collectionViewModel.activityData.dataModel.count == 1)
    }
    
    // MARK: - Initial Load Tests
    
    @Test("view did load - should setup initial state")
    func viewDidLoad_whenSuccessful_shouldSetupInitialState() async throws {
        // --- GIVEN ---
        let context = try TestContext.setup()
        
        // --- WHEN ---
        #expect(context.viewModel.loadingState.percentage == 0)
        context.viewModel.onViewDidLoad()
        
        // --- THEN ---
        assertViewDidLoadSetup(context)
        #expect(context.actionDelegate.invokedToggleLoadingViewParameters?.isShown == false)
        #expect(context.actionDelegate.invokedToggleLoadingViewParameters?.after == 1.0)
        
        let expectedActivity = HomeActivityCellDataModel(activity: context.activities.values[0])
        #expect(context.viewModel.collectionViewModel.activityData == ("", [expectedActivity]))
    }
    
    // MARK: - Search Tests
    
    @Test("search - should handle empty query")
    func search_whenEmptyQuery_shouldUpdateState() async throws {
        // --- GIVEN ---
        let context = try TestContext.setup()
        
        context.viewModel.onViewDidLoad()
        
        let emptyActivities: ActivityModelArray = try JSONReader.getObjectFromJSON(with: "activities-empty")
        context.fetcher.stubbedFetchActivityCompletionResult = (.success(emptyActivities), ())
        
        // --- WHEN ---
        context.viewModel.onSearchDidApply("")
        
        // --- THEN ---
        #expect(context.viewModel.searchBarViewModel.currentTypedText == "")
        #expect(context.viewModel.loadingState.percentage == 100)
        assertLoadingStates(context, states: [false, true, false])
        #expect(context.viewModel.collectionViewModel.activityData == ("", []))
    }
    
    // MARK: - Activity Selection Tests
    
    @Test("activity selection - should handle valid selection")
    func activitySelection_whenValidId_shouldNotifyDelegate() async throws {
        // --- GIVEN ---
        let context = try TestContext.setup()
        
        context.viewModel.onViewDidLoad()
        
        let activityData = HomeActivityCellDataModel(
            id: 1,
            area: "area",
            name: "name",
            priceText: "priceText",
            imageUrl: nil
        )
        
        // --- WHEN ---
        context.viewModel.notifyCollectionViewActivityDidTap(activityData)
        
        // --- THEN ---
        #expect(context.actionDelegate.invokedActivityDidSelectCount == 1)
        
        let selectedData = context.actionDelegate.invokedActivityDidSelectParameters?.data
        #expect(selectedData?.title == "Snorkeling Adventure in Nusa Penida")
        #expect(selectedData?.location == "Nusa Penida")
        #expect(selectedData?.imageUrlsString == [
            "https://example.com/images/nusa-penida-thumb.jpg",
            "https://example.com/images/nusa-penida-gallery1.jpg"
        ])
        
        // Details
        #expect(selectedData?.detailInfomation.title == "Details")
        #expect(selectedData?.detailInfomation.content == "Explore the stunning underwater world of Nusa Penida with our professional guides. Perfect for beginners and experienced snorkelers alike.")
        
        // Provider
        #expect(selectedData?.providerDetail.title == "Trip Provider")
        #expect(selectedData?.providerDetail.content.name == "Made Wirawan")
        #expect(selectedData?.providerDetail.content.imageUrlString == "https://example.com/hosts/made-wirawan.jpg")
        #expect(selectedData?.providerDetail.content.description == "Professional diving instructor with 5 years of experience")
        
        // Facilities
        #expect(selectedData?.tripFacilities.title == "This Trip Includes")
        #expect(selectedData?.tripFacilities.content == ["Snorkeling Equipment", "Life Jacket", "Waterproof Camera"])
        
        // Packages
        #expect(selectedData?.availablePackages.title == "Available Packages")
        #expect(selectedData?.availablePackages.content.count == 2)
        #expect(selectedData?.hiddenPackages.count == selectedData?.availablePackages.content.count)
    }
    
    @Test("activity selection - should handle invalid selection")
    func activitySelection_whenInvalidId_shouldNotNotifyDelegate() async throws {
        // --- GIVEN ---
        let context = try TestContext.setup()
        
        context.viewModel.onViewDidLoad()
        
        let invalidActivityData = HomeActivityCellDataModel(
            id: 999,
            area: "area",
            name: "name",
            priceText: "priceText",
            imageUrl: nil
        )
        
        // --- WHEN ---
        context.viewModel.notifyCollectionViewActivityDidTap(invalidActivityData)
        
        // --- THEN ---
        #expect(context.actionDelegate.invokedActivityDidSelectCount == 0)
    }
    
    // MARK: - Search Bar Interaction Tests
    
    @Test("search bar - typeable interaction")
    func searchBar_whenTypeable_shouldNotOpenTray() async throws {
        // --- GIVEN ---
        let context = try TestContext.setup()
        
        let searchBarViewModel = HomeSearchBarViewModel(
            leadingIcon: nil,
            placeholderText: "",
            currentTypedText: "",
            trailingIcon: nil,
            isTypeAble: true,
            delegate: nil
        )
        
        // --- WHEN ---
        context.viewModel.notifyHomeSearchBarDidTap(
            isTypeAble: true,
            viewModel: searchBarViewModel
        )
        
        // --- THEN ---
        #expect(context.actionDelegate.invokedOpenSearchTrayCount == 0)
    }
    
    @Test("search bar - non-typeable interaction")
    func searchBar_whenNonTypeable_shouldOpenTray() async throws {
        // --- GIVEN ---
        let context = try TestContext.setup()
        
        let searchBarViewModel = HomeSearchBarViewModel(
            leadingIcon: nil,
            placeholderText: "",
            currentTypedText: "",
            trailingIcon: nil,
            isTypeAble: false,
            delegate: nil
        )
        
        // --- WHEN ---
        context.viewModel.notifyHomeSearchBarDidTap(
            isTypeAble: false,
            viewModel: searchBarViewModel
        )
        
        // --- THEN ---
        #expect(context.actionDelegate.invokedOpenSearchTrayCount == 1)
    }
}

// MARK: - Test Helpers

private extension HomeViewModelTest {
    private func assertViewDidLoadSetup(_ context: TestContext) {
        #expect(context.actionDelegate.invokedConstructCollectionViewCount == 1)
        #expect(context.actionDelegate.invokedConstructLoadingStateCount == 1)
        #expect(context.actionDelegate.invokedConstructNavBarCount == 1)
        #expect(context.viewModel.loadingState.percentage == 100)
    }
    
    private func assertLoadingStates(_ context: TestContext, states: [Bool]) {
        #expect(context.actionDelegate.invokedToggleLoadingViewParametersList.map { $0.isShown } == states)
    }
}

private final class MockHomeViewModelAction: HomeViewModelAction {

    var invokedConstructCollectionView = false
    var invokedConstructCollectionViewCount = 0

    func constructCollectionView(viewModel: some HomeCollectionViewModelProtocol) {
        invokedConstructCollectionView = true
        invokedConstructCollectionViewCount += 1
    }

    var invokedConstructLoadingState = false
    var invokedConstructLoadingStateCount = 0
    var invokedConstructLoadingStateParameters: (state: HomeLoadingState, Void)?
    var invokedConstructLoadingStateParametersList = [(state: HomeLoadingState, Void)]()

    func constructLoadingState(state: HomeLoadingState) {
        invokedConstructLoadingState = true
        invokedConstructLoadingStateCount += 1
        invokedConstructLoadingStateParameters = (state, ())
        invokedConstructLoadingStateParametersList.append((state, ()))
    }

    var invokedConstructNavBar = false
    var invokedConstructNavBarCount = 0
    var invokedConstructNavBarParameters: (viewModel: HomeSearchBarViewModel, Void)?
    var invokedConstructNavBarParametersList = [(viewModel: HomeSearchBarViewModel, Void)]()

    func constructNavBar(viewModel: HomeSearchBarViewModel) {
        invokedConstructNavBar = true
        invokedConstructNavBarCount += 1
        invokedConstructNavBarParameters = (viewModel, ())
        invokedConstructNavBarParametersList.append((viewModel, ()))
    }

    var invokedToggleLoadingView = false
    var invokedToggleLoadingViewCount = 0
    var invokedToggleLoadingViewParameters: (isShown: Bool, after: CGFloat)?
    var invokedToggleLoadingViewParametersList = [(isShown: Bool, after: CGFloat)]()

    func toggleLoadingView(isShown: Bool, after: CGFloat) {
        invokedToggleLoadingView = true
        invokedToggleLoadingViewCount += 1
        invokedToggleLoadingViewParameters = (isShown, after)
        invokedToggleLoadingViewParametersList.append((isShown, after))
    }

    var invokedActivityDidSelect = false
    var invokedActivityDidSelectCount = 0
    var invokedActivityDidSelectParameters: (data: ActivityDetailDataModel, Void)?
    var invokedActivityDidSelectParametersList = [(data: ActivityDetailDataModel, Void)]()

    func activityDidSelect(data: ActivityDetailDataModel) {
        invokedActivityDidSelect = true
        invokedActivityDidSelectCount += 1
        invokedActivityDidSelectParameters = (data, ())
        invokedActivityDidSelectParametersList.append((data, ()))
    }

    var invokedOpenSearchTray = false
    var invokedOpenSearchTrayCount = 0
    var invokedOpenSearchTrayParameters: (selectedQuery: String, latestSearches: [HomeSearchSearchLocationData])?
    var invokedOpenSearchTrayParametersList = [(selectedQuery: String, latestSearches: [HomeSearchSearchLocationData])]()

    func openSearchTray(
        selectedQuery: String,
        latestSearches: [HomeSearchSearchLocationData]
    ) {
        invokedOpenSearchTray = true
        invokedOpenSearchTrayCount += 1
        invokedOpenSearchTrayParameters = (selectedQuery, latestSearches)
        invokedOpenSearchTrayParametersList.append((selectedQuery, latestSearches))
    }

    var invokedOpenFilterTray = false
    var invokedOpenFilterTrayCount = 0
    var invokedOpenFilterTrayParameters: (viewModel: HomeSearchFilterTrayViewModel, Void)?
    var invokedOpenFilterTrayParametersList = [(viewModel: HomeSearchFilterTrayViewModel, Void)]()

    func openFilterTray(_ viewModel: HomeSearchFilterTrayViewModel) {
        invokedOpenFilterTray = true
        invokedOpenFilterTrayCount += 1
        invokedOpenFilterTrayParameters = (viewModel, ())
        invokedOpenFilterTrayParametersList.append((viewModel, ()))
    }

    var invokedDismissTray = false
    var invokedDismissTrayCount = 0

    func dismissTray() {
        invokedDismissTray = true
        invokedDismissTrayCount += 1
    }
}

private final class MockHomeViewModelNavigationDelegate: HomeViewModelNavigationDelegate {

    var invokedNotifyHomeDidSelectActivity = false
    var invokedNotifyHomeDidSelectActivityCount = 0

    func notifyHomeDidSelectActivity() {
        invokedNotifyHomeDidSelectActivity = true
        invokedNotifyHomeDidSelectActivityCount += 1
    }
}
