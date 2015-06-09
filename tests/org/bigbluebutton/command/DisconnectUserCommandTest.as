package org.bigbluebutton.command {
	
	import org.bigbluebutton.core.IBigBlueButtonConnection;
	import org.bigbluebutton.core.IDeskshareConnection;
	import org.bigbluebutton.core.IVideoConnection;
	import org.bigbluebutton.core.IVoiceConnection;
	import org.bigbluebutton.model.UserSession;
	import org.bigbluebutton.model.UserUISession;
	import org.bigbluebutton.view.navigation.pages.PagesENUM;
	import org.bigbluebutton.view.navigation.pages.disconnect.enum.DisconnectEnum;
	import org.flexunit.rules.IMethodRule;
	import org.mockito.integrations.any;
	import org.mockito.integrations.flexunit4.MockitoRule;
	import org.mockito.integrations.given;
	import org.mockito.integrations.verify;
	
	public class DisconnectUserCommandTest {
		
		[Rule]
		public var mockitoRule:IMethodRule = new MockitoRule();
		
		private var disconnectUserCommand:DisconnectUserCommand;
		
		[Mock(type = "org.bigbluebutton.model.UserSession")]
		public var userSession:UserSession;
		
		[Mock(type = "org.bigbluebutton.model.UserUISession")]
		public var userUISession:UserUISession;
		
		[Mock(type = "org.bigbluebutton.core.IVoiceConnection")]
		public var voiceConnection:IVoiceConnection;
		
		[Mock(type = "org.bigbluebutton.core.IVideoConnection")]
		public var videoConnection:IVideoConnection;
		
		[Mock(type = "org.bigbluebutton.core.IBigBlueButtonConnection")]
		public var mainConnection:IBigBlueButtonConnection;
		
		[Mock(type = "org.bigbluebutton.core.IDeskshareConnection")]
		public var deskshareConnection:IDeskshareConnection;
		
		[Before]
		public function setUp():void {
			disconnectUserCommand = new DisconnectUserCommand();
			disconnectUserCommand.userSession = userSession;
			disconnectUserCommand.userUISession = userUISession;
			given(userSession.voiceConnection).willReturn(voiceConnection);
			given(userSession.videoConnection).willReturn(videoConnection);
			given(userSession.mainConnection).willReturn(mainConnection);
			given(userSession.deskshareConnection).willReturn(deskshareConnection);
		}
		
		[Test]
		public function disconnectUser():void {
			disconnectUserCommand.disconnectionStatusCode = DisconnectEnum.CONNECTION_STATUS_USER_KICKED_OUT;
			disconnectUserCommand.execute();
			verify().that(userUISession.pushPage(PagesENUM.DISCONNECT, DisconnectEnum.CONNECTION_STATUS_USER_KICKED_OUT));
			verify().that(voiceConnection.disconnect(true));
			verify().that(videoConnection.disconnect(true));
			verify().that(mainConnection.disconnect(true));
			verify().that(deskshareConnection.disconnect(true));
		}
	}
}
