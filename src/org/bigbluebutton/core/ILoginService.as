package org.bigbluebutton.core {
	
	import org.osflash.signals.ISignal;
	
	public interface ILoginService {
		function get successJoinedSignal():ISignal;
		function get successGetConfigSignal():ISignal;
		function get unsuccessJoinedSignal():ISignal;
		function get successGetProfilesSignal():ISignal;
		function load(joinUrl:String):void;
	}
}
