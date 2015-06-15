package org.bigbluebutton.command {
	
	import org.bigbluebutton.core.ILoginService;
	import org.bigbluebutton.model.Config;
	import org.bigbluebutton.model.IConferenceParameters;
	import org.bigbluebutton.model.IUserUISession;
	import org.bigbluebutton.model.UserList;
	import org.bigbluebutton.model.UserSession;
	import org.bigbluebutton.model.VideoProfileManager;
	import org.flexunit.rules.IMethodRule;
	import org.mockito.integrations.any;
	import org.mockito.integrations.callOriginal;
	import org.mockito.integrations.flexunit4.MockitoRule;
	import org.mockito.integrations.given;
	import org.mockito.integrations.verify;
	import org.osflash.signals.Signal;
	
	public class JoinMeetingCommandTest {
		
		[Rule]
		public var mockitoRule:IMethodRule = new MockitoRule();
		
		private var joinMeetingCommand:JoinMeetingCommand;
		
		[Mock(type = "org.bigbluebutton.model.UserSession")]
		public var userSession:UserSession;
		
		[Mock(type = "org.bigbluebutton.model.IUserUISession")]
		public var userUISession:IUserUISession;
		
		[Mock(type = "org.bigbluebutton.model.IConferenceParameters")]
		public var conferenceParameters:IConferenceParameters;
		
		[Mock(type = "org.bigbluebutton.core.ILoginService")]
		public var loginService:ILoginService;
		
		[Mock(type = "org.bigbluebutton.command.ConnectSignal")]
		public var connectSignal:ConnectSignal;
		
		[Mock(type = "org.osflash.signals.Signal")]
		public var successJoinedSignal:Signal;
		
		[Mock(type = "org.osflash.signals.Signal")]
		public var successGetConfigSignal:Signal;
		
		[Mock(type = "org.osflash.signals.Signal")]
		public var successGetProfilesSignal:Signal;
		
		[Mock(type = "org.osflash.signals.Signal")]
		public var unsuccessJoinedSignal:Signal;
		
		[Mock(type = "org.osflash.signals.Signal")]
		public var unsuccessJoined:Signal;
		
		[Mock(type = "org.bigbluebutton.model.UserList")]
		public var userList:UserList;
		
		[Mock(type = "org.bigbluebutton.model.UserList")]
		public var guestList:UserList;
		
		[Mock(type = "org.bigbluebutton.model.Config", argsList = "constructorArgs")]
		public var config:Config;
		
		public var constructorArgs:Array = [null];
		
		[Before]
		public function setUp():void {
			joinMeetingCommand = new JoinMeetingCommand();
			joinMeetingCommand.userSession = userSession;
			joinMeetingCommand.connectSignal = connectSignal;
			joinMeetingCommand.loginService = loginService;
			joinMeetingCommand.userUISession = userUISession;
			joinMeetingCommand.conferenceParameters = conferenceParameters;
			given(loginService.successJoinedSignal).willReturn(successJoinedSignal);
			given(loginService.unsuccessJoinedSignal).willReturn(unsuccessJoinedSignal);
			given(loginService.successGetConfigSignal).willReturn(successGetConfigSignal);
			given(loginService.successGetProfilesSignal).willReturn(successGetProfilesSignal);
			given(userSession.userList).willReturn(userList);
			given(userSession.guestList).willReturn(guestList);
			given(userSession.config).willReturn(config);
			given(config.application).willReturn(new Object());
			given(userUISession.unsuccessJoined).willReturn(unsuccessJoined);
		}
		
		[Test]
		public function successJoined():void {
			given(successJoinedSignal.add(any())).will(callOriginal());
			given(successJoinedSignal.dispatch(any())).will(callOriginal());
			given(successGetConfigSignal.add(any())).will(callOriginal());
			given(successGetConfigSignal.dispatch(any())).will(callOriginal());
			given(successGetProfilesSignal.add(any())).will(callOriginal());
			given(successGetProfilesSignal.dispatch(any())).will(callOriginal());
			joinMeetingCommand.execute();
			verify().that(loginService.load(any()));
			successGetConfigSignal.dispatch(config);
			verify().that(userSession.config = config);
			var videoProfiles:VideoProfileManager = new VideoProfileManager();
			successGetProfilesSignal.dispatch(videoProfiles);
			verify().that(userSession.videoProfileManager = videoProfiles);
			var userObject:Object = new Object();
			successJoinedSignal.dispatch(userObject);
			verify().that(conferenceParameters.load(userObject));
			verify().that(connectSignal.dispatch(any()));
		}
		
		[Test]
		public function unsuccessJoinedTest():void {
			given(unsuccessJoinedSignal.add(any())).will(callOriginal());
			given(unsuccessJoinedSignal.dispatch(any())).will(callOriginal());
			joinMeetingCommand.execute();
			unsuccessJoinedSignal.dispatch("joining failed");
			verify().that(unsuccessJoined.dispatch("joining failed"));
		}
	}
}
