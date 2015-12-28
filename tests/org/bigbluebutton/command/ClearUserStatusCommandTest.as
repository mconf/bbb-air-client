package org.bigbluebutton.command {
	
	import org.bigbluebutton.core.UsersService;
	import org.bigbluebutton.model.IConferenceParameters;
	import org.bigbluebutton.model.User;
	import org.bigbluebutton.model.UserList;
	import org.bigbluebutton.model.UserSession;
	import org.flexunit.rules.IMethodRule;
	import org.mockito.integrations.any;
	import org.mockito.integrations.flexunit4.MockitoRule;
	import org.mockito.integrations.given;
	import org.mockito.integrations.verify;
	
	public class ClearUserStatusCommandTest {
		
		[Rule]
		public var mockitoRule:IMethodRule = new MockitoRule();
		
		private var clearUserStatusCommand:ClearUserStatusCommand;
		
		[Mock(type = "org.bigbluebutton.core.UsersService")]
		public var userService:UsersService;
		
		[Mock(type = "org.bigbluebutton.model.IConferenceParameters")]
		public var conferenceParameters:IConferenceParameters;
		
		[Mock(type = "org.bigbluebutton.model.UserSession")]
		public var userSession:UserSession;
		
		[Mock(type = "org.bigbluebutton.model.UserList")]
		public var userList:UserList;
		
		[Mock(type = "org.bigbluebutton.model.User")]
		public var user:User;
		
		[Before]
		public function setUp():void {
			clearUserStatusCommand = new ClearUserStatusCommand();
			clearUserStatusCommand.userService = userService;
			clearUserStatusCommand.conferenceParameters = conferenceParameters;
			clearUserStatusCommand.userSession = userSession;
			given(userSession.userList).willReturn(userList);
			given(userSession.userList.me).willReturn(user);
		}
		
		[Test]
		public function lowerHand():void {
			given(conferenceParameters.serverIsMconf).willReturn(false);
			clearUserStatusCommand.userID = "my user id";
			clearUserStatusCommand.execute();
			verify().that(userService.lowerHand(any(), any()));
		}
		
		[Test]
		public function clearStatus():void {
			given(conferenceParameters.serverIsMconf).willReturn(true);
			clearUserStatusCommand.userID = "my user id";
			clearUserStatusCommand.execute();
			verify().that(userService.clearUserStatus("my user id"));
		}
	}
}
