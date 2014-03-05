package org.bigbluebutton.command
{
	import org.bigbluebutton.core.IBigBlueButtonConnection;
	import org.bigbluebutton.core.IChatMessageService;
	import org.bigbluebutton.core.IUsersService;
	import org.bigbluebutton.core.IVideoConnection;
	import org.bigbluebutton.model.IConferenceParameters;
	import org.bigbluebutton.model.IUserSession;
	import org.bigbluebutton.model.IUserUISession;
	import org.bigbluebutton.view.navigation.pages.PagesENUM;
	import org.osmf.logging.Log;
	
	import robotlegs.bender.bundles.mvcs.Command;
	
	public class ConnectVideoCommand extends Command
	{		
		[Inject]
		public var userSession: IUserSession;
		
		[Inject]
		public var userUISession: IUserUISession;
		
		[Inject]
		public var conferenceParameters: IConferenceParameters;
		
		[Inject]
		public var joinVoiceSignal: JoinVoiceSignal;
		
		[Inject]
		public var videoConnection: IVideoConnection;
		
		override public function execute():void {
			videoConnection.uri = userSession.config.getConfigFor("VideoConfModule").@uri + "/" + conferenceParameters.room;
			
			//TODO use proper callbacks
			//TODO see if videoConnection.successConnected is dispatched when it's connected properly
			videoConnection.successConnected.add(successConnected)
			videoConnection.unsuccessConnected.add(unsuccessConnected)

			videoConnection.connect();
		}

		private function successConnected():void {
			Log.getLogger("org.bigbluebutton").info(String(this) + ":successConnected()");
			
			userSession.videoConnection = videoConnection;
			
			joinVoiceSignal.dispatch();
		}
		
		private function unsuccessConnected(reason:String):void {
			Log.getLogger("org.bigbluebutton").info(String(this) + ":unsuccessConnected()");
			
			userUISession.loading = false;
			userUISession.unsuccessJoined.dispatch("connectionFailed");
		}
	}
}