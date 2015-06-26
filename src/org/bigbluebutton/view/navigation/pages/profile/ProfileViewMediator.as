package org.bigbluebutton.view.navigation.pages.profile {
	
	import flash.events.MouseEvent;
	import mx.core.FlexGlobals;
	import mx.events.ItemClickEvent;
	import mx.resources.ResourceManager;
	import org.bigbluebutton.command.ClearUserStatusSignal;
	import org.bigbluebutton.command.MoodSignal;
	import org.bigbluebutton.core.IUsersService;
	import org.bigbluebutton.model.IConferenceParameters;
	import org.bigbluebutton.model.IUserSession;
	import org.bigbluebutton.model.IUserUISession;
	import org.bigbluebutton.model.User;
	import org.bigbluebutton.model.UserList;
	import org.bigbluebutton.view.navigation.pages.PagesENUM;
	import robotlegs.bender.bundles.mvcs.Mediator;
	import spark.events.IndexChangeEvent;
	
	public class ProfileViewMediator extends Mediator {
		
		[Inject]
		public var view:IProfileView;
		
		[Inject]
		public var userSession:IUserSession;
		
		[Inject]
		public var userUISession:IUserUISession;
		
		[Inject]
		public var moodSignal:MoodSignal;
		
		[Inject]
		public var conferenceParameters:IConferenceParameters;
		
		[Inject]
		public var clearUserStatusSignal:ClearUserStatusSignal;
		
		[Inject]
		public var userService:IUsersService;
		
		override public function initialize():void {
			view.currentState = (conferenceParameters.serverIsMconf) ? "mconf" : "bbb";
			var userMe:User = userSession.userList.me;
			view.userNameButton.label = userMe.name;
			switch (userMe.status) {
				case User.RAISE_HAND:
					view.userStatusButton.label = ResourceManager.getInstance().getString('resources', 'profile.settings.handRaise');
					view.handButton.label = ResourceManager.getInstance().getString('resources', 'profile.settings.handLower');
					break;
				case User.AGREE:
					view.userStatusButton.label = ResourceManager.getInstance().getString('resources', 'profile.settings.agree');
					break;
				case User.DISAGREE:
					view.userStatusButton.label = ResourceManager.getInstance().getString('resources', 'profile.settings.disagree');
					break;
				case User.SPEAK_LOUDER:
					view.userStatusButton.label = ResourceManager.getInstance().getString('resources', 'profile.settings.speakLouder');
					break;
				case User.SPEAK_LOWER:
					view.userStatusButton.label = ResourceManager.getInstance().getString('resources', 'profile.settings.speakSofter');
					break;
				case User.SPEAK_FASTER:
					view.userStatusButton.label = ResourceManager.getInstance().getString('resources', 'profile.settings.speakFaster');
					break;
				case User.SPEAK_SLOWER:
					view.userStatusButton.label = ResourceManager.getInstance().getString('resources', 'profile.settings.speakSlower');
					break;
				case User.BE_RIGHT_BACK:
					view.userStatusButton.label = ResourceManager.getInstance().getString('resources', 'profile.settings.beRightBack');
					break;
				case User.LAUGHTER:
					view.userStatusButton.label = ResourceManager.getInstance().getString('resources', 'profile.settings.laughter');
					break;
				case User.SAD:
					view.userStatusButton.label = ResourceManager.getInstance().getString('resources', 'profile.settings.sad');
					break;
				case User.NO_STATUS:
					view.userStatusButton.visible = false;
					view.clearStatusButton.visible = false;
					view.userStatusButton.includeInLayout = false;
					view.clearStatusButton.includeInLayout = false;
					break;
			}
			disableCamButton(userSession.lockSettings.disableCam && !userMe.presenter && userMe.locked && userMe.role != User.MODERATOR);
			userSession.lockSettings.disableCamSignal.add(disableCamButton);
			if (userMe.role != User.MODERATOR) {
				displayManagementButtons(false);
			} else {
				setMuteState(userSession.meetingMuted);
				view.clearAllStatusButton.addEventListener(MouseEvent.CLICK, onClearAllButton);
				view.unmuteAllButton.addEventListener(MouseEvent.CLICK, onUnmuteAllButton);
				view.muteAllButton.addEventListener(MouseEvent.CLICK, onMuteAllButton);
				view.muteAllExceptPresenterButton.addEventListener(MouseEvent.CLICK, onMuteAllExceptPresenterButton);
			}
			if (!conferenceParameters.serverIsMconf) {
				view.clearAllStatusButton.label = ResourceManager.getInstance().getString('resources', 'management.lowerAllHands');
				view.clearAllStatusButton.styleName = "lowerAllHandsButtonStyle videoAudioSettingStyle contentFontSize";
			}
			userSession.userList.userChangeSignal.add(userChanged);
			view.logoutButton.addEventListener(MouseEvent.CLICK, logoutClick);
			view.clearStatusButton.addEventListener(MouseEvent.CLICK, clearStatusClick);
			view.handButton.addEventListener(MouseEvent.CLICK, raiseHandClick);
			FlexGlobals.topLevelApplication.pageName.text = ResourceManager.getInstance().getString('resources', 'profile.title');
			FlexGlobals.topLevelApplication.profileBtn.visible = false;
			FlexGlobals.topLevelApplication.backBtn.visible = true;
		}
		
		private function setMuteState(muted:Boolean) {
			if (muted) {
				view.muteAllButton.visible = false;
				view.muteAllButton.includeInLayout = false;
				view.muteAllExceptPresenterButton.visible = false;
				view.muteAllExceptPresenterButton.includeInLayout = false;
				view.unmuteAllButton.visible = true;
				view.unmuteAllButton.includeInLayout = true;
			} else {
				view.muteAllButton.visible = true;
				view.muteAllButton.includeInLayout = true;
				view.muteAllExceptPresenterButton.visible = true;
				view.muteAllExceptPresenterButton.includeInLayout = true;
				view.unmuteAllButton.visible = false;
				view.unmuteAllButton.includeInLayout = false;
			}
		}
		
		private function disableCamButton(disable:Boolean) {
			if (disable) {
				view.shareCameraButton.visible = false;
				view.shareCameraButton.includeInLayout = false;
			} else {
				view.shareCameraButton.visible = true;
				view.shareCameraButton.includeInLayout = true;
			}
		}
		
		/**
		 * User pressed log out button
		 */
		public function logoutClick(event:MouseEvent):void {
			userUISession.pushPage(PagesENUM.EXIT);
		}
		
		/**
		 * User pressed clean status button
		 */
		public function clearStatusClick(event:MouseEvent):void {
			var obj:Object;
			obj = User.NO_STATUS;
			moodSignal.dispatch(User.NO_STATUS);
			view.userStatusButton.visible = false;
			view.clearStatusButton.visible = false;
			view.userStatusButton.includeInLayout = false;
			view.clearStatusButton.includeInLayout = false;
			userSession.userList.me.status = User.NO_STATUS;
		}
		
		public function raiseHandClick(event:MouseEvent):void {
			if (userSession.userList.me.status == User.RAISE_HAND) {
				moodSignal.dispatch(User.NO_STATUS);
			} else {
				moodSignal.dispatch(User.RAISE_HAND);
			}
			userUISession.popPage();
		}
		
		protected function onClearAllButton(event:MouseEvent):void {
			for each (var user:User in userSession.userList.users) {
				clearUserStatusSignal.dispatch(user.userID);
				userSession.userList.getUser(user.userID).status = User.NO_STATUS;
			}
			userUISession.popPage();
		}
		
		protected function onMuteAllButton(event:MouseEvent):void {
			userService.muteAllUsers(true);
			setMuteState(true);
			userUISession.popPage();
		}
		
		protected function onUnmuteAllButton(event:MouseEvent):void {
			userService.muteAllUsers(false);
			setMuteState(false);
			userUISession.popPage();
		}
		
		protected function onMuteAllExceptPresenterButton(event:MouseEvent):void {
			userService.muteAllUsersExceptPresenter(true);
			setMuteState(true);
			userUISession.popPage();
		}
		
		private function displayManagementButtons(display:Boolean):void {
			view.managementLabel.visible = display;
			view.managementLabel.includeInLayout = display;
			view.clearAllStatusButton.visible = display;
			view.clearAllStatusButton.includeInLayout = display;
			view.muteAllButton.visible = display;
			view.muteAllButton.includeInLayout = display;
			view.muteAllExceptPresenterButton.visible = display;
			view.muteAllExceptPresenterButton.includeInLayout = display;
			view.lockViewersButton.visible = display;
			view.lockViewersButton.includeInLayout = display;
			view.unmuteAllButton.visible = display;
			view.unmuteAllButton.includeInLayout = display;
		}
		
		private function userChanged(user:User, type:int):void {
			if (userSession.userList.me.userID == user.userID) {
				if (userSession.userList.me.role == User.MODERATOR) {
					displayManagementButtons(true);
					setMuteState(userSession.meetingMuted);
				} else {
					displayManagementButtons(false);
				}
			}
		}
		
		override public function destroy():void {
			super.destroy();
			view.logoutButton.removeEventListener(MouseEvent.CLICK, logoutClick);
			view.clearStatusButton.removeEventListener(MouseEvent.CLICK, clearStatusClick);
			userSession.lockSettings.disableCamSignal.remove(disableCamButton);
			userSession.userList.userChangeSignal.remove(userChanged);
			view.dispose();
			view = null;
		}
	}
}
