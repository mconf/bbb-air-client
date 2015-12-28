package org.bigbluebutton.command {
	
	import org.bigbluebutton.core.IUsersService;
	import org.bigbluebutton.model.IUserSession;
	import org.bigbluebutton.model.User;
	import org.flexunit.rules.IMethodRule;
	import org.mockito.integrations.flexunit4.MockitoRule;
	import org.mockito.integrations.verify;
	
	public class MicrophoneMuteCommandTest {
		
		[Rule]
		public var mockitoRule:IMethodRule = new MockitoRule();
		
		private var microphoneMuteCommand:MicrophoneMuteCommand;
		
		[Mock(type = "org.bigbluebutton.core.IUsersService")]
		public var userService:IUsersService;
		
		[Mock(type = "org.bigbluebutton.model.IUserSession")]
		public var userSession:IUserSession;
		
		[Before]
		public function setUp():void {
			microphoneMuteCommand = new MicrophoneMuteCommand();
			microphoneMuteCommand.userService = userService;
			microphoneMuteCommand.userSession = userSession;
		}
		
		[Test]
		public function muteUser():void {
			var user:User = new User();
			user.muted = false;
			microphoneMuteCommand.user = user;
			microphoneMuteCommand.execute();
			verify().that(userService.mute(user));
		}
		
		[Test]
		public function unmuteUser():void {
			var user:User = new User();
			user.muted = true;
			microphoneMuteCommand.user = user;
			microphoneMuteCommand.execute();
			verify().that(userService.unmute(user));
		}
	}
}
