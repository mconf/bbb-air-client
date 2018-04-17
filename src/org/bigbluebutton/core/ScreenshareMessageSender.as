package org.bigbluebutton.core {
	
	import flash.net.NetConnection;
	
	import org.bigbluebutton.model.IUserSession;
	import org.bigbluebutton.model.chat.ChatMessageVO;
	import org.bigbluebutton.model.chat.IChatMessagesSession;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	public class ScreenshareMessageSender {
		public var userSession:IUserSession;
		
		private var successSendMessageSignal:ISignal;
		
		private var failureSendingMessageSignal:ISignal;
		
		public function ScreenshareMessageSender(userSession:IUserSession, successSendMessageSignal:ISignal, failureSendingMessageSignal:ISignal) {
			this.userSession = userSession;
			this.successSendMessageSignal = successSendMessageSignal;
			this.failureSendingMessageSignal = failureSendingMessageSignal;
		}
		
		public function sendPong(meetingId:String, session:String, timestamp: Number):void {
            var message:Object = new Object();
            message["meetingId"] = meetingId;
            message["session"] = session;
            message["timestamp"] = timestamp;
            
			userSession.deskshareConnection.sendMessage("screenshare.screenShareClientPongMessage", function(result:String):void { // On successful result
                trace(result);
            }, function(status:String):void { // status - On error occurred
                trace(status);
            }, message);
		}
		
		public function sendIsSharingScreen():void {			
			userSession.deskshareConnection.sendMessage("screenshare.isScreenSharing", function(result:String):void { // On successful result
				trace(result);
			}, function(status:String):void { // status - On error occurred
				trace(status);
			}, null);
		}
		
		public function sendSetUserId(userId:String):void {
			var message:Object = new Object();
			message["userId"] = userId;
			
			userSession.deskshareConnection.sendMessage("screenshare.setUserId", function(result:String):void { // On successful result
				trace(result);
				sendIsSharingScreen();
			}, function(status:String):void { // status - On error occurred
				trace(status);
			}, message);
		}
	}
}
