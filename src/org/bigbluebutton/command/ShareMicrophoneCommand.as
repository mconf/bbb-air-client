package org.bigbluebutton.command {
	
	import org.bigbluebutton.core.ISaveData;
	import org.bigbluebutton.core.IVoiceConnection;
	import org.bigbluebutton.core.VoiceStreamManager;
	import org.bigbluebutton.model.IConferenceParameters;
	import org.bigbluebutton.model.IUserSession;
	
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
		
		private function get voiceConnection():IVoiceConnection {
			return userSession.voiceConnection;
		}
		
		private function enableAudio():void {
			if (!voiceConnection.connection.connected) {
				voiceConnection.successConnected.add(voiceSuccessConnected);
				voiceConnection.unsuccessConnected.add(voiceUnsuccessConnected);
				voiceConnection.connect(conferenceParameters, _listenOnly);
			} else if (!voiceConnection.callActive) {
				voiceConnection.successConnected.add(voiceSuccessConnected);
				voiceConnection.unsuccessConnected.add(voiceUnsuccessConnected);
				voiceConnection.call(_listenOnly);
			} else {
				voiceConnection.hangUpSuccessSignal.add(onHangupSuccessBeforeEnable);
				voiceConnection.hangUp();
			}
		}
		
		private function onHangupSuccess():void {
			voiceConnection.hangUpSuccessSignal.remove(onHangupSuccess);
			if (userSession.voiceStreamManager != null) {
				userSession.voiceStreamManager.close();
				userSession.voiceStreamManager = null;
			}
		}
		
		private function disableAudio():void {
			if (voiceConnection.callActive) {
				voiceConnection.hangUpSuccessSignal.add(onHangupSuccess);
				voiceConnection.hangUp();
			}
		}
		
		private function onHangupSuccessBeforeEnable():void {
			voiceConnection.hangUpSuccessSignal.remove(onHangupSuccessBeforeEnable);
			onHangupSuccess();
			enableAudio();
		}
		
		private function voiceSuccessConnected(publishName:String, playName:String, codec:String, manager:VoiceStreamManager = null):void {
			trace(LOG + "voiceSuccessConnected()");
			voiceConnection.successConnected.remove(voiceSuccessConnected);
			voiceConnection.unsuccessConnected.remove(voiceUnsuccessConnected);
			if (! manager) {
				manager = new VoiceStreamManager();
				var savedGain:Object = saveData.read("micGain");
				if (savedGain) {
					manager.setMicGain(savedGain as Number);
				}
			}
			
			manager.successConnectedIn.add(mediaInSuccessConnected);
			manager.unsuccessConnectedIn.add(mediaInUnsuccessConnected);
			manager.successConnectedOut.add(mediaOutSuccessConnected);
			manager.unsuccessConnectedOut.add(mediaOutUnsuccessConnected);
			manager.disconnectedIn.add(mediaInDisconnected);
			manager.disconnectedOut.add(mediaOutDisconnected);
			
			manager.play(voiceConnection.connection, playName);
			if (publishName != null && publishName.length != 0) {
				manager.publish(voiceConnection.connection, publishName, codec, userSession.pushToTalk);
			}
			userSession.voiceStreamManager = manager;
		}
		
		private function mediaInSuccessConnected():void {
			trace(LOG + "mediaInSuccessConnected()");
			userSession.voiceStreamManager.successConnectedIn.remove(mediaInSuccessConnected);
			userSession.voiceStreamManager.unsuccessConnectedIn.remove(mediaInUnsuccessConnected);
			
			userSession.audioEnabled = true;
		}
		
		private function mediaInUnsuccessConnected():void {
			trace(LOG + "mediaInUnsuccessConnected()");
			userSession.voiceStreamManager.successConnectedIn.remove(mediaInSuccessConnected);
			userSession.voiceStreamManager.unsuccessConnectedIn.remove(mediaInUnsuccessConnected);
			
			userSession.audioEnabled = false;
			disableAudio();
		}
		
		private function mediaOutSuccessConnected():void {
			trace(LOG + "mediaOutSuccessConnected()");
			userSession.voiceStreamManager.successConnectedOut.remove(mediaOutSuccessConnected);
			userSession.voiceStreamManager.unsuccessConnectedOut.remove(mediaOutUnsuccessConnected);

			if (userSession.pushToTalk) {
				userSession.pushToTalkSignal.dispatch();
			}
			
			userSession.micEnabled = true;
		}
		
		private function mediaOutUnsuccessConnected():void {
			trace(LOG + "mediaOutUnsuccessConnected()");
			userSession.voiceStreamManager.successConnectedOut.remove(mediaOutSuccessConnected);
			userSession.voiceStreamManager.unsuccessConnectedOut.remove(mediaOutUnsuccessConnected);
			
			userSession.micEnabled = false;
		}
		
		private function mediaInDisconnected():void {
			trace(LOG + "mediaInDisconnected()");
			userSession.voiceStreamManager.disconnectedIn.remove(mediaInDisconnected);
			
			userSession.audioEnabled = false;
		}
		
		private function mediaOutDisconnected():void {
			trace(LOG + "mediaOutDisconnected()");
			userSession.voiceStreamManager.disconnectedOut.remove(mediaOutDisconnected);
			
			userSession.micEnabled = false;
		}
		
		private function voiceUnsuccessConnected(reason:String):void {
			trace(LOG + "voiceUnsuccessConnected()");
			voiceConnection.successConnected.remove(voiceSuccessConnected);
			voiceConnection.unsuccessConnected.remove(voiceUnsuccessConnected);
		}
	}
}
