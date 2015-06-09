package org.bigbluebutton.command {
	
	import org.bigbluebutton.core.UsersService;
	import org.flexunit.rules.IMethodRule;
	import org.mockito.integrations.flexunit4.MockitoRule;
	import org.mockito.integrations.verify;
	
	public class ClearUserStatusCommandTest {
		
		[Rule]
		public var mockitoRule:IMethodRule = new MockitoRule();
		
		private var clearUserStatusCommand:ClearUserStatusCommand;
		
		[Mock(type = "org.bigbluebutton.core.UsersService")]
		public var userService:UsersService;
		
		[Before]
		public function setUp():void {
			clearUserStatusCommand = new ClearUserStatusCommand();
			clearUserStatusCommand.userService = userService;
		}
		
		[Test]
		public function clearStatus():void {
			clearUserStatusCommand.userID = "my user id";
			clearUserStatusCommand.execute();
			verify().that(userService.clearUserStatus("my user id"));
		}
	}
}
