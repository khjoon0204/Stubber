import XCTest
@testable import Stubber

class StubberTests: XCTestCase {
  override func setUp() {
    super.setUp()
    Stubber.clear()
  }

  func testExample() {
    let userService = StubUserService()

    Stubber.stub(userService.follow) { userID in "stub-follow-\(userID)" }
    XCTAssertEqual(userService.follow(userID: 123), "stub-follow-123")
    XCTAssertEqual(Stubber.executions(userService.follow).count, 1)
    XCTAssertEqual(Stubber.executions(userService.follow)[0].arguments, 123)
    XCTAssertEqual(Stubber.executions(userService.follow)[0].result, "stub-follow-123")

    Stubber.stub(userService.follow) { userID in "new-stub-follow-\(userID)" }
    XCTAssertEqual(userService.follow(userID: 456), "new-stub-follow-456")
    XCTAssertEqual(Stubber.executions(userService.follow).count, 1)
    XCTAssertEqual(Stubber.executions(userService.follow)[0].arguments, 456)
    XCTAssertEqual(Stubber.executions(userService.follow)[0].result, "new-stub-follow-456")

    Stubber.clear()
    XCTAssertEqual(Stubber.executions(userService.follow).isEmpty, true)
  }

  func testNoArgument() {
    let userService = StubUserService()
    let articleService = StubArticleService()
    Stubber.stub(userService.foo) { "User" }
    Stubber.stub(articleService.bar) { "Article" }
    XCTAssertEqual(userService.foo(), "User")
    XCTAssertEqual(articleService.bar(), "Article")
  }
}

protocol UserServiceType {
  func foo() -> String
  func follow(userID: Int) -> String
  func unfollow(userID: Int) -> String
}

protocol ArticleServiceType {
  func bar() -> String
  func like(articleID: Int) -> String
}

final class StubUserService: UserServiceType {
  func foo() -> String {
    return Stubber.stubbed(foo, args: ())
  }

  func follow(userID: Int) -> String {
    return Stubber.stubbed(follow, args: userID)
  }

  func unfollow(userID: Int) -> String {
    return Stubber.stubbed(unfollow, args: userID)
  }
}

final class StubArticleService: ArticleServiceType {
  func bar() -> String {
    return Stubber.stubbed(bar, args: ())
  }

  func like(articleID: Int) -> String {
    return Stubber.stubbed(like, args: articleID)
  }
}
