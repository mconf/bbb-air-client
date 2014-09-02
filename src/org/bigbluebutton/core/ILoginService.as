package org.bigbluebutton.core
{
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	public interface ILoginService
	{
		function get successJoinedSignal():ISignal;
		function get successGetConfigSignal():ISignal;
		function get unsuccessJoinedSignal():ISignal;
		function get successGetProfilesSignal():ISignal;
		function load(joinUrl:String):void;
	}
}