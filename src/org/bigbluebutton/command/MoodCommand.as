package org.bigbluebutton.command {
	
	import org.bigbluebutton.core.IUsersService;
	import org.bigbluebutton.model.IUserSession;
	import robotlegs.bender.bundles.mvcs.Command;
	
	public class MoodCommand extends Command {
		
		[Inject]
		public var userSession:IUserSession;
		
		[Inject]
		public var userService:IUsersService;
		
		[Inject]
		public var mood:String;
		
		override public function execute():void {
			trace("MoodCommand.execute() - change mood");
			userService.changeMood(mood);
		}
	}
}
