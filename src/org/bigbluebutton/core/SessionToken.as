package org.bigbluebutton.core
{
	public class SessionToken {
		private static var sessionToken:String = null;
		
		public static function setSessionToken(value:String) {
			if (sessionToken == null) {
				sessionToken = value;
			}
		}
		
		public static function getSessionToken() {
			return sessionToken;
		}
	}
}