package org.bigbluebutton.view.navigation.pages.login.rooms
{
	import org.bigbluebutton.model.User;

	public class Room
	{
		public var url:String;
		public var name:String;
		public function Room(url:String, name:String)
		{
			this.url = url;
			this.name = name;
		}
	}
}