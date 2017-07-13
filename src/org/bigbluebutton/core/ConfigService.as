package org.bigbluebutton.core {
	
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import mx.utils.ObjectUtil;
	import org.bigbluebutton.core.util.URLFetcher;
	import org.bigbluebutton.core.util.URLParser;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	import org.bigbluebutton.core.SessionToken;

	public class ConfigService {
		protected var _successSignal:Signal = new Signal();
		
		protected var _unsuccessSignal:Signal = new Signal();
		
		public function get successSignal():ISignal {
			return _successSignal;
		}
		
		public function get unsuccessSignal():ISignal {
			return _unsuccessSignal;
		}
		
		public function getConfig(serverUrl:String, urlRequest:URLRequest):void {
			var sessionToken = SessionToken.getSessionToken();
			if (sessionToken) {
				var configUrl:String = serverUrl + "/bigbluebutton/api/configXML?" + sessionToken;
			} else {
				var configUrl:String = serverUrl + "/bigbluebutton/api/configXML?a=" + new Date().time;
			}
			var fetcher:URLFetcher = new URLFetcher;
			fetcher.successSignal.add(onSuccess);
			fetcher.unsuccessSignal.add(onUnsuccess);
			fetcher.fetch(configUrl, urlRequest);
		}
		
		protected function onSuccess(data:Object, responseUrl:String, urlRequest:URLRequest, httpStatusCode:Number):void {
			successSignal.dispatch(new XML(data));
		}
		
		protected function onUnsuccess(reason:String):void {
			unsuccessSignal.dispatch(reason);
		}
	}
}
