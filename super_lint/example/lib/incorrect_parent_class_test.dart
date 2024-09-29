// ignore_for_file: unused_local_variable, prefer_common_widgets

// ~.~.~.~.~.~.~.~ THE FOLLOWING CASES SHOULD NOT BE WARNED ~.~.~.~.~.~.~.~
class LoginPage extends BasePage {}

class HomeScreen extends AbstractScreen {}

class BasePage {}

class AbstractScreen {}

// ~.~.~.~.~.~.~.~ THE FOLLOWING CASES SHOULD BE WARNED ~.~.~.~.~.~.~.~

// expect_lint: incorrect_parent_class
class MainPage extends Page {}

// expect_lint: incorrect_parent_class
class AboutScreen extends Screen {}

class Page {}

class Screen {}
