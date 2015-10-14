package org.bigbluebutton.command {
	
	import flash.utils.setTimeout;
	import mx.utils.ObjectUtil;
	import org.bigbluebutton.core.IBigBlueButtonConnection;
	import org.bigbluebutton.core.ISaveData;
	import org.bigbluebutton.core.IUsersService;
	import org.bigbluebutton.core.IVoiceConnection;
	import org.bigbluebutton.core.VoiceConnection;
	import org.bigbluebutton.core.VoiceStreamManager;
	import org.bigbluebutton.model.IConferenceParameters;
	import org.bigbluebutton.model.IUserSession;
	import org.bigbluebutton.model.IUserUISession;
	import robotlegs.bender.bundles.mvcs.Command;
	
	public class ShareMicrophoneCommand extends Command {
		private const LOG:String = "ShareMicrophoneCommand::";
		
		[Inject]
		public var userSession:IUserSession;
		
		[Inject]
		public var conferenceParameters:IConferenceParameters;
		
		[Inject]
		public var saveData:ISaveData;
		
		[Inject]
		public var audioOptions:Object;
		
		private var _shareMic:Boolean;
		
		private var _listenOnly:Boolean;
		
		private var voiceConnection:IVoiceConnection;
		
		override public function execute():void {
			getAudioOption(audioOptions);
			if (_shareMic || _listenOnly) {
				enableAudio();
			} else {
				disableAudio();
			}
		}
		
		private function getAudioOption(option:Object):void {
			if (option != null && option.hasOwnProperty("shareMic") && option.hasOwnProperty("listenOnly")) {
				_shareMic = option.shareMic;
				_listenOnly = option.listenOnly;
			}
		}
		
		private function enableAudio():void {
			voiceConnection = userSession.voiceConnection;
			voiceConnection.hangUpSuccessSignal.remove(enableAudio);
			if (!voiceConnection.connection.connected) {
				voiceConnection.successConnected.add(mediaSuccessConnected);
				voiceConnection.unsuccessConnected.add(mediaUnsuccessConnected);
				voiceConnection.connect(conferenceParameters, _listenOnly);
			} else if (!voiceConnection.callActive) {
				voiceConnection.successConnected.add(mediaSuccessConnected);
				voiceConnection.unsuccessConnected.add(mediaUnsuccessConnected);
				voiceConnection.call(_listenOnly);
			} else {
				disableAudio();
				voiceConnection.hangUpSuccessSignal.add(enableAudio);
			}
		}
		
		private function disableAudio():void {
			var manager:VoiceStreamManager = userSession.voiceStreamManager;
			voiceConnection = userSession.voiceConnection;
			if (manager != null) {
				manager.close();
				voiceConnection.hangUp();
			}
		}
		
		private function mediaSuccessConnected(publishName:String, playName:String, codec:String, manager = null):void {
			trace(LOG + "mediaSuccessConnected()");
			if (!manager) {
				var manager:VoiceStreamManager = new VoiceStreamManager();
				var savedGain = saveData.read("micGain");
				if (savedGain) {
					manager.setDefaultMicGain(savedGain);
				}
			}
			manager.play(voiceConnection.connection, playName);
			if (publishName != null && publishName.length != 0) {
				manager.publish(voiceConnection.connection, publishName, codec, userSession.pushToTalk);
			}
			userSession.voiceStreamManager = manager;
			voiceConnection.successConnected.remove(mediaSuccessConnected);
			voiceConnection.unsuccessConnected.remove(mediaUnsuccessConnected);
			if (userSession.pushToTalk) {
				userSession.pushToTalkSignal.dispatch();
			}
		}
		
		private function mediaUnsuccessConnected(reason:String):void {
			trace(LOG + "mediaUnsuccessConnected()");
			voiceConnection.successConnected.remove(mediaSuccessConnected);
			voiceConnection.unsuccessConnected.remove(mediaUnsuccessConnected);
		}
	}
}
