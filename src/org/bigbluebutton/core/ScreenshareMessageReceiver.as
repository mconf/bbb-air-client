package org.bigbluebutton.core {
	
	import org.bigbluebutton.model.IMessageListener;
	import org.bigbluebutton.model.IUserSession;
	
	public class ScreenshareMessageReceiver implements IMessageListener {
		[Inject]
		public var userSession:IUserSession;
				
		[Inject]
		public var screenshareService:IScreenshareService;
		
		public function ScreenshareMessageReceiver(userSession:IUserSession) {
			this.userSession = userSession;
		}
		
		public function onMessage(messageName:String, message:Object):void {
			switch (messageName) {
				case "isSharingScreenRequestResponse":
					handleIsSharingScreenRequestResponse(message);
					break;
				case "screenShareStartedMessage":
					handleScreenShareStartedMessage(message);
					break;
				case "screenShareStoppedMessage":
					handleScreenShareStoppedMessage(message);
					break;  
				case "screenShareClientPingMessage":
					handleScreenShareClientPingMessage(message);
					break;
				default:
					// trace("Cannot handle message [" + messageName + "]");
			}
		}
		
		private function handleIsSharingScreenRequestResponse(message:Object):void {
			var map:Object = JSON.parse(message.msg);
			if (map.hasOwnProperty("sharing") && map.sharing) {
				if (map.hasOwnProperty("streamId") &&
						map.hasOwnProperty("width") &&
						map.hasOwnProperty("height") &&
						map.hasOwnProperty("url") &&
						map.hasOwnProperty("session")) {

					userSession.deskshareConnection.streamHeight = map.height as Number;
					userSession.deskshareConnection.streamWidth = map.width as Number;
					userSession.deskshareConnection.streamId = map.streamId;
					userSession.deskshareConnection.url = map.url;
					userSession.deskshareConnection.session = map.session;

					userSession.deskshareConnection.isStreaming = true;
				}
			}
		}

		private function handleScreenShareStartedMessage(message:Object):void {
			var map:Object = JSON.parse(message.msg);
			if (map.hasOwnProperty("streamId") &&
					map.hasOwnProperty("width") &&
					map.hasOwnProperty("height") &&
					map.hasOwnProperty("url") &&
					map.hasOwnProperty("session")) {
				
				userSession.deskshareConnection.streamHeight = map.height as Number;
				userSession.deskshareConnection.streamWidth = map.width as Number;
				userSession.deskshareConnection.streamId = map.streamId;
				userSession.deskshareConnection.url = map.url;
				userSession.deskshareConnection.session = map.session;
				
				userSession.deskshareConnection.isStreaming = true;
			}
		}
		
		private function handleScreenShareStoppedMessage(message:Object):void {
			var map:Object = JSON.parse(message.msg);
			if (map.hasOwnProperty("session") &&
					map.hasOwnProperty("reason") &&
					userSession.deskshareConnection.session == map.session) {
				userSession.deskshareConnection.isStreaming = false;
			}
		}
		
		private function handleScreenShareClientPingMessage(message:Object):void {
			var map:Object = JSON.parse(message.msg);      
			if (map.hasOwnProperty("meetingId") &&
					map.hasOwnProperty("session") &&
					map.hasOwnProperty("timestamp") &&
					userSession.deskshareConnection.session == map.session) {
				screenshareService.sendPong(map.session, map.timestamp);
			} 
		}
	}
}
