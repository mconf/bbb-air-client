package org.bigbluebutton.command {
	
	import org.bigbluebutton.core.IUsersService;
	import org.bigbluebutton.model.IUserSession;
	import org.bigbluebutton.model.User;
	import org.flexunit.rules.IMethodRule;
	import org.mockito.integrations.flexunit4.MockitoRule;
	import org.mockito.integrations.verify;
	
	public class PresenterCommandTest {
		
		[Rule]
		public var mockitoRule:IMethodRule = new MockitoRule();
		
		private var presenterCommand:PresenterCommand;
		
		[Mock(type = "org.bigbluebutton.model.IUserSession")]
		public var userSession:IUserSession;
		
		[Mock(type = "org.bigbluebutton.core.IUsersService")]
		public var userService:IUsersService;
		
		[Before]
		public function setUp():void {
			presenterCommand = new PresenterCommand();
			presenterCommand.userService = userService;
			presenterCommand.userSession = userSession;
		}
		
		[Test]
		public function assignPresenter() {
			var user:User = new User();
			presenterCommand.user = user;
			presenterCommand.userMeID = "1";
			presenterCommand.execute();
			verify().that(userService.assignPresenter(user.userID, user.name, "1"));
		}
	}
}
