package org.bigbluebutton.core
{
	import org.bigbluebutton.model.IConferenceParameters;
	import org.bigbluebutton.model.IMessageListener;
	import org.bigbluebutton.model.IUserSession;
	import org.bigbluebutton.model.User;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	public class UsersService implements IUsersService
	{	
		[Inject]
		public var conferenceParameters: IConferenceParameters;
		
		[Inject]
		public var userSession: IUserSession;
		
		public var usersMessageSender:UsersMessageSender;
		public var usersMessageReceiver:UsersMessageReceiver;

		public function UsersService() {
			usersMessageSender = new UsersMessageSender;
			usersMessageReceiver = new UsersMessageReceiver;
		}
		
		public function setupMessageSenderReceiver():void {
			usersMessageReceiver.userSession = userSession;
			usersMessageSender.userSession = userSession;
			
			userSession.mainConnection.addMessageListener(usersMessageReceiver as IMessageListener);
			userSession.logoutSignal.add(logout);
		}

		public function muteMe():void {
			mute(userSession.userList.me);
		}
		
		public function unmuteMe():void {
			unmute(userSession.userList.me);
		}
		
		public function mute(user:User):void {
			muteUnmute(user, true);
		}
		
		public function unmute(user:User):void {
			muteUnmute(user, false);
		}
		
		private function muteUnmute(user:User, mute:Boolean):void {
			if (user.voiceJoined) {
				usersMessageSender.muteUnmuteUser(user.userID, mute);
			}
		}
		
		public function addStream(userId:String, streamName:String):void {
			usersMessageSender.addStream(userId, streamName);
		}
		
		public function removeStream(userId:String, streamName:String):void {
			usersMessageSender.removeStream(userId, streamName);
		}
		
		public function logout():void {
			userSession.logoutSignal.remove(logout);
			disconnect(true);
		}
		
		public function disconnect(onUserAction:Boolean):void {
			userSession.mainConnection.disconnect(onUserAction);
		}
		
		public function changeMood(mood:String):void
		{
			usersMessageSender.changeMood(userSession.userList.me.userID, mood);
		}
		
		public function clearUserStatus(userID:String):void
		{
			usersMessageSender.changeMood(userID, User.NO_STATUS);
		}
		
		public function kickUser(userID:String):void {
			usersMessageSender.kickUser(userID);
		}
		
		public function queryForParticipants():void {
			usersMessageSender.queryForParticipants();
		}
		
		public function assignPresenter(userid:String, name:String, assignedBy:String):void {
			usersMessageSender.assignPresenter(userid, name, assignedBy);
		}
		
		public function queryForRecordingStatus():void {
			usersMessageSender.queryForRecordingStatus();
		}
		
		public function changeRecordingStatus(userID:String, recording:Boolean):void {
			usersMessageSender.changeRecordingStatus(userID, recording);
		}
		
		public function muteAllUsers(mute:Boolean, dontMuteThese:Array = null):void {
			usersMessageSender.muteAllUsers(mute, dontMuteThese);
		}
		
		public function muteUnmuteUser(userid:String, mute:Boolean):void {
			usersMessageSender.muteUnmuteUser(userid, mute);
		}
		
		public function ejectUser(userid:String):void {
			usersMessageSender.ejectUser(userid);
		}
		
		public function getRoomMuteState():void {
			usersMessageSender.getRoomMuteState();
		}
		
		public function getRoomLockState():void {
			usersMessageSender.getRoomLockState();
		}
		
		public function setAllUsersLock(lock:Boolean, except:Array = null):void {
			usersMessageSender.setAllUsersLock(lock, except);
		}
		
		public function setUserLock(internalUserID:String, lock:Boolean):void {
			usersMessageSender.setUserLock(internalUserID, lock);
		}
		
		public function getLockSettings():void {
			usersMessageSender.getLockSettings();
		}
		
		public function saveLockSettings(newLockSettings:Object):void {
			usersMessageSender.saveLockSettings(newLockSettings);
		}
		
		public function sendJoinMeetingMessage():void {
			usersMessageSender.sendJoinMeetingMessage(conferenceParameters.internalUserID);
		}
		
		public function askToEnter():void {
			usersMessageSender.askToEnter();
		}
		
		public function getWaitingGuests(): void{
			usersMessageSender.getWaitingGuests();
		}
		
		public function getGuestPolicy(): void{
			usersMessageSender.getGuestPolicy();
		}
		
		public function responseToGuest(userId:String, response:Boolean):void {
			usersMessageSender.responseToGuest(userId, response);
		}
		
		public function responseToAllGuests(response:Boolean):void {
			usersMessageSender.responseToAllGuests(response);
		}


		public function validateToken():void {
			usersMessageSender.validateToken(conferenceParameters.internalUserID);
		}
		
		public function changeRole(userID:String, role:String):void {
			usersMessageSender.changeRole(userID, role)	
		}
	}
}