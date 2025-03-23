//
//  URLConvertibleTests.swift
//  HaviNetworkTests
//
//  Created by 한상진 on 12/18/24.
//

import Testing
import Foundation
@testable import HaviNetwork

struct URLConvertibleTests {
  
  @Test func string을_url로_변경할_수_있다() {
    let testURLString = "https://www.example.com"
    
    do {
      let url = try testURLString.asURL()
      #expect(url.absoluteString == testURLString)
    }
    catch {
      Issue.record()
    }
  }
  
  @Test func url을_url로_변경할_수_있다() {
    let testURLString = "https://www.example.com"
    let testURL: URL = URL(string: testURLString)!
    do {
      let url = try testURL.asURL()
      #expect(url == testURL)
    }
    catch {
      Issue.record()
    }
  } 
}
