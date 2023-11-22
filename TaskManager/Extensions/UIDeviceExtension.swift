//
//  UIDeviceExtension.swift
//  TaskManager
//
//  Created by Влад Новолоакэ on 30.10.2023.
//

import UIKit

extension UIDevice {
    func checkIfHasDynamicIsland() -> Bool{
        if let simulatorModelIdentifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
            let nameSimulator = simulatorModelIdentifier
            return nameSimulator == "iPhone15,2" || nameSimulator == "iPhone15,3" || nameSimulator == "iPhone15,4" || nameSimulator == "iPhone15,5" || nameSimulator == "iPhone16,1" || nameSimulator == "iPhone16,2"  ? true : false
        }
        
        var sysinfo = utsname()
        uname(&sysinfo)
        let name =  String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
        return name == "iPhone15,2" || name == "iPhone15,3" || name == "iPhone15,4" || name == "iPhone15,5" || name == "iPhone16,1" || name == "iPhone16,2" ? true : false
    }
}
