package org.bigbluebutton.core {
	
	import org.bigbluebutton.model.IConferenceParameters;
	import org.bigbluebutton.model.IMessageListener;
	import org.bigbluebutton.model.IUserSession;
	import org.bigbluebutton.model.User;
	import org.bigbluebutton.model.chat.ChatMessageVO;
	import org.bigbluebutton.model.chat.IChatMessagesSession;
	import org.flexunit.internals.namespaces.classInternal;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	public class ScreenshareService implements IScreenshareService {
		
		[Inject]
		public var userSession:IUserSession;
		
		[Inject]
		public var conferenceParameters:IConferenceParameters;
		
		public var messageSender:ScreenshareMessageSender;
		
		public var messageReceiver:ScreenshareMessageReceiver;
		
		private var _sendMessageOnSuccessSignal:ISignal = new Signal();
		
		private var _sendMessageOnFailureSignal:ISignal = new Signal();
		
		public function get sendMessageOnSuccessSignal():ISignal {
			return _sendMessageOnSuccessSignal;
		}
		
		public function get sendMessageOnFailureSignal():ISignal {
			return _sendMessageOnFailureSignal;
		}
		
		public function ScreenshareService() {
		}
		
		public function setupMessageSenderReceiver():void {
			messageSender = new ScreenshareMessageSender(userSession, _sendMessageOnSuccessSignal, _sendMessageOnFailureSignal);
			messageReceiver = new ScreenshareMessageReceiver(userSession);
			userSession.deskshareConnection.addMessageListener(messageReceiver as IMessageListener);
			sendSetUserId();
		}
		
		public function sendPong(session:String, timestamp: Number):void {
			messageSender.sendPong(conferenceParameters.meetingID, session, timestamp);
		}

		public function sendSetUserId():void {
			messageSender.sendSetUserId(conferenceParameters.internalUserID);
		}
	}
}
