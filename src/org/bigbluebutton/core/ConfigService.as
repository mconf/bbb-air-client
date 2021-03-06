package org.bigbluebutton.core {
	
	import flash.net.URLRequest;
	
	import org.bigbluebutton.core.util.URLFetcher;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	public class ConfigService {
		protected var _successSignal:Signal = new Signal();
		
		protected var _unsuccessSignal:Signal = new Signal();
		
		public function get successSignal():ISignal {
			return _successSignal;
		}
		
		public function get unsuccessSignal():ISignal {
			return _unsuccessSignal;
		}
		
		public function getConfig(serverUrl:String, sessionToken:String, urlRequest:URLRequest):void {
			var configUrl:String = serverUrl + "/bigbluebutton/api/configXML?a=" + new Date().time;
			if (sessionToken) {
				configUrl += "&sessionToken="+ sessionToken;
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
