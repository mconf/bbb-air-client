package org.bigbluebutton.core {
	
	import org.bigbluebutton.model.chat.ChatMessageVO;
	import org.osflash.signals.ISignal;
	
	public interface IScreenshareService {
		function get sendMessageOnSuccessSignal():ISignal;
		function get sendMessageOnFailureSignal():ISignal;
		function setupMessageSenderReceiver():void;
		function sendPong(session:String, timestamp: Number):void;
	}
}
