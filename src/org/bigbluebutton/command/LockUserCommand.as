package org.bigbluebutton.command {
	
	import org.bigbluebutton.core.IUsersService;
	import org.bigbluebutton.model.IUserSession;
	import robotlegs.bender.bundles.mvcs.Command;
	
	public class LockUserCommand extends Command {
		
		[Inject]
		public var userSession:IUserSession;
		
		[Inject]
		public var userService:IUsersService;
		
		[Inject]
		public var userID:String;
		
		[Inject]
		public var lock:Boolean;
		
		override public function execute():void {
			userService.setUserLock(userID, lock);
		}
	}
}
