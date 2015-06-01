package org.bigbluebutton.view.navigation.pages.videochat {
	
	import org.bigbluebutton.model.User;
	
	public class UserStreamName {
		public var streamName:String;
		
		public var user:User;
		
		public function UserStreamName(streamName:String, user:User) {
			this.streamName = streamName;
			this.user = user;
		}
	}
}
