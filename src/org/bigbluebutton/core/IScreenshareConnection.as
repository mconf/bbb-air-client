package org.bigbluebutton.core {
	
	import flash.net.NetConnection;
	
	import org.bigbluebutton.model.IMessageListener;
	import org.osflash.signals.ISignal;
	
	public interface IScreenshareConnection {
		function get unsuccessConnected():ISignal
		function get successConnected():ISignal
		function get isStreamingSignal():ISignal
		function get isStreaming():Boolean
		function set isStreaming(value:Boolean):void
		function onConnectionUnsuccess(reason:String):void
		function onConnectionSuccess():void
		function get applicationURI():String
		function set applicationURI(value:String):void
		function get streamWidth():Number
		function set streamWidth(value:Number):void
		function get streamHeight():Number
		function set streamHeight(value:Number):void
		function get room():String;
		function set room(value:String):void;
		function get connection():NetConnection
		function connect():void
		function disconnect(onUserCommand:Boolean):void
		function get mouseLocationChangedSignal():ISignal;
		function deskshareStreamStopped():void;
		
		function sendMessage(service:String, onSuccess:Function, onFailure:Function, message:Object = null):void;
		function addMessageListener(listener:IMessageListener):void
		function removeMessageListener(listener:IMessageListener):void
		function clearMessageListeners():void;
		
		function get session():String
		function set session(value:String):void
		function get streamId():String
		function set streamId(value:String):void
		function get url():String
		function set url(value:String):void
	}
}
