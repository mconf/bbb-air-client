package org.bigbluebutton.command {
	
	import org.bigbluebutton.core.IBigBlueButtonConnection;
	import org.bigbluebutton.core.IChatMessageService;
	import org.bigbluebutton.core.IDeskshareConnection;
	import org.bigbluebutton.core.IPresentationService;
	import org.bigbluebutton.core.IUsersService;
	import org.bigbluebutton.core.IVideoConnection;
	import org.bigbluebutton.core.IVoiceConnection;
	import org.bigbluebutton.core.SaveData;
	import org.bigbluebutton.core.UsersService;
	import org.bigbluebutton.model.Config;
	import org.bigbluebutton.model.IConferenceParameters;
	import org.bigbluebutton.model.IUserSession;
	import org.bigbluebutton.model.IUserUISession;
	import org.bigbluebutton.model.UserList;
	import org.bigbluebutton.model.UserSession;
	import org.bigbluebutton.view.navigation.pages.PagesENUM;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.rules.IMethodRule;
	import org.mockito.integrations.any;
	import org.mockito.integrations.callOriginal;
	import org.mockito.integrations.flexunit4.MockitoRule;
	import org.mockito.integrations.given;
	import org.mockito.integrations.verify;
	import org.osflash.signals.Signal;
	
	public class ConnectCommandTest {
		
		[Rule]
		public var mockitoRule:IMethodRule = new MockitoRule();
		
		private var connectCommand:ConnectCommand;
		
		[Mock(type = "org.bigbluebutton.core.UsersService")]
		public var usersService:UsersService;
		
		[Mock(type = "org.bigbluebutton.model.IUserSession")]
		public var userSession:IUserSession;
		
		[Mock(type = "org.bigbluebutton.model.IUserUISession")]
		public var userUISession:IUserUISession;
		
		[Mock(type = "org.bigbluebutton.model.IConferenceParameters")]
		public var conferenceParameters:IConferenceParameters;
		
		[Mock(type = "org.bigbluebutton.core.IBigBlueButtonConnection")]
		public var connection:IBigBlueButtonConnection;
		
		[Mock(type = "org.bigbluebutton.core.IVideoConnection")]
		public var videoConnection:IVideoConnection;
		
		[Mock(type = "org.bigbluebutton.core.IVoiceConnection")]
		public var voiceConnection:IVoiceConnection;
		
		[Mock(type = "org.bigbluebutton.core.IDeskshareConnection")]
		public var deskshareConnection:IDeskshareConnection;
		
		[Mock(type = "org.bigbluebutton.core.IChatMessageService")]
		public var chatService:IChatMessageService;
		
		[Mock(type = "org.bigbluebutton.core.IPresentationService")]
		public var presentationService:IPresentationService;
		
		[Mock(type = "org.bigbluebutton.command.DisconnectUserSignal")]
		public var disconnectUserSignal:DisconnectUserSignal;
		
		[Mock(type = "org.bigbluebutton.command.ShareMicrophoneSignal")]
		public var shareMicrophoneSignal:ShareMicrophoneSignal;
		
		[Mock(type = "org.bigbluebutton.command.ShareCameraSignal")]
		public var shareCameraSignal:ShareCameraSignal;
		
		[Mock(type = "org.bigbluebutton.model.Config", argsList = "constructorArgs")]
		public var config:Config;
		
		[Mock(type = "org.osflash.signals.Signal")]
		public var successConnected:Signal;
		
		[Mock(type = "org.osflash.signals.Signal")]
		public var videoSuccessConnected:Signal;
		
		[Mock(type = "org.osflash.signals.Signal")]
		public var unsuccessConnected:Signal;
		
		[Mock(type = "org.osflash.signals.Signal")]
		public var videoUnsuccessConnected:Signal;
		
		[Mock(type = "org.osflash.signals.Signal")]
		public var unsuccessJoined:Signal;
		
		[Mock(type = "org.osflash.signals.Signal")]
		public var authTokenSignal:Signal;
		
		[Mock(type = "org.bigbluebutton.core.SaveData")]
		public var saveData:SaveData;
		
		[Mock(type = "org.bigbluebutton.model.UserList")]
		public var userList:UserList;
		
		[Mock(type = "org.osflash.signals.Signal")]
		public var allUsersAddedSignal:Signal;
		
		[Mock(type = "org.osflash.signals.Signal")]
		public var successJoiningMeetingSignal:Signal;
		
		[Mock(type = "org.osflash.signals.Signal")]
		public var unsuccessJoiningMeetingSignal:Signal;
		
		[Mock(type = "org.osflash.signals.Signal")]
		public var guestPolicySignal:Signal;
		
		[Mock(type = "org.osflash.signals.Signal")]
		public var guestEntranceSignal:Signal;
		
		public var constructorArgs:Array = [null];
		
		[Before]
		public function setUp():void {
			connectCommand = new ConnectCommand();
			connectCommand.chatService = chatService;
			connectCommand.conferenceParameters = conferenceParameters;
			connectCommand.connection = connection;
			connectCommand.deskshareConnection = deskshareConnection;
			connectCommand.disconnectUserSignal = disconnectUserSignal;
			connectCommand.presentationService = presentationService;
			connectCommand.shareCameraSignal = shareCameraSignal;
			connectCommand.shareMicrophoneSignal = shareMicrophoneSignal;
			connectCommand.userSession = userSession;
			connectCommand.userUISession = userUISession;
			connectCommand.usersService = usersService;
			connectCommand.videoConnection = videoConnection;
			connectCommand.voiceConnection = voiceConnection;
			connectCommand.saveData = saveData;
			given(connection.successConnected).willReturn(successConnected);
			given(videoConnection.successConnected).willReturn(videoSuccessConnected);
			given(videoConnection.unsuccessConnected).willReturn(videoUnsuccessConnected);
			given(connection.unsuccessConnected).willReturn(unsuccessConnected);
			given(userSession.authTokenSignal).willReturn(authTokenSignal);
			given(userUISession.unsuccessJoined).willReturn(unsuccessJoined);
			given(userSession.config).willReturn(config);
			given(userSession.userList).willReturn(userList);
			given(userSession.successJoiningMeetingSignal).willReturn(successJoiningMeetingSignal);
			given(userSession.unsuccessJoiningMeetingSignal).willReturn(unsuccessJoiningMeetingSignal);
			given(userList.allUsersAddedSignal).willReturn(allUsersAddedSignal);
			given(config.getConfigFor("PhoneModule")).willReturn(new XML('<module name="PhoneModule" url="http://143.54.10.103/client/PhoneModule.swf?v=28" uri="rtmp://143.54.10.103/sip" autoJoin="true" listenOnlyMode="true" forceListenOnly="false" presenterShareOnly="false" skipCheck="false" showButton="true" enabledEchoCancel="true" useWebRTCIfAvailable="true" showPhoneOption="false" showMicrophoneHint="true" echoTestApp="9196" dependsOn="UsersModule"/>'));
			given(config.getConfigFor("VideoconfModule")).willReturn(new XML());
			given(config.getConfigFor("DeskShareModule")).willReturn(new XML());
			given(userSession.guestPolicySignal).willReturn(guestPolicySignal);
			given(userSession.guestEntranceSignal).willReturn(guestEntranceSignal);
		}
		
		[Test]
		public function connect():void {
			connectCommand.execute();
			verify().that(successConnected.add(any()));
			verify().that(unsuccessConnected.add(any()));
			verify().that(connection.connect(conferenceParameters));
			verify().that(userSession.phoneAutoJoin = true);
			verify().that(userSession.phoneSkipCheck = false);
			verify().that(userSession.videoAutoStart = false);
			verify().that(userSession.skipCamSettingsCheck = false);
		}
		
		[Test]
		public function unsuccessConnect():void {
			given(unsuccessConnected.add(any())).will(callOriginal());
			given(unsuccessConnected.dispatch(any())).will(callOriginal());
			connectCommand.execute();
			unsuccessConnected.dispatch("problems");
			verify().that(userUISession.loading = false);
			verify().that(unsuccessJoined.dispatch("connectionFailed"));
			verify().that(successConnected.remove(any()));
			verify().that(unsuccessConnected.remove(any()));
		}
		
		[Test]
		public function successConnect():void {
			setConnectionMocks();
			connectCommand.execute();
			successConnected.dispatch();
			authTokenSignal.dispatch(true);
			verifyConnections();
		}
		
		[Test]
		public function successGuestConnect():void {
			setConnectionMocks();
			given(conferenceParameters.isGuestDefined()).willReturn(true);
			given(conferenceParameters.guest).willReturn(true);
			connectCommand.execute();
			successConnected.dispatch();
			authTokenSignal.dispatch(true);
			verify().that(userUISession.pushPage(PagesENUM.GUEST));
			guestPolicySignal.dispatch(UserSession.GUEST_POLICY_ASK_MODERATOR);
			guestEntranceSignal.dispatch(true);
			verifyConnections();
		}
		
		private function setConnectionMocks():void {
			given(successConnected.add(any())).will(callOriginal());
			given(successConnected.dispatch()).will(callOriginal());
			given(authTokenSignal.add(any())).will(callOriginal());
			given(authTokenSignal.dispatch(any())).will(callOriginal());
			given(allUsersAddedSignal.add(any())).will(callOriginal());
			given(allUsersAddedSignal.dispatch()).will(callOriginal());
			given(videoSuccessConnected.add(any())).will(callOriginal());
			given(videoSuccessConnected.dispatch()).will(callOriginal());
			given(guestEntranceSignal.add(any())).will(callOriginal());
			given(guestEntranceSignal.dispatch(any())).will(callOriginal());
			given(guestPolicySignal.add(any())).will(callOriginal());
			given(guestPolicySignal.dispatch(any())).will(callOriginal());
		}
		
		private function verifyConnections():void {
			verify().that(chatService.setupMessageSenderReceiver());
			verify().that(presentationService.setupMessageSenderReceiver());
			verify().that(videoConnection.connect());
			verify().that(deskshareConnection.connect());
			verify().that(chatService.sendWelcomeMessage());
			verify().that(chatService.getPublicChatMessages());
			verify().that(presentationService.getPresentationInfo());
			verify().that(usersService.queryForParticipants());
			verify().that(usersService.queryForRecordingStatus());
			allUsersAddedSignal.dispatch();
			videoSuccessConnected.dispatch();
			verify().that(userUISession.pushPage(PagesENUM.PARTICIPANTS));
			verify().that(allUsersAddedSignal.remove(any()));
		}
	}
}
