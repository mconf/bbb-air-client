package org.bigbluebutton.core {
	
	import flash.events.AsyncErrorEvent;
	import flash.events.NetDataEvent;
	import flash.events.NetStatusEvent;
	import flash.events.PermissionEvent;
	import flash.events.StatusEvent;
	import flash.media.Microphone;
	import flash.media.MicrophoneEnhancedMode;
	import flash.media.MicrophoneEnhancedOptions;
	import flash.media.SoundCodec;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.permissions.PermissionStatus;
	
	import mx.utils.ObjectUtil;
	
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	public class VoiceStreamManager {
		protected var _incomingStream:NetStream = null;
		
		protected var _outgoingStream:NetStream = null;
		
		protected var _connection:NetConnection = null;
		
		protected var _mic:Microphone = null;
		
		protected var _defaultMicGain:Number = 50;
		
		protected var _enhancedMic:Boolean = false;
		
		protected var _successConnectedIn:ISignal = new Signal();
		
		protected var _successConnectedOut:ISignal = new Signal();
		
		protected var _unsuccessConnectedIn:ISignal = new Signal();
		
		protected var _unsuccessConnectedOut:ISignal = new Signal();
		
		protected var _disconnectedIn:ISignal = new Signal();
		
		protected var _disconnectedOut:ISignal = new Signal();
		
		protected var _connectedIn:Boolean = false;
		protected var _connectingIn:Boolean = false;
		protected var _connectedOut:Boolean = false;
		protected var _connectingOut:Boolean = false;
		
		public function get unsuccessConnectedIn():ISignal {
			return _unsuccessConnectedIn;
		}
		
		public function get successConnectedIn():ISignal {
			return _successConnectedIn;
		}
		
		public function get unsuccessConnectedOut():ISignal {
			return _unsuccessConnectedOut;
		}
		
		public function get successConnectedOut():ISignal {
			return _successConnectedOut;
		}
		
		public function get disconnectedIn():ISignal {
			return _disconnectedIn;
		}
		
		public function get disconnectedOut():ISignal {
			return _disconnectedOut;
		}
		
		public function set connectedIn(connected:Boolean):void {
			if (_connectingIn) {
				if (connected) {
					successConnectedIn.dispatch();
				} else {
					unsuccessConnectedIn.dispatch();
				}
			} else {
				if (! connected) {
					disconnectedIn.dispatch();
				}
			}
			_connectingIn = false;
			_connectedIn = connected;
		}
		
		public function set connectingIn(value:Boolean):void {
			_connectingIn = value;
		}
		
		public function set connectedOut(connected:Boolean):void {
			if (_connectingOut) {
				if (connected) {
					successConnectedOut.dispatch();
				} else {
					unsuccessConnectedOut.dispatch();
				}
			} else {
				if (! connected) {
					disconnectedOut.dispatch();
				}
			}
			_connectingOut = false;
			_connectedOut = connected;
		}
		
		public function set connectingOut(value:Boolean):void {
			_connectingOut = value;
		}
		
		public function muteMic(mute:Boolean = true):void {
			if (_mic) {
				_mic.gain = mute? 0 : _defaultMicGain;
			}
		}
		
		public function unmuteMic():void {
			if (_mic) {
				_mic.gain = _defaultMicGain;
			}
		}
		
		public function setMicGain(value:Number):void {
			if (_mic) {
				_mic.gain = value;
			}
			_defaultMicGain = value;
		}
		
		public function getMicActivityLevel():Number {
			return _mic ? _mic.activityLevel : 0;
		}
		
		public function isMicEnabled():Boolean {
			return _mic != null;
		}
		
		public function play(connection:NetConnection, streamName:String):void {
			connectingIn = true;
			
			_incomingStream = new NetStream(connection);
			_incomingStream.client = this;
			_incomingStream.addEventListener(NetDataEvent.MEDIA_TYPE_DATA, onNetDataEventIn);
			_incomingStream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatusEventIn);
			_incomingStream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncErrorEventIn);
			/*
			 * Set the bufferTime to 0 (zero) for live stream as suggested in the doc.
			 * http://help.adobe.com/en_US/FlashPlatform/beta/reference/actionscript/3/flash/net/NetStream.html#bufferTime
			 * If we don't, we'll have a long audio delay when a momentary network congestion occurs. When the congestion
			 * disappears, a flood of audio packets will arrive at the client and Flash will buffer them all and play them.
			 * http://stackoverflow.com/questions/1079935/actionscript-netstream-stutters-after-buffering
			 * ralam (Dec 13, 2010)
			 */
			_incomingStream.bufferTime = 0;
			_incomingStream.receiveAudio(true);
			_incomingStream.receiveVideo(false);
			_incomingStream.play(streamName);
		}
		
		protected function onNetDataEventIn(event:NetDataEvent):void {
			//			trace(ObjectUtil.toString(event));
		}
		
		public function publish(connection:NetConnection, streamName:String, codec:String, pushToTalk:Boolean):void {
			connectingOut = true;
			
			if (! Microphone.isSupported || noMicrophone()) {
				connectedOut = false;
				return;
			}
			
			var mic:Microphone = getMicrophone();
			
			if (! mic) {
				connectedOut = false;
				return;
			}
			
			_outgoingStream = new NetStream(connection);
			_outgoingStream.client = this;
			_outgoingStream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatusEventOut);
			_outgoingStream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncErrorEventOut);
			
			if (Microphone.permissionStatus == PermissionStatus.GRANTED) {
				setupMicrophone(mic, codec, pushToTalk);
				attachAndPublish(mic, streamName);
			} else {
				mic.addEventListener(PermissionEvent.PERMISSION_STATUS, function(e:PermissionEvent):void {
					if (e.status == PermissionStatus.GRANTED) {
						setupMicrophone(mic, codec, pushToTalk);
						attachAndPublish(mic, streamName);
					} else {
						// permission denied
						connectedOut = false;
					}
				});
				try {
					mic.requestPermission();
				} catch(e:Error) {
					// another request is in progress
					connectedOut = false;
				}
			}
		}
		
		private function attachAndPublish(mic:Microphone, streamName:String):void {
			if (mic) {
				_mic = mic;
				_outgoingStream.attachAudio(_mic);
				_outgoingStream.publish(streamName, "live");
			}
		}
		
		private function noMicrophone():Boolean {
			return ((Microphone.getMicrophone() == null) || (Microphone.names.length == 0)
				|| ((Microphone.names.length == 1) && (Microphone.names[0] == "Unknown Microphone")));
		}
		
		private function setupMicrophone(mic:Microphone, codec:String, pushToTalk:Boolean):void {
			if (_enhancedMic) {
				var options:MicrophoneEnhancedOptions = new MicrophoneEnhancedOptions();
				options.mode = MicrophoneEnhancedMode.FULL_DUPLEX;
				options.autoGain = false;
				options.echoPath = 128;
				options.nonLinearProcessing = true;
				mic['enhancedOptions'] = options;
				mic.setUseEchoSuppression(true);
			}
			
			mic.addEventListener(StatusEvent.STATUS, onMicStatusEvent);
			mic.setLoopBack(false);
			mic.setSilenceLevel(0, 20000);
			if (codec == "SPEEX") {
				mic.encodeQuality = 6;
				mic.codec = SoundCodec.SPEEX;
				mic.framesPerPacket = 1;
				mic.rate = 16;
				trace("Using SPEEX wideband codec");
			} else {
				mic.codec = SoundCodec.NELLYMOSER;
				mic.rate = 8;
				trace("Using Nellymoser codec");
			}

			mic.gain = pushToTalk ? 0 : _defaultMicGain;
		}
		
		private function getMicrophone():Microphone {
			var mic:Microphone = null;
			mic = Microphone.getEnhancedMicrophone();
			if (mic) {
				_enhancedMic = true;
				return mic;
			}
			
			mic = Microphone.getMicrophone();
			if (mic) {
				_enhancedMic = false;
				return mic;
			}
			
			return null;
		}
		
		protected function onMicStatusEvent(event:StatusEvent):void {
			trace("New microphone status event");
			//trace(ObjectUtil.toString(event));
			switch (event.code) {
				case "Microphone.Muted":
					break;
				case "Microphone.Unmuted":
					break;
				default:
					break;
			}
		}
		
		public function close():void {
			closeIn();
			closeOut();
		}
		
		private function closeIn():void {
			if (_incomingStream) {
				_incomingStream.removeEventListener(NetDataEvent.MEDIA_TYPE_DATA, onNetDataEventIn);
				_incomingStream.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatusEventIn);
				_incomingStream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncErrorEventIn);
				_incomingStream.close();
				_incomingStream = null;
			}
			connectedIn = false;
		}
		
		private function closeOut():void {
			if (_outgoingStream) {
				_outgoingStream.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatusEventOut);
				_outgoingStream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncErrorEventOut);
				_outgoingStream.attachAudio(null);
				_outgoingStream.close();
				_outgoingStream = null;
			}
			_mic = null;
			connectedOut = false;
		}
		
		protected function onNetStatusEventIn(event:NetStatusEvent):void {
			trace("VoiceStreamManager: onNetStatusEventIn - " + event.info.code);
			switch (event.info.code) {
				case "NetStream.Play.Start":
					connectedIn = true;
					break;
				case "NetStream.Play.Stop":
					connectedIn = false;
					break;
				default:
					break;
			}
			
			if (event.info.level == "error") {
				connectedIn = false;
			}
		}
		
		protected function onAsyncErrorEventIn(event:AsyncErrorEvent):void {
			trace(ObjectUtil.toString(event));
			connectedIn = false;
		}
		
		public function onPlayStatusIn(... rest):void {
			trace("onPlayStatus() " + ObjectUtil.toString(rest));
		}
		
		protected function onNetStatusEventOut(event:NetStatusEvent):void {
			trace("VoiceStreamManager: onNetStatusEventOut - " + event.info.code);
			switch (event.info.code) {
				case "NetStream.Publish.Start":
					connectedOut = true;
					break;
				default:
					break;
			}
			
			if (event.info.level == "error") {
				connectedOut = false;
			}
		}
		
		protected function onAsyncErrorEventOut(event:AsyncErrorEvent):void {
			trace(ObjectUtil.toString(event));
			connectedOut = false;
		}
		
		public function onMetaData(... rest):void {
			trace("onMetaData() " + ObjectUtil.toString(rest));
		}
		
		public function onHeaderData(... rest):void {
			trace("onHeaderData() " + ObjectUtil.toString(rest));
		}
	}
}
