package org.bigbluebutton.command {
	
	import flash.net.NetConnection;
	import org.bigbluebutton.core.IVoiceConnection;
	import org.bigbluebutton.core.VoiceStreamManager;
	import org.bigbluebutton.model.UserSession;
	import org.flexunit.rules.IMethodRule;
	import org.mockito.integrations.any;
	import org.mockito.integrations.callOriginal;
	import org.mockito.integrations.flexunit4.MockitoRule;
	import org.mockito.integrations.given;
	import org.mockito.integrations.verify;
	import org.osflash.signals.Signal;
	
	public class ShareMicrophoneCommandTest {
		
		[Rule]
		public var mockitoRule:IMethodRule = new MockitoRule();
		
		private var shareMicrophoneCommand:ShareMicrophoneCommand;
		
		[Mock(type = "org.bigbluebutton.model.UserSession")]
		public var userSession:UserSession;
		
		[Mock(type = "org.bigbluebutton.core.IVoiceConnection")]
		public var voiceConnection:IVoiceConnection;
		
		[Mock(type = "flash.net.NetConnection")]
		public var connection:NetConnection;
		
		[Mock(type = "org.osflash.signals.Signal")]
		public var successConnected:Signal;
		
		[Mock(type = "org.osflash.signals.Signal")]
		public var unsuccessConnected:Signal;
		
		[Mock(type = "org.bigbluebutton.core.VoiceStreamManager")]
		public var voiceStreamManager:VoiceStreamManager;
		
		[Mock(type = "org.bigbluebutton.core.VoiceStreamManager")]
		public var localVoiceStreamManager:VoiceStreamManager;
		
		[Before]
		public function setUp():void {
			shareMicrophoneCommand = new ShareMicrophoneCommand();
			shareMicrophoneCommand.userSession = userSession;
			given(userSession.voiceConnection).willReturn(voiceConnection);
			given(voiceConnection.connection).willReturn(connection);
			given(voiceConnection.successConnected).willReturn(successConnected);
			given(voiceConnection.unsuccessConnected).willReturn(unsuccessConnected);
			given(userSession.voiceStreamManager).willReturn(voiceStreamManager);
		}
		
		[Test]
		public function enableAudioNotConnected():void {
			var audioOptions:Object = new Object();
			audioOptions.shareMic = true;
			audioOptions.listenOnly = true;
			shareMicrophoneCommand.audioOptions = audioOptions;
			shareMicrophoneCommand.execute();
			verify().that(voiceConnection.connect(any(), any()));
			verify().that(successConnected.add(any()));
			verify().that(unsuccessConnected.add(any()));
		}
		
		[Test]
		public function enableAudioConnected():void {
			given(connection.connected).willReturn(true);
			var audioOptions:Object = new Object();
			audioOptions.shareMic = true;
			audioOptions.listenOnly = true;
			shareMicrophoneCommand.audioOptions = audioOptions;
			shareMicrophoneCommand.execute();
			verify().that(voiceConnection.call(audioOptions.listenOnly));
			verify().that(successConnected.add(any()));
			verify().that(unsuccessConnected.add(any()));
		}
		
		[Test]
		public function disableAudio():void {
			var audioOptions:Object = new Object();
			audioOptions.shareMic = false;
			audioOptions.listenOnly = false;
			shareMicrophoneCommand.audioOptions = audioOptions;
			shareMicrophoneCommand.execute();
			verify().that(voiceStreamManager.close());
			verify().that(voiceConnection.hangUp());
		}
		
		[Test]
		public function mediaSuccessConnected():void {
			given(connection.connect(any())).will(callOriginal());
			given(successConnected.add(any())).will(callOriginal());
			given(successConnected.dispatch(any(), any(), any(), any())).will(callOriginal());
			var audioOptions:Object = new Object();
			audioOptions.shareMic = true;
			audioOptions.listenOnly = false;
			shareMicrophoneCommand.audioOptions = audioOptions;
			shareMicrophoneCommand.execute();
			voiceConnection.successConnected.dispatch("publish name", "play name", "codec", voiceStreamManager);
			verify().that(voiceStreamManager.play(connection, "play name"));
			verify().that(voiceStreamManager.publish(connection, "publish name", "codec", true));
			verify().that(successConnected.remove(any()));
			verify().that(unsuccessConnected.remove(any()));
		}
		
		[Test]
		public function mediaUnsuccessConnected():void {
			given(unsuccessConnected.add(any())).will(callOriginal());
			given(unsuccessConnected.dispatch(any())).will(callOriginal());
			var audioOptions:Object = new Object();
			audioOptions.shareMic = true;
			audioOptions.listenOnly = false;
			shareMicrophoneCommand.audioOptions = audioOptions;
			shareMicrophoneCommand.execute();
			voiceConnection.unsuccessConnected.dispatch("connection failed because of reasons");
			verify().that(successConnected.remove(any()));
			verify().that(unsuccessConnected.remove(any()));
		}
	}
}
