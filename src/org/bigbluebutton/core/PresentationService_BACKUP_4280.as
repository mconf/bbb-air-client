package org.bigbluebutton.core
{
	import org.bigbluebutton.model.IConferenceParameters;
	import org.bigbluebutton.model.IMessageListener;
	import org.bigbluebutton.model.IUserSession;

	public class PresentationService implements IPresentationService
	{
		[Inject]
<<<<<<< HEAD
=======
		public var presentServiceSO : IPresentServiceSO;
		
		[Inject]
>>>>>>> a111425... The cursor now shows in the presentation area
		public var conferenceParameters: IConferenceParameters;
		
		[Inject]
		public var userSession: IUserSession;
		
<<<<<<< HEAD
		public var presentMessageSender:PresentMessageSender;
		public var presentMessageReceiver:PresentMessageReceiver;
		
		public function PresentationService() {
			presentMessageSender = new PresentMessageSender;
			presentMessageReceiver = new PresentMessageReceiver;
		}
		
		public function setupMessageSenderReceiver():void {
			presentMessageSender.userSession = userSession;
			presentMessageReceiver.userSession = userSession;
			userSession.mainConnection.addMessageListener(presentMessageReceiver as IMessageListener);
		}
		
		public function getPresentationInfo():void {
			presentMessageSender.getPresentationInfo();
		}

		public function gotoSlide(id:String):void {
			presentMessageSender.gotoSlide(id);
		}
		
		public function move(xOffset:Number, yOffset:Number, widthRatio:Number, heightRatio:Number):void {
			presentMessageSender.move(xOffset, yOffset, widthRatio, heightRatio);
		}
		
		public function removePresentation(name:String):void {
			presentMessageSender.removePresentation(name);
		}
		
		public function sendCursorUpdate(xPercent:Number, yPercent:Number):void {
			presentMessageSender.sendCursorUpdate(xPercent, yPercent);
		}
		
		public function sharePresentation(share:Boolean, presentationName:String):void {
			presentMessageSender.sharePresentation(share, presentationName);
=======
		private var _presentMessageReceiver:PresentMessageReceiver;
		
		public function PresentationService()
		{
		}
		
		public function connectPresent(uri:String):void {
			presentServiceSO.connect(userSession.mainConnection.connection, uri, conferenceParameters);
			_presentMessageReceiver = new PresentMessageReceiver(userSession);
			userSession.mainConnection.addMessageListener(_presentMessageReceiver as IMessageListener);
		}
		
		public function disconnect():void {
			presentServiceSO.disconnect();
			userSession.mainConnection.removeMessageListener(_presentMessageReceiver as IMessageListener);
>>>>>>> a111425... The cursor now shows in the presentation area
		}
	}
}