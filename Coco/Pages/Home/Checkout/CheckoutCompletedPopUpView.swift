//
//  CheckoutCompletedPopUpView.swift
//  Coco
//
//  Created by Jackie Leonardy on 12/07/25.
//

import Foundation
import SwiftUI

struct CheckoutCompletedPopUpView: View {
    let continueDidTap: () -> Void
    
    var body: some View {
        VStack(alignment: .center, spacing: 24.0) {
            Image(uiImage: CocoIcon.icCheckoutCompleteIcon.image)
                .resizable()
                .scaledToFit()
                .frame(width: 100.0, height: 100.0)
            
            VStack(spacing: 4.0) {
                Text("Booking Completed")
                    .font(.jakartaSans(forTextStyle: .title3, weight: .semibold))
                    .foregroundStyle(Token.additionalColorsBlack.toColor())
                    .multilineTextAlignment(.center)
                
                Text("Please pay to trip povider during your trip.")
                    .font(.jakartaSans(forTextStyle: .body, weight: .regular))
                    .foregroundStyle(Token.grayscale70.toColor())
                    .multilineTextAlignment(.center)
            }
            
            CocoButton(
                action: continueDidTap,
                text: "Continue",
                style: .normal,
                type: .primary
            )
        }
        .padding(32.0)
    }
}

