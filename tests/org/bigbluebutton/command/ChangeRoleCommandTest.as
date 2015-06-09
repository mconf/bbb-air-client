package org.bigbluebutton.command {
	
	import org.bigbluebutton.core.UsersService;
	import org.flexunit.rules.IMethodRule;
	import org.mockito.integrations.flexunit4.MockitoRule;
	import org.mockito.integrations.verify;
	
	public class ChangeRoleCommandTest {
		
		[Rule]
		public var mockitoRule:IMethodRule = new MockitoRule();
		
		private var changeRoleCommand:ChangeRoleCommand;
		
		[Mock(type = "org.bigbluebutton.core.UsersService")]
		public var userService:UsersService;
		
		[Before]
		public function setUp():void {
			changeRoleCommand = new ChangeRoleCommand();
			changeRoleCommand.userService = userService;
		}
		
		[Test]
		public function changeRole():void {
			var roleOptions:Object = new Object();
			roleOptions.userID = "me";
			roleOptions.role = "master of the universe";
			changeRoleCommand.roleOptions = roleOptions;
			changeRoleCommand.execute();
			verify().that(userService.changeRole("me", "master of the universe"));
		}
	}
}
