package org.bigbluebutton.core {
	
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
	import org.bigbluebutton.model.VideoProfileManager;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	public class LoginService implements ILoginService {
		protected var _urlRequest:URLRequest = null;
		
		protected var _successJoinedSignal:Signal = new Signal();
		
		protected var _successGetConfigSignal:Signal = new Signal();
		
		protected var _successGetProfilesSignal:Signal = new Signal();
		
		protected var _unsuccessJoinedSignal:Signal = new Signal();
		
		protected var _joinUrl:String;
		
		protected var _config:Config;
		
		public function get successJoinedSignal():ISignal {
			return _successJoinedSignal;
		}
		
		public function get unsuccessJoinedSignal():ISignal {
			return _unsuccessJoinedSignal;
		}
		
		public function get successGetConfigSignal():ISignal {
			return _successGetConfigSignal;
		}
		
		public function get successGetProfilesSignal():ISignal {
			return _successGetProfilesSignal;
		}
		
		protected function fail(reason:String):void {
			trace("Login failed. " + reason);
			unsuccessJoinedSignal.dispatch(reason);
			//TODO: show message to user saying that the meeting identifier is invalid 
		}
		
		public function load(joinUrl:String):void {
			_joinUrl = joinUrl;
			var joinSubservice:JoinService = new JoinService();
			joinSubservice.successSignal.add(afterJoin);
			joinSubservice.unsuccessSignal.add(fail);
			joinSubservice.join(_joinUrl);
		}
		
		protected function afterJoin(urlRequest:URLRequest, responseUrl:String, httpStatusCode:Number = 0):void {
			_urlRequest = urlRequest;
			var configSubservice:ConfigService = new ConfigService();
			configSubservice.successSignal.add(onConfigResponse);
			configSubservice.unsuccessSignal.add(fail);
			configSubservice.getConfig(getServerUrl(responseUrl), _urlRequest);
		}
		
		protected function getServerUrl(url:String):String {
			var parser:URLParser = new URLParser(url);
			return parser.protocol + "://" + parser.host + ":" + parser.port;
		}
		
		protected function onConfigResponse(xml:XML):void {
			_config = new Config(xml);
			successGetConfigSignal.dispatch(_config);
			var profilesService:ProfilesService = new ProfilesService();
			profilesService.successSignal.add(onProfilesResponse);
			profilesService.unsuccessSignal.add(failedLoadingProfiles);
			profilesService.getProfiles(getServerUrl(_config.application.host), _urlRequest);
		}
		
		protected function afterEnter(result:Object):void {
			if (result.returncode == 'SUCCESS') {
				trace("Join SUCCESS");
				trace(ObjectUtil.toString(result));
				successJoinedSignal.dispatch(result);
			} else {
				trace("Join FAILED");
				unsuccessJoinedSignal.dispatch("Add some reason here!");
			}
		}
		
		protected function dispatchVideoProfileManager(manager:VideoProfileManager):void {
			successGetProfilesSignal.dispatch(manager);
			var enterSubservice:EnterService = new EnterService();
			enterSubservice.successSignal.add(afterEnter);
			enterSubservice.unsuccessSignal.add(fail);
			enterSubservice.enter(_config.application.host, _urlRequest);
		}
		
		protected function onProfilesResponse(xml:XML):void {
			trace("sucess video profile");
			var prof:VideoProfileManager = new VideoProfileManager();
			prof.parseProfilesXml(xml);
			dispatchVideoProfileManager(prof);
		}
		
		protected function failedLoadingProfiles(reason:String):void {
			trace("failed video profile: " + reason);
			var prof:VideoProfileManager = new VideoProfileManager();
			prof.parseConfigXml(_config.getConfigFor("VideoconfModule"));
			dispatchVideoProfileManager(prof);
		}
	}
}
