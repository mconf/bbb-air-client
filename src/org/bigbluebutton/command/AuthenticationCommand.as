package org.bigbluebutton.command {
	
	import org.bigbluebutton.model.IUserSession;
	import org.bigbluebutton.model.IUserUISession;
	import robotlegs.bender.bundles.mvcs.Command;
	
	public class AuthenticationCommand extends Command {
		
		[Inject]
		public var command:String;
		
		[Inject]
		public var userUISession:IUserUISession;
		
		[Inject]
		public var userSession:IUserSession;
		
		public function AuthenticationCommand() {
			super();
		}
		
		override public function execute():void {
			userUISession.loading = false;
			switch (command) {
				case "timeOut":
					userUISession.unsuccessJoined.dispatch("authTokenTimedOut");
					break;
				case "invalid":
					userUISession.unsuccessJoined.dispatch("authTokenInvalid");
					break;
			}
		}
	}
}
