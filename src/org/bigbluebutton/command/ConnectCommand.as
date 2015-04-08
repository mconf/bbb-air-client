package org.bigbluebutton.command
{
	import flash.media.Camera;
	
	import mx.core.FlexGlobals;
	import mx.messaging.management.Attribute;
	import mx.utils.ObjectUtil;
	
	import org.bigbluebutton.command.DisconnectUserSignal;
	import org.bigbluebutton.core.IBigBlueButtonConnection;
	import org.bigbluebutton.core.IChatMessageService;
	import org.bigbluebutton.core.IDeskshareConnection;
	import org.bigbluebutton.core.IPresentationService;
	import org.bigbluebutton.core.IUsersService;
	import org.bigbluebutton.core.IVideoConnection;
	import org.bigbluebutton.core.IVoiceConnection;
	import org.bigbluebutton.model.IConferenceParameters;
	import org.bigbluebutton.model.IUserSession;
	import org.bigbluebutton.model.IUserUISession;
	import org.bigbluebutton.model.UserSession;
	import org.bigbluebutton.view.navigation.pages.PagesENUM;
	import org.bigbluebutton.view.navigation.pages.disconnect.enum.DisconnectEnum;
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
		public var videoConnection: IVideoConnection;
		
		[Inject]
		public var voiceConnection: IVoiceConnection;
		
		[Inject]
		public var deskshareConnection : IDeskshareConnection;
		
		[Inject]
		public var uri: String;
		
		[Inject]
		public var usersService: IUsersService;
		
		[Inject]
		public var chatService: IChatMessageService;
		
		[Inject]
		public var presentationService: IPresentationService;
		
		[Inject]
		public var disconnectUserSignal: DisconnectUserSignal;
		
		[Inject]
		public var shareMicrophoneSignal: ShareMicrophoneSignal;
		
		[Inject]
		public var shareCameraSignal: ShareCameraSignal;
		
		override public function execute():void {
			loadConfigOptions();
			connection.uri = uri;
			
			connection.successConnected.add(successConnected);
			connection.unsuccessConnected.add(unsuccessConnected);
			connection.connect(conferenceParameters);
		}
		
		private function successConnected():void {			
			Log.getLogger("org.bigbluebutton").info(String(this) + ":successConnected()");
			
			userSession.mainConnection = connection;
			userSession.userId = connection.userId;
			
			// Set up users message sender in order to send the "joinMeeting" message:
			usersService.setupMessageSenderReceiver();
			
			userSession.authTokenSignal.add(onAuthTokenReply);
			usersService.validateToken();
		}
		
		private function onAuthTokenReply(tokenValid:Boolean):void {
			Log.getLogger("org.bigbluebutton").info(String(this) + ":onAuthTokenReply() tokenValid=" + tokenValid);
			if (tokenValid) {
				if (conferenceParameters.isGuestDefined() && conferenceParameters.guest) {
					userSession.guestPolicySignal.add(onGuestPolicyResponse);
					usersService.getGuestPolicy();
					userUISession.pushPage(PagesENUM.GUEST);
					userUISession.loading = false;
				} else {
					connectAfterGuest();
				}
			} else {
				// TODO disconnect
			}
		}
		
		private function onGuestAllowed():void {
			connectAfterGuest();
		}
		
		private function onGuestDenied():void {
			userUISession.loading = false;
			disconnectUserSignal.dispatch(DisconnectEnum.CONNECTION_STATUS_MODERATOR_DENIED);
		}
		
		private function onGuestPolicyResponse(policy:String):void {
			Log.getLogger("org.bigbluebutton").info(String(this) + ":onGuestPolicyResponse() policy=" + policy);
			if (policy == UserSession.GUEST_POLICY_ALWAYS_ACCEPT) {
				onGuestAllowed();
			} else if (policy == UserSession.GUEST_POLICY_ALWAYS_DENY) {
				onGuestDenied();
			} else if (policy == UserSession.GUEST_POLICY_ASK_MODERATOR) {
				userSession.guestEntranceSignal.add(onGuestEntranceResponse);
				usersService.askToEnter();
			}
		}
		
		private function onGuestEntranceResponse(allowed:Boolean):void {
			Log.getLogger("org.bigbluebutton").info(String(this) + ":onGuestEntranceResponse() allowed=" + allowed);
			if (allowed) {
				onGuestAllowed();
			} else {
				onGuestDenied();
			}
		}
		
		private function connectAfterGuest():void {
			// Send the join meeting message, then wait for the reponse
			userSession.successJoiningMeetingSignal.add(successJoiningMeeting);
			userSession.unsuccessJoiningMeetingSignal.add(unsuccessJoiningMeeting);
			
			usersService.sendJoinMeetingMessage();
			
			connection.successConnected.remove(successConnected);
			connection.unsuccessConnected.remove(unsuccessConnected);
		}
		
		private function successJoiningMeeting():void {
			// Set up remaining message sender and receivers:
			chatService.setupMessageSenderReceiver();
			presentationService.setupMessageSenderReceiver();
			
			// set up and connect the remaining connections
			videoConnection.uri = userSession.config.getConfigFor("VideoConfModule").@uri + "/" + conferenceParameters.room;
			
			//TODO see if videoConnection.successConnected is dispatched when it's connected properly
			videoConnection.successConnected.add(successVideoConnected);
			videoConnection.unsuccessConnected.add(unsuccessVideoConnected);
			
			videoConnection.connect();
			
			userSession.videoConnection = videoConnection;
			
			voiceConnection.uri = userSession.config.getConfigFor("PhoneModule").@uri;
			userSession.voiceConnection = voiceConnection;
			
			if(userSession.phoneAutoJoin && userSession.phoneSkipCheck){
				var forceListenOnly:Boolean = (userSession.config.getConfigFor("PhoneModule").@forceListenOnly.toString().toUpperCase() == "TRUE") ? true : false;
				var audioOptions:Object = new Object();
				audioOptions.shareMic = userSession.userList.me.voiceJoined = !forceListenOnly;
				audioOptions.listenOnly = userSession.userList.me.listenOnly = forceListenOnly;
				shareMicrophoneSignal.dispatch(audioOptions);
			}
			
			deskshareConnection.applicationURI = userSession.config.getConfigFor("DeskShareModule").@uri;
			deskshareConnection.room = conferenceParameters.room;
			deskshareConnection.connect();
			
			userSession.deskshareConnection = deskshareConnection;

			// Query the server for chat, users, and presentation info
			chatService.sendWelcomeMessage();
			chatService.getPublicChatMessages();
			
			presentationService.getPresentationInfo();

			userSession.userList.allUsersAddedSignal.add(successUsersAdded);
			usersService.queryForParticipants();
			usersService.queryForRecordingStatus();
			
			userSession.successJoiningMeetingSignal.remove(successJoiningMeeting);
			userSession.unsuccessJoiningMeetingSignal.remove(unsuccessJoiningMeeting);
			usersService.getRoomLockState();
		}
		
		private function unsuccessJoiningMeeting():void {
			trace("ConnectCommand::unsuccessJoiningMeeting() -- Failed to join the meeting!!!");
			
			userSession.successJoiningMeetingSignal.remove(successJoiningMeeting);
			userSession.unsuccessJoiningMeetingSignal.remove(unsuccessJoiningMeeting);
		}
		
		private function successUsersAdded():void
		{
			// remove guest page (if it is there)
			userUISession.popPage();
			FlexGlobals.topLevelApplication.topActionBar.visible = true;
			FlexGlobals.topLevelApplication.bottomMenu.visible = true;
			
			userUISession.loading = false;
			userUISession.pushPage(PagesENUM.PARTICIPANTS);
			
			if(userSession.phoneAutoJoin && !userSession.phoneSkipCheck){
				userUISession.pushPage(PagesENUM.AUDIOSETTINGS);
			}
			if(userSession.videoAutoStart && !userSession.skipCamSettingsCheck ){
				userUISession.pushPage(PagesENUM.CAMERASETTINGS);
			}
			
			userSession.userList.allUsersAddedSignal.remove(successUsersAdded);
		}
		
		private function loadConfigOptions():void{
			userSession.phoneAutoJoin = (userSession.config.getConfigFor("PhoneModule").@autoJoin.toString().toUpperCase() == "TRUE") ? true : false;
			userSession.phoneSkipCheck = (userSession.config.getConfigFor("PhoneModule").@skipCheck.toString().toUpperCase() == "TRUE") ? true : false;
			userSession.videoAutoStart = (userSession.config.getConfigFor("VideoconfModule").@autoStart.toString().toUpperCase() == "TRUE") ? true : false;
			userSession.skipCamSettingsCheck = (userSession.config.getConfigFor("VideoconfModule").@skipCamSettingsCheck.toString().toUpperCase() == "TRUE") ? true : false;
		}
		
		private function unsuccessConnected(reason:String):void {
			Log.getLogger("org.bigbluebutton").info(String(this) + ":unsuccessConnected()");
			
			userUISession.loading = false;
			userUISession.unsuccessJoined.dispatch("connectionFailed");
			
			connection.successConnected.remove(successConnected);
			connection.unsuccessConnected.remove(unsuccessConnected);
		}
		
		private function successVideoConnected():void {
			Log.getLogger("org.bigbluebutton").info(String(this) + ":successVideoConnected()");
			
			if(userSession.videoAutoStart && userSession.skipCamSettingsCheck){
				shareCameraSignal.dispatch(!userSession.userList.me.hasStream, userSession.videoConnection.cameraPosition);
			}
			
			videoConnection.successConnected.remove(successVideoConnected);
			videoConnection.unsuccessConnected.remove(unsuccessVideoConnected);
		}
		
		private function unsuccessVideoConnected(reason:String):void {
			Log.getLogger("org.bigbluebutton").info(String(this) + ":unsuccessVideoConnected()");
			
			videoConnection.unsuccessConnected.remove(unsuccessVideoConnected);
			videoConnection.successConnected.remove(successVideoConnected);
		}
	}
}