package org.bigbluebutton.core
{
	import org.bigbluebutton.model.IMessageListener;
	import org.bigbluebutton.model.IUserSession;
	import org.bigbluebutton.model.User;
	import org.osflash.signals.Signal;
	
	public class UsersMessageReceiver implements IMessageListener
	{
		public var userSession: IUserSession;
		public var userService: IUsersService;
		
		public function UsersMessageReceiver() {

		}
		
		public function onMessage(messageName:String, message:Object):void {
			switch(messageName) {
				case "voiceUserTalking":
					handleVoiceUserTalking(message);
					break;
				case "participantJoined":
					handleParticipantJoined(message);
					break;
				case "participantLeft":
					handleParticipantLeft(message);
					break;
				case "userJoinedVoice":
					handleUserJoinedVoice(message);
					break;
				case "userLeftVoice":
					handleUserLeftVoice(message);
					break;
				case "userSharedWebcam":
					handleUserSharedWebcam(message);
					break;
				case "userUnsharedWebcam":
					handleUserUnsharedWebcam(message);
					break;
				case "user_listening_only":
					handleUserListeningOnly(message);
					break;
				case "assignPresenterCallback":
					handleAssignPresenterCallback(message);
					break;
				case "voiceUserMuted":
					handleVoiceUserMuted(message);
					break;
				case "recordingStatusChanged":
					handleRecordingStatusChanged(message);
					break;
				case "joinMeetingReply":
					handleJoinedMeeting(message);
					break;
				case "getUsersReply":
					handleGetUsersReply(message);
					break;
				case "getRecordingStatusReply":
					handleGetRecordingStatusReply(message);
					break;
				case "meetingHasEnded":
					handleMeetingHasEnded(message);
					break;
				case "meetingEnded":
					handleLogout(message);
					break;
				case "participantStatusChange":
					handleStatusChange(message);
					break;
				case "response_to_guest":
					handleGuestResponse(message);
					break;
				case "get_guest_policy_reply":
					handleGuestPolicy(message);
					break;
				default:
					break;
			}
		}
		
		private function handleGuestPolicy(m:Object):void {
			var msg:Object = JSON.parse(m.msg);
			trace("guestPolicy");
			switch (msg.guestPolicy){
				case "ALWAYS_DENY":
					userSession.guestSignal.dispatch(false);
					break;
				case "ALWAYS_ACCEPT":
					userSession.guestSignal.dispatch(true);
					break;
				default:
					userService.askToEnter();
					break;
			}
			
			
		}
		
		private function handleGuestResponse(m:Object):void {
			var msg:Object = JSON.parse(m.msg);
			trace("GuestResponse: "+msg);
			if (msg.userID == userSession.userId) {
				userSession.guestSignal.dispatch(msg.allowed);
			}
		}
		
		private function handleStatusChange(m:Object):void {
			var msg:Object = JSON.parse(m.msg);
			trace("UsersMessageReceiver::handleStatusChange() -- user [" +  msg.userID + "," + msg.value + "] ");	
			var value:String = msg.value;
			switch (value.substr(0, value.indexOf(","))){
				case "RAISE_HAND":
					userSession.userList.statusChange(msg.userID, User.RAISE_HAND);
					break;
				case "CLEAR_MOOD":
				case "CLEAR_STATUS":
					userSession.userList.statusChange(msg.userID, User.NO_STATUS);
					break;
				case "AGREE":
					userSession.userList.statusChange(msg.userID, User.AGREE);
					break;
				case "DISAGREE":
					userSession.userList.statusChange(msg.userID, User.DISAGREE);
					break;
				case "SAD":
					userSession.userList.statusChange(msg.userID, User.SAD);
					break;
			}

				
		}
		
		private function handleVoiceUserTalking(m:Object):void {
			var msg:Object = JSON.parse(m.msg);
			trace("UsersMessageReceiver::handleVoiceUserTalking() -- user [" + + msg.voiceUserId + "," + msg.talking + "] ");			
			userSession.userList.userTalkingChange(msg.voiceUserId, msg.talking);
		}
		
		private function handleGetUsersReply(m:Object):void {
			var msg:Object = JSON.parse(m.msg);
			
			for(var i:int; i < msg.users.length; i++) {
				var newUser:Object = msg.users[i];
				addParticipant(newUser);
			}
			
			userSession.userList.allUsersAddedSignal.dispatch();
		}
		
		private function handleParticipantJoined(m:Object):void {
			var msg:Object = JSON.parse(m.msg);
			var newUser:Object = msg.user;
			addParticipant(newUser);
		}
		
		private function addParticipant(newUser:Object):void {
			var user:User = new User;
			
			user.hasStream = newUser.hasStream;
			user.streamName = newUser.webcamStream;
			user.locked = newUser.locked;
			user.name = newUser.name;
			user.phoneUser = newUser.phoneUser;
			user.presenter = newUser.presenter;
			user.role = newUser.role;
			user.userID = newUser.userId;
			user.voiceJoined = newUser.voiceUser.joined;
			user.voiceUserId = newUser.voiceUser.userId;
			user.isLeavingFlag = false;
			user.listenOnly = newUser.listenOnly;
			user.muted = newUser.voiceUser.muted;
			
			var mood:String = newUser.mood;
			switch (mood.substr(0, mood.indexOf(","))){
				case "AGREE":
					user.status = User.AGREE;
					break;
				case "DISAGREE":
					user.status = User.DISAGREE;
					break;
				case "SAD":
					user.status = User.SAD;
					break;
				case "RAISE_HAND":
					user.status = User.RAISE_HAND;
					break;
				case "":
				case "CLEAR_MOOD":
					user.status = User.NO_STATUS;
					break;
				}
			
			userSession.userList.addUser(user);
			
			// The following properties are 'special', in that they have view changes associated with them.
			// The UserList changes the model appropriately, then dispatches a signal to the views.
		}
		
		private function handleParticipantLeft(m:Object):void {
			var msg:Object = JSON.parse(m.msg);
			trace("UsersMessageReceiver::handleParticipantLeft() -- user [" + msg.user.userId + "] has left the meeting");
			userSession.userList.removeUser(msg.user.userId);
		}

		private function handleAssignPresenterCallback(m:Object):void {
			var msg:Object = JSON.parse(m.msg);
			trace("UsersMessageReceiver::handleAssignPresenterCallback() -- user [" + msg.newPresenterID + "] is now the presenter");
			userSession.userList.assignPresenter(msg.newPresenterID);
		}
		
		private function handleUserJoinedVoice(m:Object):void {
			var msg:Object = JSON.parse(m.msg);
			var voiceUser:Object = msg.user.voiceUser;
			trace("UsersMessageReceiver::handleUserJoinedVoice() -- user [" + msg.user.externUserID + "] has joined voice with voiceId [" + voiceUser.userId + "]");
			userSession.userList.userJoinAudio(msg.user.externUserID, voiceUser.userId, voiceUser.muted, voiceUser.talking, voiceUser.locked);
		}
		
		private function handleUserLeftVoice(m:Object):void {
			var msg:Object = JSON.parse(m.msg);
			trace("UsersMessageReceiver::handleUserLeftVoice() -- user [" + msg.user.userId + "] has left voice");
			userSession.userList.userLeaveAudio(msg.user.userId);
		}
		
		private function handleUserSharedWebcam(m:Object):void {
			var msg:Object = JSON.parse(m.msg);
			trace("UsersMessageReceiver::handleUserSharedWebcam() -- user [" + msg.userId + "] has shared their webcam with stream [" + msg.webcamStream + "]");
			userSession.userList.userStreamChange(msg.userId, true, msg.webcamStream); 
		}
		
		private function handleUserUnsharedWebcam(m:Object):void {
			var msg:Object = JSON.parse(m.msg);
			trace("UsersMessageReceiver::handleUserUnsharedWebcam() -- user [" + msg.userId + "] has unshared their webcam");
			userSession.userList.userStreamChange(msg.userId, false, "");
		}
		
		private function handleUserListeningOnly(m:Object):void {
			var msg:Object = JSON.parse(m.msg);
			//It seems that listenOnly keeps to be true
			//Temp solution to set listenOnly to false when user drop listen only mode.
			trace("UsersMessageReceiver::handleUserListeningOnly -- user [" + msg.userId + "] has listen only set to [" + !userSession.userList.me.listenOnly + "]");
			userSession.userList.listenOnlyChange(msg.userId, !userSession.userList.me.listenOnly);
		}
		
		private function handleVoiceUserMuted(m:Object):void {
			var msg:Object = JSON.parse(m.msg);
			trace("UsersMessageReceiver::handleVoiceUserMuted() -- user [" + msg.voiceUserId + ", muted: " + msg.muted + "]");
			userSession.userList.userMuteChange(msg.voiceUserId, msg.muted);
		}
		
		private function handleMeetingHasEnded(m:Object):void {
			var msg:Object = JSON.parse(m.msg);
			trace("UsersMessageReceiver::handleMeetingHasEnded() -- meeting has ended");
			userSession.logoutSignal.dispatch();
		}

		private function handleLogout(m:Object):void {
			var msg:Object = JSON.parse(m.msg);
			trace("UsersMessageReceiver::handleLogout() -- logging out!");
			userSession.logoutSignal.dispatch();
		}
		
		private function handleJoinedMeeting(m:Object):void {
			var msg:Object = JSON.parse(m.msg);
			trace("UsersMessageReceiver::handleJoinedMeeting()");
			userSession.joinMeetingResponse(msg);
		}
		
		private function handleRecordingStatusChanged(m:Object):void {
			var msg:Object = JSON.parse(m.msg);
			trace("UsersMessageReceiver::handleRecordingStatusChanged() -- recording status changed");
			userSession.recordingStatusChanged(msg.recording);
		}
		
		private function handleGetRecordingStatusReply(m:Object):void {
			trace("UsersMessageReceiver::handleGetRecordingStatusReply() -- recording status");
			var msg:Object = JSON.parse(m.msg);
			userSession.recordingStatusChanged(msg.recording);
		}
	}
}