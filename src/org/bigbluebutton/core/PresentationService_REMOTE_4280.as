package org.bigbluebutton.core
{
	import org.bigbluebutton.model.IConferenceParameters;
	import org.bigbluebutton.model.IMessageListener;
	import org.bigbluebutton.model.IUserSession;
	
	public class PresentationService implements IPresentationService
	{
		[Inject]
		public var presentServiceSO : IPresentServiceSO;
		
		[Inject]
		public var conferenceParameters: IConferenceParameters;
		
		[Inject]
		public var userSession: IUserSession;
		
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
		}
	}
}