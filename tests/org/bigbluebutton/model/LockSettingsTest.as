package org.bigbluebutton.model {
	
	import org.flexunit.rules.IMethodRule;
	import org.mockito.integrations.flexunit4.MockitoRule;
	import org.mockito.integrations.verify;
	import org.osflash.signals.Signal;
	
	public class LockSettingsTest {
		
		[Rule]
		public var mockitoRule:IMethodRule = new MockitoRule();
		
		private var lockSettings:LockSettings;
		
		[Mock(type = "org.osflash.signals.Signal")]
		private var disableCamSignal:Signal;
		
		[Mock(type = "org.osflash.signals.Signal")]
		private var disableMicSignal:Signal;
		
		[Mock(type = "org.osflash.signals.Signal")]
		private var disablePrivateChatSignal:Signal;
		
		[Mock(type = "org.osflash.signals.Signal")]
		private var disablePublicChatSignal:Signal;
		
		[Before]
		public function setUp():void {
			lockSettings = new LockSettings();
		}
		
		[Test]
		public function disableEverything():void {
			lockSettings.disableCam = true;
			lockSettings.disableMic = true;
			lockSettings.disablePublicChat = true;
			lockSettings.disablePrivateChat = true;
		}
	}
}
