package org.bigbluebutton.view.navigation.pages.audiosettings {
	
	import flash.events.MouseEvent;
	import mx.core.FlexGlobals;
	import mx.events.ItemClickEvent;
	import mx.resources.ResourceManager;
	import org.bigbluebutton.command.ShareMicrophoneSignal;
	import org.bigbluebutton.model.IUserSession;
	import org.bigbluebutton.model.IUserUISession;
	import org.bigbluebutton.model.User;
	import org.bigbluebutton.model.UserList;
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	public class AudioSettingsViewMediator extends Mediator {
		
		[Inject]
		public var view:IAudioSettingsView;
		
		[Inject]
		public var userSession:IUserSession;
		
		[Inject]
		public var userUISession:IUserUISession;
		
		[Inject]
		public var shareMicrophoneSignal:ShareMicrophoneSignal;
		
		private var autoJoined:Boolean;
		
		override public function initialize():void {
			FlexGlobals.topLevelApplication.pageName.text = ResourceManager.getInstance().getString('resources', 'audioSettings.title');
			var userMe:User = userSession.userList.me;
			view.applyBtn.addEventListener(MouseEvent.CLICK, onApplyClick);
			view.enableAudio.addEventListener(MouseEvent.CLICK, onEnableAudioClick);
			view.enableMic.addEventListener(MouseEvent.CLICK, onEnableMicClick);
			userSession.lockSettings.disableMicSignal.add(disableMic);
			disableMic(userSession.lockSettings.disableMic && userMe.role != User.MODERATOR && !userMe.presenter && userMe.locked);
			view.enableAudio.selected = (userMe.voiceJoined || userMe.listenOnly);
			view.enableMic.selected = userMe.voiceJoined;
			FlexGlobals.topLevelApplication.backBtn.visible = true;
			FlexGlobals.topLevelApplication.profileBtn.visible = false;
		}
		
		private function disableMic(disable:Boolean):void {
			if (disable) {
				view.enableMic.enabled = false;
				view.enableMic.selected = false;
			} else {
				view.enableMic.enabled = true;
			}
		}
		
		private function onApplyClick(event:MouseEvent):void {
			var audioOptions:Object = new Object();
			audioOptions.shareMic = userSession.userList.me.voiceJoined = view.enableMic.selected && view.enableAudio.selected;
			audioOptions.listenOnly = userSession.userList.me.listenOnly = !view.enableMic.selected && view.enableAudio.selected;
			shareMicrophoneSignal.dispatch(audioOptions);
			if (userSession.phoneAutoJoin && !userSession.phoneSkipCheck) {
				userSession.phoneAutoJoin = false;
				userUISession.popPage();
			}
		}
		
		private function onEnableAudioClick(event:MouseEvent):void {
			if (view.enableAudio.selected) {
				view.enableMic.selected = false;
			}
		}
		
		private function onEnableMicClick(event:MouseEvent):void {
			if (!view.enableMic.selected) {
				view.enableAudio.selected = true;
			}
		}
		
		override public function destroy():void {
			super.destroy();
			userSession.lockSettings.disableMicSignal.remove(disableMic);
			view.applyBtn.removeEventListener(MouseEvent.CLICK, onApplyClick);
			view.enableAudio.removeEventListener(MouseEvent.CLICK, onEnableAudioClick);
			view.enableMic.removeEventListener(MouseEvent.CLICK, onEnableMicClick);
			userSession.phoneAutoJoin = false;
		}
	}
}
