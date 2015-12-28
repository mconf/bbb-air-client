package org.bigbluebutton.command {
	
	import org.bigbluebutton.model.IUserUISession;
	import org.bigbluebutton.model.UserUISession;
	import org.flexunit.rules.IMethodRule;
	import org.mockito.integrations.flexunit4.MockitoRule;
	import org.mockito.integrations.given;
	import org.mockito.integrations.verify;
	import org.osflash.signals.Signal;
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.bundles.mvcs.MVCSBundle;
	import robotlegs.bender.extensions.signalCommandMap.impl.SignalCommandMap;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IInjector;
	import robotlegs.bender.framework.impl.Context;
	
	public class AuthenticationCommandTest {
		
		[Rule]
		public var mockitoRule:IMethodRule = new MockitoRule();
		
		private var authenticationCommand:AuthenticationCommand;
		
		[Mock(type = "org.bigbluebutton.model.IUserUISession")]
		public var userUISession:IUserUISession;
		
		[Mock(type = "org.osflash.signals.Signal")]
		public var unsuccesJoined:Signal;
		
		[Before]
		public function setUp():void {
			authenticationCommand = new AuthenticationCommand();
			authenticationCommand.userUISession = userUISession;
			given(userUISession.unsuccessJoined).willReturn(unsuccesJoined);
		}
		
		[Test]
		public function timeOut():void {
			authenticationCommand.command = "timeOut";
			authenticationCommand.execute();
			verify().that(unsuccesJoined.dispatch("authTokenTimedOut"));
		}
		
		[Test]
		public function invalid():void {
			authenticationCommand.command = "invalid";
			authenticationCommand.execute();
			verify().that(unsuccesJoined.dispatch("authTokenInvalid"));
		}
	}
}
