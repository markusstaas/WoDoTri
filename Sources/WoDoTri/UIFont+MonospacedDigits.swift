//  Copyright © 2018 Markus Staas. All rights reserved.

import UIKit

extension UIFont {

    var monospacedDigitFont: UIFont {
        let oldFontDescriptor = fontDescriptor
        let newFontDescriptor = oldFontDescriptor.monospacedDigitFontDescriptor
        return UIFont(descriptor: newFontDescriptor, size: 0)
    }

}

private extension UIFontDescriptor {

    var monospacedDigitFontDescriptor: UIFontDescriptor {
        let fontDescriptorFeatureSettings = [[
                UIFontDescriptor.FeatureKey.featureIdentifier: kNumberSpacingType,
                UIFontDescriptor.FeatureKey.typeIdentifier: kMonospacedNumbersSelector
            ]
        ]
        let fontDescriptorAttributes = [UIFontDescriptor.AttributeName.featureSettings: fontDescriptorFeatureSettings]
        let fontDescriptor = addingAttributes(fontDescriptorAttributes)
        return fontDescriptor
    }

}
