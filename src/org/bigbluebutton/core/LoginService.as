package org.bigbluebutton.core
{
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	
	import mx.utils.ObjectUtil;
	
	import org.bigbluebutton.core.util.URLParser;
	import org.bigbluebutton.model.Config;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	import org.bigbluebutton.model.VideoProfileManager;

	public class LoginService implements ILoginService
	{
		protected var _urlRequest:URLRequest = null;
		protected var _successJoinedSignal:Signal = new Signal();
		protected var _successGetConfigSignal:Signal = new Signal();
		protected var _successGetProfilesSignal:Signal = new Signal();
		protected var _unsuccessJoinedSignal:Signal = new Signal();
		protected var _joinUrl:String;
		
		public function get successJoinedSignal():ISignal {
			return _successJoinedSignal;
		}

		public function get unsuccessJoinedSignal():ISignal {
			return _unsuccessJoinedSignal;
		}
		
		public function get successGetConfigSignal():ISignal
		{
			return _successGetConfigSignal;
		}
		
		public function get successGetProfilesSignal():ISignal
		{
			return _successGetProfilesSignal;
		}
		
		protected function fail(reason:String):void { 
			trace("Login failed. " + reason);
			unsuccessJoinedSignal.dispatch(reason);
		}			
		
		public function load(joinUrl:String):void {
			_joinUrl = joinUrl;
			
			var joinSubservice:JoinService = new JoinService();
			joinSubservice.successSignal.add(afterJoin);
			joinSubservice.unsuccessSignal.add(fail);
			joinSubservice.join(_joinUrl);
		}
		
		protected function afterJoin(urlRequest:URLRequest, responseUrl:String):void {
			_urlRequest = urlRequest;
			
			var configSubservice:ConfigService = new ConfigService();
			configSubservice.successSignal.add(onConfigResponse);
			configSubservice.unsuccessSignal.add(fail);
			configSubservice.getConfig(getServerUrl(responseUrl), _urlRequest);
			
			var profilesService:ProfilesService = new ProfilesService();
			profilesService.successSignal.add(onProfilesResponse);
			profilesService.unsuccessSignal.add(fail);
			profilesService.getProfiles(getServerUrl(responseUrl), _urlRequest);
			
		}
		
		protected function getServerUrl(url:String):String {
			var parser:URLParser = new URLParser(url);
			return parser.protocol + "://" + parser.host + ":" + parser.port;
		}
		
		protected function onConfigResponse(xml:XML):void {
			var config:Config = new Config(xml);
			successGetConfigSignal.dispatch(config);
			
			var enterSubservice:EnterService = new EnterService();
			enterSubservice.successSignal.add(onEnterResponse);
			enterSubservice.unsuccessSignal.add(fail);
			enterSubservice.enter(config.application.host, _urlRequest);
		}
		
		protected function onProfilesResponse(xml:XML):void {
			var prof:VideoProfileManager = new VideoProfileManager(xml);
			prof.getProfileTypes();
			successGetProfilesSignal.dispatch(prof);
						
		}
		
		protected function onEnterResponse(user:Object):void {
			successJoinedSignal.dispatch(user);
		}
	}
}