package org.bigbluebutton.command
{
	import org.bigbluebutton.core.IBigBlueButtonConnection;
	import org.bigbluebutton.core.IChatMessageService;
	import org.bigbluebutton.core.IPresentationService;
	import org.bigbluebutton.core.IUsersService;
	import org.bigbluebutton.model.IConferenceParameters;
	import org.bigbluebutton.model.IUserSession;
	import org.bigbluebutton.model.IUserUISession;
	import org.osmf.logging.Log;
	
	import robotlegs.bender.bundles.mvcs.Command;
	
	public class ConnectCommand extends Command
	{		
		[Inject]
		public var userSession: IUserSession;
		
		[Inject]
		public var userUISession: IUserUISession;
		
		[Inject]
		public var conferenceParameters: IConferenceParameters;
		
		[Inject]
		public var connection: IBigBlueButtonConnection;
		
		[Inject]
		public var connectVideoSignal: ConnectVideoSignal;
		
		[Inject]
		public var uri: String;
		
		[Inject]
		public var usersService: IUsersService;
		
		[Inject]
		public var chatService: IChatMessageService;

		[Inject]
		public var presentationService: IPresentationService;

		override public function execute():void {
			connection.uri = uri;
			
			connection.successConnected.add(successConnected)
			connection.unsuccessConnected.add(unsuccessConnected)

			connection.connect(conferenceParameters);
		}

		private function successConnected():void {
			Log.getLogger("org.bigbluebutton").info(String(this) + ":successConnected()");
			
			userSession.mainConnection = connection;
			userSession.userId = connection.userId;
			
			usersService.connectUsers(uri);
			
			if (conferenceParameters.isGuestDefined() && conferenceParameters.guest) {
				// I'm a guest, let's ask to enter
				userSession.guestSignal.add(onGuestResponse);
			} else {
				connectAfterGuest();
			}
		}
		
		private function onGuestResponse(allowed:Boolean):void {
			if (allowed) {
				Log.getLogger("org.bigbluebutton").info(String(this) + ":onGuestResponse() allowed to join");

				connectAfterGuest();
			} else {
				Log.getLogger("org.bigbluebutton").info(String(this) + ":onGuestResponse() not allowed to join");
				
				//TODO disconnect from all connections, not only the main one
				connection.unsuccessConnected.remove(unsuccessConnected);
				connection.disconnect(true);
				
				userUISession.loading = false;
				userUISession.unsuccessJoined.dispatch("accessDenied");
			}
		}
		
		private function connectAfterGuest():void {
			usersService.connectListeners(uri);
			
			chatService.getPublicChatMessages();
			
			// presentationService.connectPresent(uri);

			connectVideoSignal.dispatch();
		}
		
		private function unsuccessConnected(reason:String):void {
			Log.getLogger("org.bigbluebutton").info(String(this) + ":unsuccessConnected()");
			
			userUISession.loading = false;
			userUISession.unsuccessJoined.dispatch("connectionFailed");
		}
	}
}