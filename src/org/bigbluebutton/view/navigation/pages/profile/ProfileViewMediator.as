package org.bigbluebutton.view.navigation.pages.profile {
	
	import flash.events.MouseEvent;
	import mx.core.FlexGlobals;
	import mx.events.ItemClickEvent;
	import mx.resources.ResourceManager;
	import org.bigbluebutton.command.MoodSignal;
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
			view.logoutButton.addEventListener(MouseEvent.CLICK, logoutClick);
			view.clearStatusButton.addEventListener(MouseEvent.CLICK, clearStatusClick);
			view.handButton.addEventListener(MouseEvent.CLICK, raiseHandClick);
			FlexGlobals.topLevelApplication.pageName.text = ResourceManager.getInstance().getString('resources', 'profile.title');
			FlexGlobals.topLevelApplication.profileBtn.visible = false;
			FlexGlobals.topLevelApplication.backBtn.visible = true;
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
		
		override public function destroy():void {
			super.destroy();
			view.logoutButton.removeEventListener(MouseEvent.CLICK, logoutClick);
			view.clearStatusButton.removeEventListener(MouseEvent.CLICK, clearStatusClick);
			view.dispose();
			view = null;
		}
	}
}
