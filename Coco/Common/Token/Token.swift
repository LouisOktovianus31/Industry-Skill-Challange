//
//  Token.swift
//  Coco
//
//  Created by Jackie Leonardy on 03/07/25.
//

import Foundation
import UIKit

enum Token {
    @ColorElement(light: UIColor.from("#1AB2E5"), dark: UIColor.from("#1AB2E5"))
    static var mainColorPrimary: UIColor
    
    @ColorElement(light: UIColor.from("#F6F8FE"), dark: UIColor.from("#F6F8FE"))
    static var mainColorSecondary: UIColor
    
    @ColorElement(light: UIColor.from("#2F3C33"), dark: UIColor.from("#2F3C33"))
    static var mainColorDarkGray: UIColor
    
    @ColorElement(light: UIColor.from("#B9EC63"), dark: UIColor.from("#B9EC63"))
    static var mainColorLemon: UIColor
    
    @ColorElement(light: UIColor.from("#F6F5F6"), dark: UIColor.from("#F6F5F6"))
    static var mainColorForth: UIColor
    
    @ColorElement(light: UIColor.from("#00C566"), dark: UIColor.from("#00C566"))
    static var alertsSuccess: UIColor
    
    @ColorElement(light: UIColor.from("#E53935"), dark: UIColor.from("#E53935"))
    static var alertsError: UIColor
    
    @ColorElement(light: UIColor.from("#FACC15"), dark: UIColor.from("#FACC15"))
    static var alertsWarning: UIColor
    
    @ColorElement(light: UIColor.from("#FEFEFE"), dark: UIColor.from("#FEFEFE"))
    static var additionalColorsWhite: UIColor
    
    @ColorElement(light: UIColor.from("#E3E7EC"), dark: UIColor.from("#E3E7EC"))
    static var additionalColorsLine: UIColor
    
    @ColorElement(light: UIColor.from("#282837"), dark: UIColor.from("#282837"))
    static var additionalColorsLineDark: UIColor
    
    @ColorElement(light: UIColor.from("#111111"), dark: UIColor.from("#111111"))
    static var additionalColorsBlack: UIColor
    
    @ColorElement(light: UIColor.from("#936DFF"), dark: UIColor.from("#936DFF"))
    static var additionalColorsPurple: UIColor
    
    @ColorElement(light: UIColor.from("#FF784B"), dark: UIColor.from("#FF784B"))
    static var additionalColorsOrange: UIColor
    
    @ColorElement(light: UIColor.from("#E3E9ED"), dark: UIColor.from("#E3E9ED"))
    static var grayscale10: UIColor
    
    @ColorElement(light: UIColor.from("#ECF1F6"), dark: UIColor.from("#ECF1F6"))
    static var grayscale20: UIColor
    
    @ColorElement(light: UIColor.from("#E3E9ED"), dark: UIColor.from("#E3E9ED"))
    static var grayscale30: UIColor
    
    @ColorElement(light: UIColor.from("#D1D8DD"), dark: UIColor.from("#D1D8DD"))
    static var grayscale40: UIColor
    
    @ColorElement(light: UIColor.from("#BFC6CC"), dark: UIColor.from("#BFC6CC"))
    static var grayscale50: UIColor
    
    @ColorElement(light: UIColor.from("#9CA4AB"), dark: UIColor.from("#9CA4AB"))
    static var grayscale60: UIColor
    
    @ColorElement(light: UIColor.from("#78828A"), dark: UIColor.from("#78828A"))
    static var grayscale70: UIColor
    
    @ColorElement(light: UIColor.from("#66707A"), dark: UIColor.from("#66707A"))
    static var grayscale80: UIColor
    
    @ColorElement(light: UIColor.from("#434E58"), dark: UIColor.from("#434E58"))
    static var grayscale90: UIColor
     
    @ColorElement(light: UIColor.from("#171725"), dark: UIColor.from("#171725"))
    static var grayscale100: UIColor
}
