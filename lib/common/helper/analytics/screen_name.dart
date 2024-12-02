enum ScreenName {
  allUsers(
    screenName: 'All Users Page',
    screenEventPrefix: 'all_users',
    screenClass: 'AllUsersPage',
  ),
  chat(
    screenName: 'Chat Page',
    screenEventPrefix: 'chat',
    screenClass: 'ChatPage',
  ),
  contactList(
    screenName: 'Contact List Page',
    screenEventPrefix: 'contact_list',
    screenClass: 'ContactListPage',
  ),
  home(
    screenName: 'Home Page',
    screenEventPrefix: 'home',
    screenClass: 'HomePage',
  ),
  login(
    screenName: 'Login Page',
    screenEventPrefix: 'login',
    screenClass: 'LoginPage',
  ),
  main(
    screenName: 'Main Page',
    screenEventPrefix: 'main',
    screenClass: 'MainPage',
  ),
  myPage(
    screenName: 'My Page',
    screenEventPrefix: 'my_page',
    screenClass: 'MyPage',
  ),
  register(
    screenName: 'Register Page',
    screenEventPrefix: 'register',
    screenClass: 'RegisterPage',
  ),
  renameConversation(
    screenName: 'Rename Conversation Page',
    screenEventPrefix: 'rename_conversation',
    screenClass: 'RenameConversationPage',
  ),
  setting(
    screenName: 'Setting Page',
    screenEventPrefix: 'setting',
    screenClass: 'SettingPage',
  );

  const ScreenName({
    required this.screenName,
    required this.screenClass,
    required this.screenEventPrefix,
  });
  final String screenName;
  final String screenClass;
  final String screenEventPrefix;

  @override
  String toString() => '$name / $screenName / prefix: $screenEventPrefix';
}
