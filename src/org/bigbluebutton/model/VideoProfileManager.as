package org.bigbluebutton.model {
	
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
		
		public function VideoProfileManager(profileXML:XML) {
			_profileXML = profileXML;
		}
		
		public function getProfileTypes():void {
			// first clear the array
			_profiles.splice(0);
			var fallbackLocale:String = _profileXML.@fallbackLocale != undefined ? _profileXML.@fallbackLocale.toString() : DEFAULT_FALLBACK_LOCALE;
			for each (var profile:XML in _profileXML.children()) {
				_profiles.push(new VideoProfile(profile, fallbackLocale));
			}
		}
		
		public function get profiles():Array {
			if (_profiles.length > 0) {
				return _profiles;
			} else {
				return [fallbackVideoProfile];
			}
		}
		
		public function getVideoProfileById(id:String):VideoProfile {
			for each (var profile:VideoProfile in _profiles) {
				if (profile.id == id) {
					return profile;
				}
			}
			return fallbackVideoProfile;
		}
		
		public function getVideoProfileByStreamName(streamName:String):VideoProfile {
			var pattern:RegExp = new RegExp("([a-z]+)-([A-Za-z0-9_]+)-\\d+", "");
			if (pattern.test(streamName)) {
				var profileID:String = pattern.exec(streamName)[1]
				for each (var profile:VideoProfile in _profiles) {
					if (profile.id == profileID) {
						return profile;
					}
				}
				return fallbackVideoProfile;
			} else {
				return fallbackVideoProfile;
			}
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
				return fallbackVideoProfile;
			}
		}
		
		public function get fallbackVideoProfile():VideoProfile {
			return new VideoProfile(
				<profile id="160x120" default="true">
					<locale>
						<en_US>Fallback profile</en_US>
					</locale>
					<width>160</width>
					<height>120</height>
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
			if (_profiles.lenth <= 0) {
				return fallbackVideoProfile;
			}
			var lower:VideoProfile = _profiles[0];
			for each (var profile:VideoProfile in _profiles) {
				if (((profile.width) * (profile.height)) < ((lower.width) * (lower.height))) {
					lower = profile;
				}
			}
			return lower;
		}
	}
}
