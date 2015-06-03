package org.bigbluebutton.model {
	
	import flash.events.Event;
	import org.bigbluebutton.core.IUsersService;
	
	public class Guest {
		
		[Inject]
		public var userService:IUsersService;
		
		public static const UNKNOWN_USER:String = "UNKNOWN USER";
		
		private var _userID:String = UNKNOWN_USER;
		
		public function get userID():String {
			return _userID;
		}
		
		public function set userID(value:String):void {
			_userID = value;
		}
		
		private var _name:String;
		
		public function get name():String {
			return _name;
		}
		
		public function set name(value:String):void {
			_name = value;
		}
	}
}
