//
//  main.swift
//  
//
//  Created by Annie Locke on 14.06.2024.
//

import CxxTest

@_cdecl("someFunc")
func someFunc() -> Int
{
    return 64
}

@_cdecl("anotherFunc")
func anotherFunc(pt: UnsafeMutablePointer<Int>)
{
    pt.initialize(to: -64)
}
