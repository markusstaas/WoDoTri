//  Copyright © 2018 Markus Staas. All rights reserved.

import UIKit

final class MeasurementTableViewCell: UITableViewCell {

    @IBOutlet private var measurementPropertyLabel: UILabel!
    @IBOutlet private var measurementValueLabel: UILabel!
    @IBOutlet private var measurementUnitLabel: UILabel!

    static let preferredReuseIdentifier = "Measurement Cell"

    override func awakeFromNib() {
        super.awakeFromNib()
        measurementValueLabel.font = measurementValueLabel.font.monospacedDigitFont
    }

    func updateMeasurement(property: String, value: String, unit: String?) {
        measurementPropertyLabel.text = property
        measurementValueLabel.text = value
        measurementUnitLabel.text = unit
    }

}
