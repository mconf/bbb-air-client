package org.bigbluebutton.core {
	import flash.net.URLRequest;
	import org.bigbluebutton.core.util.URLFetcher;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	public class ApiService {
		protected var _successSignal:Signal = new Signal();
		
		protected var _unsuccessSignal:Signal = new Signal();
		
		public function get successSignal():ISignal {
			return _successSignal;
		}
		
		public function get unsuccessSignal():ISignal {
			return _unsuccessSignal;
		}
		
		public function getApi(serverUrl:String, urlRequest:URLRequest):void {
			var apiUrl:String = serverUrl + "/bigbluebutton/api";
			var fetcher:URLFetcher = new URLFetcher;
			fetcher.successSignal.add(onSuccess);
			fetcher.unsuccessSignal.add(onUnsuccess);
			fetcher.fetch(apiUrl, urlRequest);
		}
		
		protected function onSuccess(data:Object, responseUrl:String, urlRequest:URLRequest, httpStatusCode:Number):void {
			if (httpStatusCode == 200) {
				var xml:XML = new XML(data);
				if (xml.returncode == "SUCCESS") {
					successSignal.dispatch(xml.version, urlRequest, responseUrl);
				} else {
					onUnsuccess(xml.returncode);
				}
			} else {
				onUnsuccess("INVALID_RETURN_CODE");
			}
		}
		
		protected function onUnsuccess(reason:String):void {
			unsuccessSignal.dispatch(reason);
		}
	}
}
