package org.bigbluebutton.core
{
	import flash.net.Responder;
	
	import org.bigbluebutton.model.IUserSession;
	
	public class UsersMessageSender
	{
		public var userSession:IUserSession;
		
		// The default callbacks of userSession.mainconnection.sendMessage
		private var defaultSuccessResponse:Function = function(result:String):void { trace(result); };
		private var defaultFailureResponse:Function = function(status:String):void { trace(status); };

		public function UsersMessageSender() {

		}
		
		public function kickUser(userID:String):void {
			trace("UsersMessageSender::kickUser() -- Sending [participants.kickUser] message to server.. with message [userID:" + userID + "]");
			
			var message:Object = new Object();
			message["userID"] = userID;
			
			userSession.mainConnection.sendMessage("participants.kickUser", defaultSuccessResponse, defaultFailureResponse, message);
		}
		
		public function queryForParticipants():void {
			trace("UsersMessageSender::queryForParticipants() -- Sending [participants.getParticipants] message to server");
			
			userSession.mainConnection.sendMessage("participants.getParticipants", defaultSuccessResponse, defaultFailureResponse);
		}
		
		public function assignPresenter(userid:String, name:String, assignedBy:String):void {
			trace("UsersMessageSender::assignPresenter() -- Sending [participants.assignPresenter] message to server with message " +
					"[newPresenterID:" + userid + ", newPresenterName:" + name + ", assignedBy:" + assignedBy + "]");
			
			var message:Object = new Object();
			message["newPresenterID"] = userid;
			message["newPresenterName"] = name;
			message["assignedBy"] = assignedBy;
			
			userSession.mainConnection.sendMessage("participants.assignPresenter", defaultSuccessResponse, defaultFailureResponse, message);
		}
		
		public function changeMood(userID:String, mood:String):void {
			trace("UsersMessageSender::changeMood() -- Sending participants.setParticipantStatus] message to server with "+mood+" status");
			var message:Object = new Object();
			message["userID"] = userID;
			message["status"] = "mood";
			message["value"] = mood;
			userSession.mainConnection.sendMessage("participants.setParticipantStatus", defaultSuccessResponse, defaultFailureResponse, message);
		}
		
		public function addStream(userID:String, streamName:String):void {
			trace("UsersMessageSender::addStream() -- Sending [participants.shareWebcam] message to server with message [streamName:" + streamName + "]");
			
			userSession.mainConnection.sendMessage("participants.shareWebcam", defaultSuccessResponse, defaultFailureResponse, streamName);
		}
		
		public function removeStream(userID:String, streamName:String):void {
			trace("UsersMessageSender::removeStream() -- Sending [participants.unshareWebcam] message to server");
			
			userSession.mainConnection.sendMessage("participants.unshareWebcam", defaultSuccessResponse, defaultFailureResponse, streamName);
		}
		
		public function queryForRecordingStatus():void {
			trace("UsersMessageSender::queryForRecordingStatus() -- Sending [queryForRecordingStatus] message to server")
			
			userSession.mainConnection.sendMessage("participants.getRecordingStatus", defaultSuccessResponse, defaultFailureResponse);
		}
		
		public function changeRecordingStatus(userID:String, recording:Boolean):void {
			trace("UsersMessageSender::changeRecordingStatus() -- Sending [changeRecordingStatus] message to server with message [userId:" + userID + ", recording:" + recording + "]");
			
			var message:Object = new Object();
			message["userId"] = userID;
			message["recording"] = recording;
			
			userSession.mainConnection.sendMessage("participants.setRecordingStatus", defaultSuccessResponse, defaultFailureResponse, message);
		}
		
		public function muteAllUsers(mute:Boolean, dontMuteThese:Array = null):void {
			trace("UsersMessageSender::muteAllUsers() -- Sending [voice.muteAllUsers] message to server");
			
			if (dontMuteThese == null) {
				dontMuteThese = [];
			}
			
			var message:Object = new Object();
			message["mute"] = mute;
			message["exceptUsers"] = dontMuteThese;
			
			userSession.mainConnection.sendMessage("voice.muteAllUsers", defaultSuccessResponse, defaultFailureResponse, message);
		}
		
		public function muteUnmuteUser(userid:String, mute:Boolean):void {
			trace("UsersMessageSender::muteUnmuteUser() -- Sending [voice.muteUnmuteUser] message to server with message [userId:" + userid + ", mute:" + mute + "]");
			
			var message:Object = new Object();
			message["userId"] = userid;
			message["mute"] = mute;

			userSession.mainConnection.sendMessage("voice.muteUnmuteUser", defaultSuccessResponse, defaultFailureResponse, message);
		}
		
		public function ejectUser(userid:String):void {
			trace("UsersMessageSender::ejectUser() -- Sending [voice.kickUSer] message to server with message [userId:" + userid + "]");
			
			var message:Object = new Object();
			message["userId"] = userid;

			userSession.mainConnection.sendMessage("voice.kickUSer", defaultSuccessResponse, defaultFailureResponse, message);
		}
		
		public function getRoomMuteState():void {
			trace("UsersMessageSender::getRoomMuteState() -- Sending [voice.isRoomMuted] message to server");

			userSession.mainConnection.sendMessage("voice.isRoomMuted", defaultSuccessResponse, defaultFailureResponse);
		}
		
		public function getRoomLockState():void {
			trace("UsersMessageSender::getRoomLockState() -- Sending [lock.isRoomLocked] message to server");

			userSession.mainConnection.sendMessage("lock.isRoomLocked", defaultSuccessResponse, defaultFailureResponse);
		}
		
		public function setAllUsersLock(lock:Boolean, except:Array = null):void {
			trace("UsersMessageSender::setAllUsersLock() -- Sending [setAllUsersLock] message to server");
		}
		
		public function setUserLock(internalUserID:String, lock:Boolean):void {
			trace("UsersMessageSender::setUserLock() -- Sending [setUserLock] message to server");
		}
		
		public function getLockSettings():void {
			trace("UsersMessageSender::getLockSettings() -- Sending [getLockSettings] message to server");
			
			userSession.mainConnection.sendMessage("lock.getLockSettings", defaultSuccessResponse, defaultFailureResponse);
		}
		
		public function saveLockSettings(newLockSettings:Object):void {
			trace("UsersMessageSender::saveLockSettings() -- Sending [saveLockSettings] message to server");
		}
		
		public function sendJoinMeetingMessage(internalUserID:String):void {
			trace("UsersMessageSender::sendJoinMeetingMessage() -- Sending [joinMeeting] message to server with message [userID: " + internalUserID + "]");
			
			userSession.mainConnection.sendMessage("joinMeeting", defaultSuccessResponse, defaultFailureResponse, internalUserID);
		}
		
		public function askToEnter():void {
			//TODO implement this function in the new way of handling messages
			trace("askToEnter - userID:[" + userSession.userId + "]");
			userSession.mainConnection.sendMessage("participants.askingToEnter", defaultSuccessResponse, defaultFailureResponse);
		
		}
		public function getWaitingGuests():void {
			trace("retrieveWaitingGuests()");
			
			userSession.mainConnection.sendMessage("participants.getGuestsWaiting", defaultSuccessResponse, defaultFailureResponse);
		}
		
		public function getGuestPolicy():void {
			trace("getGuestPolicy");
			
			userSession.mainConnection.sendMessage("participants.getGuestPolicy", defaultSuccessResponse, defaultFailureResponse);
		}
		
		public function responseToGuest(userId:String, response:Boolean):void {
			trace("responseToGuest - guestID:[" + userId + "] response:[" + response + "]");
			
			var message:Object = new Object();
			message["guestID"] = userId;
			message["response"] = response;
			
			userSession.mainConnection.sendMessage("participants.responseToGuest",	defaultSuccessResponse,	defaultFailureResponse, message);
		}
		
		public function responseToAllGuests(response:Boolean):void {
			trace("responseToAllGuests - response:[" + response + "]");
			
			userSession.mainConnection.sendMessage("participants.responseToAllGuests",	defaultSuccessResponse,	defaultFailureResponse, response);
		}

		
		public function validateToken(internalUserID:String):void {
			trace("validateToken");
			
			userSession.mainConnection.sendMessage("validateToken", defaultSuccessResponse, defaultFailureResponse, internalUserID);
		}
		
		public function changeRole(userID:String, role:String):void {
			trace("UsersMessageSender::setParticipantRole() -- Sending [participants.setParticipantRole] message to server.. with message [userID:" + userID + ", role:" + role + "]");
			
			var message:Object = new Object();
			message["userId"] = userID;
			message["role"] = role;
			userSession.mainConnection.sendMessage("participants.setParticipantRole", defaultSuccessResponse, defaultFailureResponse, message);
		}
	}
}