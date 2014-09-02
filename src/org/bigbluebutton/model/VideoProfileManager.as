package org.bigbluebutton.model
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.core.FlexGlobals;
	import mx.utils.URLUtil;
	
	import org.bigbluebutton.command.JoinMeetingCommand;
	import org.bigbluebutton.core.ILoginService;
	import org.bigbluebutton.core.VideoProfile;
		
	public class VideoProfileManager extends EventDispatcher {
		
		public static const PROFILES_XML:String = "client/conf/profiles.xml";
		public static const DEFAULT_FALLBACK_LOCALE:String = "en_US";
		private var _profiles:Array = new Array();
		
		private var _profileXML:XML;
		
		public function VideoProfileManager(profileXML:XML)
		{
			_profileXML = profileXML;
		}
	/*	
		public function loadProfiles():void {
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, handleComplete);
			var date:Date = new Date();
			//var localeReqURL:String = buildRequestURL() + "?a=" + date.time;
			////////////////////////////////////////////////////////////////////
			//var JoinMeeting:JoinMeetingCommand;
			//var url:String = JoinMeeting.url;
			//var parser:URLParser = new URLParser(url);
			//return parser.protocol + "://" + parser.host + ":" + parser.port;
			/////////////////////////////////////////////////////////////////////
			
			var localeReqURL:String = "http://143.54.10.151/client/conf/profiles.xml";
			trace("VideoProfileManager::loadProfiles [" + localeReqURL + "]");
			urlLoader.load(new URLRequest(localeReqURL));
		}       
		
		private function buildRequestURL():String {
			var swfURL:String = FlexGlobals.topLevelApplication.url;
			var protocol:String = URLUtil.getProtocol(swfURL);
			var serverName:String = URLUtil.getServerNameWithPort(swfURL);
			return protocol + "://" + serverName + "/" + PROFILES_XML;
		} 
		
		private function handleComplete(e:Event):void{
			trace("VideoProfileManager::handleComplete [" + new XML(e.target.data) + "]");
			
			// first clear the array
			_profiles.splice(0);
			
			var profiles:XML = new XML(e.target.data);
			var fallbackLocale:String = profiles.@fallbackLocale != undefined? profiles.@fallbackLocale.toString(): DEFAULT_FALLBACK_LOCALE;
			for each (var profile:XML in profiles.children()) {
				_profiles.push(new VideoProfile(profile, fallbackLocale));
			}
		} */
		
		public function getProfileTypes():void{
			// first clear the array
			_profiles.splice(0);
						
			var fallbackLocale:String = _profileXML.@fallbackLocale != undefined? _profileXML.@fallbackLocale.toString(): DEFAULT_FALLBACK_LOCALE;
			for each (var profile:XML in _profileXML.children()) {
				_profiles.push(new VideoProfile(profile, fallbackLocale));
			}
		}
		
		public function get profiles():Array {
			if (_profiles.length > 0) {
				return _profiles;
			} else {
				return [ fallbackVideoProfile ];
			}
		}
		
		public function getVideoProfileById(id:String):VideoProfile {
			for each (var profile:VideoProfile in _profiles) {
				if (profile.id == id) {
					return profile;
				}
			}
			return null;
		}

		public function get defaultVideoProfile():VideoProfile {
			for each (var profile:VideoProfile in _profiles) {
				if (profile.defaultProfile) {
					return profile;
				}
			}
			if (_profiles.length > 0) {
				return _profiles[0];
			} else {
				return null;
			}
		}
			
		public function get fallbackVideoProfile():VideoProfile {
			return new VideoProfile(
				<profile id="4L7344ZoBYGTocbHOIvzXsrGiBGoohFv" default="true">
					<locale>
						<en_US>Fallback profile</en_US>
					</locale>
					<width>320</width>
					<height>240</height>
					<keyFrameInterval>5</keyFrameInterval>
					<modeFps>10</modeFps>
					<qualityBandwidth>0</qualityBandwidth>
					<qualityPicture>90</qualityPicture>
					<enableH264>true</enableH264>
					<h264Level>2.1</h264Level>
					<h264Profile>main</h264Profile>
				</profile>
				, DEFAULT_FALLBACK_LOCALE);
		}
		
		
		public function getProfileWithLowerResolution():VideoProfile {
			var lower:VideoProfile = this.fallbackVideoProfile;
			
			for each (var profile:VideoProfile in _profiles) {
				if (((profile.width)*(profile.height)) < ((lower.width)*(lower.height))) {
					lower = profile;
				}
			}
			return lower;
		}
		
		
	} 
}

