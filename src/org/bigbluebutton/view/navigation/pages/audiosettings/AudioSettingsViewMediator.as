package org.bigbluebutton.view.navigation.pages.audiosettings {
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.core.FlexGlobals;
	import mx.events.ResizeEvent;
	import mx.resources.ResourceManager;
	
	import org.bigbluebutton.command.ShareMicrophoneSignal;
	import org.bigbluebutton.core.ISaveData;
	import org.bigbluebutton.model.IUserSession;
	import org.bigbluebutton.model.IUserUISession;
	import org.bigbluebutton.model.User;
	import org.bigbluebutton.model.UserList;
	import org.bigbluebutton.view.navigation.pages.PagesENUM;
	
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
			userSession.micEnabledSignal.add(micEnabledHandler);
			userSession.audioEnabledSignal.add(audioEnabledHandler);
			FlexGlobals.topLevelApplication.pageName.text = ResourceManager.getInstance().getString('resources', 'audioSettings.title');
			var userMe:User = userSession.userList.me;
			view.continueBtn.addEventListener(MouseEvent.CLICK, onContinueClick);
			view.enableAudio.addEventListener(Event.CHANGE, onEnableAudioClick);
			view.enableMic.addEventListener(Event.CHANGE, onEnableMicClick);
			view.enablePushToTalk.addEventListener(Event.CHANGE, onEnablePushToTalkClick);
			if (!userSession.phoneAutoJoin) {
				FlexGlobals.topLevelApplication.stage.addEventListener(ResizeEvent.RESIZE, stageOrientationChangingHandler);
			}
			view.gainSlider.addEventListener(Event.CHANGE, gainChange);
			userSession.lockSettings.disableMicSignal.add(disableMic);
			disableMic(userSession.lockSettings.disableMic && userMe.role != User.MODERATOR && !userMe.presenter && userMe.locked);
			view.enableAudio.selected = (userMe.voiceJoined || userMe.listenOnly);
			view.enablePushToTalk.enabled = view.enableMic.selected = userMe.voiceJoined;
			view.enablePushToTalk.selected = (userSession.pushToTalk || userSession.phoneAutoJoin);
			FlexGlobals.topLevelApplication.backBtn.visible = true;
			FlexGlobals.topLevelApplication.profileBtn.visible = false;
			loadMicGain();
			micActivityTimer = new Timer(100);
			micActivityTimer.addEventListener(TimerEvent.TIMER, micActivity);
			micActivityTimer.start();
			view.continueBtn.visible = userSession.phoneAutoJoin;
		}
		
		private function stageOrientationChangingHandler(e:Event):void {
			var tabletLandscape:Boolean = FlexGlobals.topLevelApplication.isTabletLandscape();
			if (tabletLandscape) {
				userUISession.popPage();
				if (userUISession.currentPage == PagesENUM.PROFILE) {
					userUISession.popPage();
				}
				userUISession.pushPage(PagesENUM.SPLITSETTINGS, PagesENUM.AUDIOSETTINGS);
			}
		}
		
		private function loadMicGain():void {
			var gain:Object = saveData.read("micGain");
			if (gain) {
				view.gainSlider.value = (gain as Number) / 10;
			}
		}
		
		private function setMicGain(gain:Number):void {
			if (userSession.voiceStreamManager) {
				userSession.voiceStreamManager.setMicGain(gain);
			}
		}
		
		private function gainChange(e:Event):void {
			var gain:Number = e.target.value * 10
			saveData.save("micGain", gain);
			setMicGain(gain);
		}
		
		private function micActivity(e:TimerEvent):void {
			if (userSession.voiceStreamManager) {
				view.micActivityMask.width = view.gainSlider.width - (view.gainSlider.width * userSession.voiceStreamManager.getMicActivityLevel() / 100);
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
		
		private function onContinueClick(event:Event):void {
			userUISession.popPage();
		}
		
		private function onEnableAudioClick(event:Event):void {
			if (!view.enableAudio.selected) {
				view.enableMic.selected = false;
				view.enablePushToTalk.enabled = false;
				userSession.pushToTalk = false;
			}
			shareMicrophoneSignal.dispatch(getAudioOptions());
		}
		
		private function getAudioOptions():Object {
			var audioOptions:Object = new Object();
			audioOptions.shareMic = userSession.userList.me.voiceJoined = view.enableMic.selected && view.enableAudio.selected;
			audioOptions.listenOnly = userSession.userList.me.listenOnly = !view.enableMic.selected && view.enableAudio.selected;
			return audioOptions;
		}
		
		private function onEnableMicClick(event:Event):void {
			view.enablePushToTalk.enabled = view.enableMic.selected;
			if (view.enableMic.selected) {
				view.enableAudio.selected = true;
			}
			userSession.pushToTalk = (view.enablePushToTalk.selected && view.enablePushToTalk.enabled);
			shareMicrophoneSignal.dispatch(getAudioOptions());
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
		
		private function micEnabledHandler(enabled:Boolean):void {
			view.enableMic.selected = enabled;
		}
		
		private function audioEnabledHandler(enabled:Boolean):void {
			view.enableAudio.selected = enabled;
		}
		
		override public function destroy():void {
			super.destroy();
			userSession.lockSettings.disableMicSignal.remove(disableMic);
			view.continueBtn.removeEventListener(MouseEvent.CLICK, onContinueClick);
			view.enableAudio.removeEventListener(MouseEvent.CLICK, onEnableAudioClick);
			view.enableMic.removeEventListener(MouseEvent.CLICK, onEnableMicClick);
			FlexGlobals.topLevelApplication.stage.removeEventListener(ResizeEvent.RESIZE, stageOrientationChangingHandler);
			if (micActivityTimer) {
				micActivityTimer.removeEventListener(TimerEvent.TIMER, micActivity);
			}
			view.enablePushToTalk.removeEventListener(MouseEvent.CLICK, onEnablePushToTalkClick);
			userSession.userList.userChangeSignal.remove(userChangeHandler);
			userSession.micEnabledSignal.remove(micEnabledHandler);
			userSession.audioEnabledSignal.remove(audioEnabledHandler);
			userSession.phoneAutoJoin = false;
		}
	}
}
