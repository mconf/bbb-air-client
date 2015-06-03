package org.bigbluebutton.command {
	
	import org.bigbluebutton.core.IUsersService;
	import org.bigbluebutton.model.IUserSession;
	import robotlegs.bender.bundles.mvcs.Command;
	
	public class ChangeRoleCommand extends Command {
		
		[Inject]
		public var userSession:IUserSession;
		
		[Inject]
		public var userService:IUsersService;
		
		[Inject]
		public var roleOptions:Object;
		
		private var _userID:String;
		
		private var _role:String;
		
		override public function execute():void {
			getRoleOptions(roleOptions);
			trace("ChangeRoleCommand.execute() - change mood");
			userService.changeRole(_userID, _role);
		}
		
		private function getRoleOptions(options:Object):void {
			if (options != null && options.hasOwnProperty("userID") && options.hasOwnProperty("role")) {
				_userID = options.userID;
				_role = options.role;
			}
		}
	}
}
