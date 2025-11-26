//
//  arredondar.swift
//  oh-my-grill-POC
//
//  Created by Jean Pierre on 18/11/25.
//

import Foundation
extension Double {
    func round(para casasDecimais: Int) -> Double {
        let fatorMultiplicador = pow(10, Double(casasDecimais))
        // Multiplica por 100, arredonda, e divide por 100
        return (self * fatorMultiplicador).rounded() / fatorMultiplicador
    }
}
