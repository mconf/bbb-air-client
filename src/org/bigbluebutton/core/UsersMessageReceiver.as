package org.bigbluebutton.core
{
	import mx.utils.ObjectUtil;
	
	import org.bigbluebutton.model.Guest;
	import org.bigbluebutton.model.IMessageListener;
	import org.bigbluebutton.model.IUserSession;
	import org.bigbluebutton.model.User;
	import org.bigbluebutton.model.UserSession;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	import org.osmf.logging.Log;
	
	public class UsersMessageReceiver implements IMessageListener
	{
		public var userSession: IUserSession;
		
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
				case "validateAuthTokenReply":
					handleValidateAuthTokenReply(message);
					break;
				case "user_requested_to_enter":
					handleUserRequestToEnter(message);
				case "get_guests_waiting_reply":
					handleGetGuestsWaitingReply(message);
				case "participantRoleChange":
					handleParticipantRoleChange(message);
				default:
					break;
			}
		}
		
		private function handleParticipantRoleChange(m:Object):void {
			var msg:Object = JSON.parse(m.msg);
			trace("ParticipantRoleChange: "+ObjectUtil.toString(msg));
			userSession.userList.roleChange(msg.userID, msg.role);
		}
		
		private function handleGuestPolicy(m:Object):void {
			var msg:Object = JSON.parse(m.msg);
			trace("guestPolicy");
			userSession.guestPolicySignal.dispatch(msg.guestPolicy);
		}
		
		private function handleGuestResponse(m:Object):void {
			var msg:Object = JSON.parse(m.msg);
			trace("GuestResponse: "+ObjectUtil.toString(msg));
			userSession.guestList.removeGuest(msg.userId);
			if (msg.userId == userSession.userId) {
				userSession.guestEntranceSignal.dispatch(msg.response);
			}
		}
		private function handleGetGuestsWaitingReply(m:Object):void {
			var msg:Object = JSON.parse(m.msg);
			if(msg.hasOwnProperty("guestsWaiting")){
				var guests:Array = msg.guestsWaiting.split(",");
				for (var i:int = 0; i<guests.length; i++) {
					if(guests[i].length > 0){
						var guestInfo:Array = guests[i].split(":");
						var guest:Guest = new Guest();
						guest.name = guestInfo[1];
						guest.userID = guestInfo[0];
						userSession.guestList.addGuest(guest);
					}
				}
			}
		}
		
		private function handleUserRequestToEnter(m:Object):void {
			var msg:Object = JSON.parse(m.msg);
			trace("UserRequestToEnter: "+ObjectUtil.toString(msg));
			var guest:Guest = new Guest();
			guest.name = msg.name;
			guest.userID = msg.userId;
			userSession.guestList.addGuest(guest);
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
				case "SPEAK_LOUDER":
					userSession.userList.statusChange(msg.userID, User.SPEAK_LOUDER);
					break;
				case "SPEAK_LOWER":
					userSession.userList.statusChange(msg.userID, User.SPEAK_LOWER);
					break;
				case "SPEAK_FASTER":
					userSession.userList.statusChange(msg.userID, User.SPEAK_FASTER);
					break;
				case "SPEAK_SLOWER":
					userSession.userList.statusChange(msg.userID, User.SPEAK_SLOWER);
					break;
				case "BE_RIGHT_BACK":
					userSession.userList.statusChange(msg.userID, User.BE_RIGHT_BACK);
					break;
				case "LAUGHTER":
					userSession.userList.statusChange(msg.userID, User.LAUGHTER);
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
				case "SPEAK_LOUDER":
					user.status = User.SPEAK_LOUDER;
					break;
				case "SPEAK_LOWER":
					user.status = User.SPEAK_LOWER;
					break;
				case "SPEAK_FASTER":
					user.status = User.SPEAK_FASTER;
					break;
				case "SPEAK_SLOWER":
					user.status = User.SPEAK_SLOWER;
					break;
				case "BE_RIGHT_BACK":
					user.status = User.BE_RIGHT_BACK;
					break;
				case "LAUGHTER":
					user.status = User.LAUGHTER;
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
			userSession.guestList.removeGuest(msg.user.userId);
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
			trace("UsersMessageReceiver::handleUserUnsharedWebcam() -- user [" + msg.userId + "] has unshared their webcam with stream ["+ msg.webcamStream +"]");
			userSession.userList.userStreamChange(msg.userId, false, msg.webcamStream);
		}
		
		private function handleUserListeningOnly(m:Object):void {
			var msg:Object = JSON.parse(m.msg);
			trace("UsersMessageReceiver::handleUserListeningOnly -- user [" + msg.userId + "] has listen only set to [" + userSession.userList.me.listenOnly + "]");
			userSession.userList.listenOnlyChange(msg.userId, userSession.userList.me.listenOnly);
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
		
		private function handleValidateAuthTokenReply(m:Object):void {
			trace("UsersMessageReceiver::handleValidateAuthTokenReply()");
			var msg:Object = JSON.parse(m.msg);
			userSession.authTokenSignal.dispatch(msg.valid);
		}
	}
}