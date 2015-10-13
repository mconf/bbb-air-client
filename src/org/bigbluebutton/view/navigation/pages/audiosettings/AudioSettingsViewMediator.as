package org.bigbluebutton.view.navigation.pages.audiosettings {
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import mx.core.FlexGlobals;
	import mx.events.ItemClickEvent;
	import mx.resources.ResourceManager;
	import org.bigbluebutton.command.ShareMicrophoneSignal;
	import org.bigbluebutton.core.ISaveData;
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
		public var saveData:ISaveData;
		
		[Inject]
		public var shareMicrophoneSignal:ShareMicrophoneSignal;
		
		private var autoJoined:Boolean;
		
		private var micActivityTimer:Timer = null;
		
		override public function initialize():void {
			userSession.userList.userChangeSignal.add(userChangeHandler);
			FlexGlobals.topLevelApplication.pageName.text = ResourceManager.getInstance().getString('resources', 'audioSettings.title');
			var userMe:User = userSession.userList.me;
			view.applyBtn.addEventListener(MouseEvent.CLICK, onApplyClick);
			view.enableAudio.addEventListener(Event.CHANGE, onEnableAudioClick);
			view.enableMic.addEventListener(Event.CHANGE, onEnableMicClick);
			view.enablePushToTalk.addEventListener(Event.CHANGE, onEnablePushToTalkClick);
			view.gainSlider.addEventListener(Event.CHANGE, gainChange);
			userSession.lockSettings.disableMicSignal.add(disableMic);
			disableMic(userSession.lockSettings.disableMic && userMe.role != User.MODERATOR && !userMe.presenter && userMe.locked);
			view.enableAudio.selected = (userMe.voiceJoined || userMe.listenOnly);
			view.enablePushToTalk.enabled = view.enableMic.selected = userMe.voiceJoined;
			view.enablePushToTalk.selected = userSession.pushToTalk;
			FlexGlobals.topLevelApplication.backBtn.visible = true;
			FlexGlobals.topLevelApplication.profileBtn.visible = false;
			loadMicGain();
			if (userSession.voiceStreamManager && userSession.voiceStreamManager.mic) {
				micActivityTimer = new Timer(100);
				micActivityTimer.addEventListener(TimerEvent.TIMER, micActivity);
				micActivityTimer.start();
			}
		}
		
		private function loadMicGain() {
			var gain = saveData.read("micGain");
			if (gain) {
				view.gainSlider.value = gain / 10;
				setMicGain(gain);
			}
		}
		
		private function setMicGain(gain:Number) {
			if (userSession.voiceStreamManager) {
				userSession.voiceStreamManager.setDefaultMicGain(gain);
				if (!userSession.pushToTalk && userSession.voiceStreamManager.mic) {
					userSession.voiceStreamManager.mic.gain = gain;
				}
			}
		}
		
		private function gainChange(e:Event) {
			var gain:Number = e.target.value * 10
			saveData.save("micGain", gain);
			setMicGain(gain);
		}
		
		private function micActivity(e:TimerEvent):void {
			if (userSession.voiceStreamManager.mic) {
				view.micActivityMask.width = view.gainSlider.width - (view.gainSlider.width * userSession.voiceStreamManager.mic.activityLevel / 100);
				view.micActivityMask.x = view.micActivity.x + view.micActivity.width - view.micActivityMask.width;
			}
		}
		
		private function disableMic(disable:Boolean):void {
			if (disable) {
				view.enableMic.enabled = false;
				view.enableMic.selected = false;
			} else {
				view.enableMic.enabled = true;
			}
		}
		
		private function onApplyClick(event:Event):void {
			var audioOptions:Object = new Object();
			audioOptions.shareMic = userSession.userList.me.voiceJoined = view.enableMic.selected && view.enableAudio.selected;
			audioOptions.listenOnly = userSession.userList.me.listenOnly = !view.enableMic.selected && view.enableAudio.selected;
			shareMicrophoneSignal.dispatch(audioOptions);
			userUISession.popPage();
		}
		
		private function onEnableAudioClick(event:Event):void {
			if (!view.enableAudio.selected) {
				view.enableMic.selected = false;
				view.enablePushToTalk.enabled = false;
				userSession.pushToTalk = false;
			}
		}
		
		private function onEnableMicClick(event:Event):void {
			view.enablePushToTalk.enabled = view.enableMic.selected;
			if (view.enableMic.selected) {
				view.enableAudio.selected = true;
			}
			userSession.pushToTalk = (view.enablePushToTalk.selected && view.enablePushToTalk.enabled);
		}
		
		private function onEnablePushToTalkClick(event:Event):void {
			userSession.pushToTalk = view.enablePushToTalk.selected;
		}
		
		private function userChangeHandler(user:User, type:int):void {
			if (user.me) {
				if (type == UserList.LISTEN_ONLY) {
					view.enableAudio.selected = user.voiceJoined || user.listenOnly;
					view.enableMic.selected = user.voiceJoined;
				}
			}
		}
		
		override public function destroy():void {
			super.destroy();
			userSession.lockSettings.disableMicSignal.remove(disableMic);
			view.applyBtn.removeEventListener(MouseEvent.CLICK, onApplyClick);
			view.enableAudio.removeEventListener(MouseEvent.CLICK, onEnableAudioClick);
			view.enableMic.removeEventListener(MouseEvent.CLICK, onEnableMicClick);
			if (micActivityTimer) {
				micActivityTimer.removeEventListener(TimerEvent.TIMER, micActivity);
			}
			view.enablePushToTalk.removeEventListener(MouseEvent.CLICK, onEnablePushToTalkClick);
			userSession.userList.userChangeSignal.remove(userChangeHandler);
			userSession.phoneAutoJoin = false;
		}
	}
}
