//
//  TestPlainLoader.swift
//  Astrolabe
//
//  Created by Vladimir Burdukov on 10/2/17.
//  Copyright © 2017 NetcoSports. All rights reserved.
//

import Astrolabe
import Gnomon
import Nimble

class TestPL: PLoader {

  var didReceiveCount = 0

  typealias PLResult = SingleOptionalResult<TestModel1>
  typealias Context = Void

  func request(for loadingIntent: LoaderIntent, context: Context) throws -> Request<PLResult> {
    return try RequestBuilder().setURLString("\(Params.API.baseURL)/cache/20").setMethod(.GET)
      .setParams(["id1": "123"]).setXPath("args").build()
  }

  typealias Cell = CollectionCell<TestViewCell>

  func sections(from result: PLResult, loadingIntent: LoaderIntent, context: Context) -> [Sectionable]? {
    if Thread.isMainThread { fail("sections should not be called in main thread") }
    return [Section(cells: [result.model].flatMap { $0 }.map { Cell(data: TestViewCell.ViewModel($0)) })]
  }

  func didReceive(result: PLResult, loadingIntent: LoaderIntent, context: Context) {
    if !Thread.isMainThread { fail("didReceive should be called in main thread") }
    didReceiveCount += 1
  }

}
