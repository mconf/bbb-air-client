package org.bigbluebutton.command {
	
	import org.bigbluebutton.core.IUsersService;
	import org.bigbluebutton.model.IUserSession;
	import org.flexunit.rules.IMethodRule;
	import org.mockito.integrations.flexunit4.MockitoRule;
	import org.mockito.integrations.verify;
	
	public class MoodCommandTest {
		
		[Rule]
		public var mockitoRule:IMethodRule = new MockitoRule();
		
		private var moodCommand:MoodCommand;
		
		[Mock(type = "org.bigbluebutton.core.IUsersService")]
		public var userService:IUsersService;
		
		[Mock(type = "org.bigbluebutton.model.IUserSession")]
		public var userSession:IUserSession;
		
		[Before]
		public function setUp():void {
			moodCommand = new MoodCommand();
			moodCommand.userService = userService;
			moodCommand.userSession = userSession;
		}
		
		[Test]
		public function changeMood():void {
			moodCommand.mood = "happy";
			moodCommand.execute();
			verify().that(userService.changeMood("happy"));
		}
	}
}
