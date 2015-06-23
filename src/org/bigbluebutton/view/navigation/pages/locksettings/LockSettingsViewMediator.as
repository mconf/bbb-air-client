package org.bigbluebutton.view.navigation.pages.locksettings {
	
	import flash.events.MouseEvent;
	import mx.core.FlexGlobals;
	import mx.events.ItemClickEvent;
	import mx.resources.ResourceManager;
	import org.bigbluebutton.command.ShareMicrophoneSignal;
	import org.bigbluebutton.core.IUsersService;
	import org.bigbluebutton.model.IUserSession;
	import org.bigbluebutton.model.IUserUISession;
	import org.bigbluebutton.model.LockSettings;
	import org.bigbluebutton.model.User;
	import org.bigbluebutton.model.UserList;
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	public class LockSettingsViewMediator extends Mediator {
		
		[Inject]
		public var view:ILockSettingsView;
		
		[Inject]
		public var userSession:IUserSession;
		
		[Inject]
		public var userService:IUsersService;
		
		[Inject]
		public var userUISession:IUserUISession;
		
		private var _disableCam:Boolean;
		
		private var _disableMic:Boolean;
		
		private var _disablePublicChat:Boolean;
		
		private var _disablePrivateChat:Boolean;
		
		private var layout:Boolean;
		
		override public function initialize():void {
			loadLockSettings();
			view.applyButton.addEventListener(MouseEvent.CLICK, onApply);
			FlexGlobals.topLevelApplication.pageName.text = ResourceManager.getInstance().getString('resources', 'lockSettings.title');
			FlexGlobals.topLevelApplication.backBtn.visible = true;
			FlexGlobals.topLevelApplication.profileBtn.visible = false;
		}
		
		private function onApply(event:MouseEvent):void {
			var newLockSettings:Object = new Object();
			newLockSettings.disableCam = !view.cameraSwitch.selected;
			newLockSettings.disableMic = !view.micSwitch.selected;
			newLockSettings.disablePrivateChat = !view.privateChatSwitch.selected;
			newLockSettings.disablePublicChat = !view.publicChatSwitch.selected;
			newLockSettings.lockedLayout = !view.layoutSwitch.selected;
			userService.saveLockSettings(newLockSettings);
			userUISession.popPage();
			userUISession.popPage();
		}
		
		private function loadLockSettings() {
			view.cameraSwitch.selected = !userSession.lockSettings.disableCam;
			view.micSwitch.selected = !userSession.lockSettings.disableMic;
			view.publicChatSwitch.selected = !userSession.lockSettings.disablePublicChat;
			view.privateChatSwitch.selected = !userSession.lockSettings.disablePrivateChat;
			view.layoutSwitch.selected = !userSession.lockSettings.lockedLayout;
		}
		
		override public function destroy():void {
			super.destroy();
		}
	}
}
