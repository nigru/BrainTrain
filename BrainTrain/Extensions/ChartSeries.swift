//
//  ChartSeries.swift
//  BrainTrain
//
//  Created by Nikolai Gruschke on 16.06.17.
//  Copyright © 2017 Gruppe 4. All rights reserved.
//

import SwiftChart

extension ChartSeries {

    convenience init(_ series: [Score]) {
        var values: [Float] = []
        for score in series.reversed() {
            values.append(Float(score.score))
        }

        self.init(values)
    }

}
