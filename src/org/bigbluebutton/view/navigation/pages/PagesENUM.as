package org.bigbluebutton.view.navigation.pages {
	
	import flash.utils.Dictionary;
	import org.bigbluebutton.view.navigation.pages.audiosettings.AudioSettingsView;
	import org.bigbluebutton.view.navigation.pages.camerasettings.CameraSettingsView;
	import org.bigbluebutton.view.navigation.pages.chat.ChatView;
	import org.bigbluebutton.view.navigation.pages.chatrooms.ChatRoomsView;
	import org.bigbluebutton.view.navigation.pages.deskshare.DeskshareView;
	import org.bigbluebutton.view.navigation.pages.disconnect.DisconnectPageView;
	import org.bigbluebutton.view.navigation.pages.exit.ExitPageView;
	import org.bigbluebutton.view.navigation.pages.guest.GuestPageView;
	import org.bigbluebutton.view.navigation.pages.locksettings.LockSettingsView;
	import org.bigbluebutton.view.navigation.pages.login.LoginPageView;
	import org.bigbluebutton.view.navigation.pages.login.openroom.OpenRoomView;
	import org.bigbluebutton.view.navigation.pages.login.openroom.recentrooms.RecentRoomsView;
	import org.bigbluebutton.view.navigation.pages.participants.ParticipantsView;
	import org.bigbluebutton.view.navigation.pages.presentation.PresentationView;
	import org.bigbluebutton.view.navigation.pages.profile.ProfileView;
	import org.bigbluebutton.view.navigation.pages.selectparticipant.SelectParticipantView;
	import org.bigbluebutton.view.navigation.pages.splitchat.SplitChatView;
	import org.bigbluebutton.view.navigation.pages.splitparticipants.SplitParticipantsView;
	import org.bigbluebutton.view.navigation.pages.splitsettings.SplitSettingsView;
	import org.bigbluebutton.view.navigation.pages.status.StatusView;
	import org.bigbluebutton.view.navigation.pages.userdetails.UserDetaisView;
	import org.bigbluebutton.view.navigation.pages.videochat.VideoChatView;
	
	public class PagesENUM {
		public static const PRESENTATION:String = "presentation";
		
		public static const LOGIN:String = "login";
		
		public static const PROFILE:String = "profile";
		
		public static const STATUS:String = "Status";
		
		public static const USER_DETAIS:String = "userdetais";
		
		public static const VIDEO_CHAT:String = "videochat";
		
		public static const CHATROOMS:String = "chatrooms";
		
		public static const CHAT:String = "chat";
		
		public static const PARTICIPANTS:String = "participants";
		
		public static const SELECT_PARTICIPANT:String = "selectparticipant";
		
		public static const DISCONNECT:String = "Disconnect";
		
		public static const GUEST:String = "Guest";
		
		public static const DESKSHARE:String = "Deskshare";
		
		public static const CAMERASETTINGS:String = "CameraSettings";
		
		public static const AUDIOSETTINGS:String = "AudioSettings";
		
		public static const EXIT:String = "Exit";
		
		public static const OPENROOM:String = "OpenRoom";
		
		public static const RECENTROOMS:String = "RecentRoom";
		
		public static const LOCKSETTINGS:String = "LockSettings";
		
		public static const SPLITSETTINGS:String = "SplitSettings";
		
		public static const SPLITPARTICIPANTS:String = "SplitParticipants";
		
		public static const SPLITCHAT:String = "SplitChat";
		
		/**
		 * Especials
		 */
		public static const LAST:String = "last";
		
		protected static function init():void {
			if (!dicInitiated) {
				dic[PRESENTATION] = PresentationView;
				dic[LOGIN] = LoginPageView;
				dic[PROFILE] = ProfileView;
				dic[STATUS] = StatusView;
				dic[USER_DETAIS] = UserDetaisView;
				dic[VIDEO_CHAT] = VideoChatView;
				dic[CHATROOMS] = ChatRoomsView;
				dic[CHAT] = ChatView;
				dic[PARTICIPANTS] = ParticipantsView;
				dic[SELECT_PARTICIPANT] = SelectParticipantView;
				dic[DISCONNECT] = DisconnectPageView;
				dic[GUEST] = GuestPageView;
				dic[DESKSHARE] = DeskshareView;
				dic[CAMERASETTINGS] = CameraSettingsView;
				dic[AUDIOSETTINGS] = AudioSettingsView;
				dic[EXIT] = ExitPageView;
				dic[OPENROOM] = OpenRoomView;
				dic[RECENTROOMS] = RecentRoomsView;
				dic[LOCKSETTINGS] = LockSettingsView;
				dic[SPLITSETTINGS] = SplitSettingsView;
				dic[SPLITPARTICIPANTS] = SplitParticipantsView;
				dic[SPLITCHAT] = SplitChatView;
				dicInitiated = true;
			}
		}
		
		protected static var dic:Dictionary = new Dictionary();
		
		protected static var dicInitiated:Boolean = false;
		
		public static function contain(name:String):Boolean {
			init();
			return (dic[name] != null)
		}
		
		public static function getClassfromName(name:String):Class {
			init();
			var klass:Class = null;
			if (contain(name)) {
				klass = dic[name];
			}
			return klass;
		}
	}
}
