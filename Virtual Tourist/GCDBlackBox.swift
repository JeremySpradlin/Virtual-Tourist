//
//  GCDBlackBox.swift
//  Virtual Tourist
//
//  Created by Jeremy Spradlin on 1/28/18.
//  Copyright © 2018 Jeremy Spradlin. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
