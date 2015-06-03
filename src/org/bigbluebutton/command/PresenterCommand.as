package org.bigbluebutton.command {
	
	import org.bigbluebutton.core.IUsersService;
	import org.bigbluebutton.model.IUserSession;
	import org.bigbluebutton.model.User;
	import robotlegs.bender.bundles.mvcs.Command;
	
	public class PresenterCommand extends Command {
		
		[Inject]
		public var userSession:IUserSession;
		
		[Inject]
		public var userService:IUsersService;
		
		[Inject]
		public var user:User;
		
		[Inject]
		public var userMeID:String;
		
		override public function execute():void {
			trace("PresenterCommand.execute() -assign presenter");
			userService.assignPresenter(user.userID, user.name, userMeID);
		}
	}
}
