package org.bigbluebutton.core {
	
	import flash.net.NetConnection;
	import flash.net.Responder;
	import mx.utils.ObjectUtil;
	import org.bigbluebutton.command.ShareMicrophoneSignal;
	import org.bigbluebutton.model.ConferenceParameters;
	import org.bigbluebutton.model.IConferenceParameters;
	import org.bigbluebutton.model.IUserSession;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	public class VoiceConnection extends DefaultConnectionCallback implements IVoiceConnection {
		public const LOG:String = "VoiceConnection::";
		
		[Inject]
		public var baseConnection:IBaseConnection;
		
		[Inject]
		public var userSession:IUserSession;
		
		[Inject]
		public var shareMicrophoneSignal:ShareMicrophoneSignal;
		
		public var _callActive:Boolean = false;
		
		protected var _successConnected:ISignal = new Signal();
		
		protected var _unsuccessConnected:ISignal = new Signal();
		
		protected var _hangUpSuccessSignal:ISignal = new Signal();
		
		protected var _applicationURI:String;
		
		protected var _username:String;
		
		protected var _conferenceParameters:IConferenceParameters;
		
		protected var _listenOnly:Boolean;
		
		public function VoiceConnection() {
		}
		
		[PostConstruct]
		public function init():void {
			baseConnection.init(this);
			baseConnection.successConnected.add(onConnectionSuccess);
			baseConnection.unsuccessConnected.add(onConnectionUnsuccess);
			userSession.lockSettings.disableMicSignal.add(disableMic);
		}
		
		private function disableMic(disable:Boolean):void {
			if (disable && _callActive) {
				var audioOptions:Object = new Object();
				audioOptions.shareMic = userSession.userList.me.voiceJoined = false;
				audioOptions.listenOnly = userSession.userList.me.listenOnly = true;
				shareMicrophoneSignal.dispatch(audioOptions);
			}
		}
		
		private function onConnectionUnsuccess(reason:String):void {
			unsuccessConnected.dispatch(reason);
		}
		
		private function onConnectionSuccess():void {
			userSession.userList.me.listenOnly = _listenOnly;
			call(_listenOnly);
		}
		
		public function get unsuccessConnected():ISignal {
			return _unsuccessConnected;
		}
		
		public function get successConnected():ISignal {
			return _successConnected;
		}
		
		public function set uri(uri:String):void {
			_applicationURI = uri;
		}
		
		public function get uri():String {
			return _applicationURI;
		}
		
		public function get connection():NetConnection {
			return baseConnection.connection;
		}
		
		public function get callActive():Boolean {
			return _callActive;
		}
		
		public function get hangUpSuccessSignal():ISignal {
			return _hangUpSuccessSignal;
		}
		
		public function connect(confParams:IConferenceParameters, listenOnly:Boolean):void {
			// we don't use scope in the voice communication (many hours lost on it)
			_conferenceParameters = confParams;
			_listenOnly = listenOnly;
			var userId:String;
			switch (userSession.version) {
				case "0.9":
					userId = confParams.externUserID;
					break;
				case "1.0":
				default:
					userId = confParams.internalUserID;
			}
			trace(confParams.username + ", " + confParams.role + ", " + confParams.meetingName + ", " + userId);
			_username = encodeURIComponent(userId + "-bbbID-" + confParams.username);
			baseConnection.connect(_applicationURI, confParams.conference, userId, _username, confParams.voicebridge);
		}
		
		public function disconnect(onUserCommand:Boolean):void {
			baseConnection.disconnect(onUserCommand);
		}
		
		//**********************************************//
		//												//
		//			CallBack Methods from Red5			//
		//												//
		//**********************************************//
		public function failedToJoinVoiceConferenceCallback(msg:String):* {
			trace(LOG + "failedToJoinVoiceConferenceCallback(): " + msg);
			unsuccessConnected.dispatch("Failed on failedToJoinVoiceConferenceCallback()");
		}
		
		public function disconnectedFromJoinVoiceConferenceCallback(msg:String):* {
			trace(LOG + "disconnectedFromJoinVoiceConferenceCallback(): " + msg);
			unsuccessConnected.dispatch("Failed on disconnectedFromJoinVoiceConferenceCallback()");
			//hangUp();
		}
		
		public function successfullyJoinedVoiceConferenceCallback(publishName:String, playName:String, codec:String):* {
			trace(LOG + "successfullyJoinedVoiceConferenceCallback()");
			successConnected.dispatch(publishName, playName, codec);
		}
		
		//**********************************************//
		//												//
		//					SIP Actions					//
		//												//
		//**********************************************//
		public function call(listenOnly:Boolean = false):void {
			if (!callActive) {
				trace(LOG + "call(): starting voice call");
				baseConnection.connection.call(
					"voiceconf.call",
					new Responder(callOnSucess, callUnsucess),
					"default",
					_username,
					_conferenceParameters.webvoiceconf,
					listenOnly.toString()
					);
			} else {
				trace(LOG + "call(): voice call already active");
			}
		}
		
		private function callOnSucess(result:Object):void {
			trace(LOG + "callOnSuccess(): " + ObjectUtil.toString(result));
			_callActive = true;
		}
		
		private function callUnsucess(status:Object):void {
			trace(LOG + "callUnsuccess(): " + ObjectUtil.toString(status));
			unsuccessConnected.dispatch("Failed on call()");
			_callActive = false;
		}
		
		public function hangUp():void {
			if (callActive) {
				trace(LOG + "hangUp(): hanging up the voice call");
				baseConnection.connection.call(
					"voiceconf.hangup",
					new Responder(hangUpOnSucess, hangUpUnsucess),
					"default"
					);
			} else {
				trace(LOG + "hangUp(): call already hung up");
			}
		}
		
		private function hangUpOnSucess(result:Object):void {
			trace(LOG + "hangUpOnSucess(): " + ObjectUtil.toString(result));
			_callActive = false;
			_hangUpSuccessSignal.dispatch();
		}
		
		private function hangUpUnsucess(status:Object):void {
			trace(LOG + "hangUpUnsucess: " + ObjectUtil.toString(status));
		}
	}
}
