package org.bigbluebutton {
	
	import org.bigbluebutton.command.AuthenticationCommandTest;
	import org.bigbluebutton.command.ChangeRoleCommandTest;
	import org.bigbluebutton.command.ClearUserStatusCommandTest;
	import org.bigbluebutton.command.ConnectCommandTest;
	import org.bigbluebutton.command.DisconnectUserCommandTest;
	import org.bigbluebutton.command.JoinMeetingCommandTest;
	import org.bigbluebutton.command.LoadSlideCommandTest;
	import org.bigbluebutton.command.MoodCommandTest;
	import org.bigbluebutton.command.NavigateToCommandTest;
	import org.bigbluebutton.command.PresenterCommand;
	import org.bigbluebutton.command.PresenterCommandTest;
	import org.bigbluebutton.command.ShareCameraCommandTest;
	import org.bigbluebutton.command.ShareMicrophoneCommandTest;
	import org.bigbluebutton.model.ConferenceParametersTest;
	import org.bigbluebutton.model.ConfigTest;
	import org.bigbluebutton.model.UserListTest;
	import org.bigbluebutton.model.UserTest;
	import org.bigbluebutton.ui.MicButtonConfigTest;
	import org.bigbluebutton.view.navigation.pages.disconnect.DisconnectPageViewMediatorTest;
	
	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class AppTestSuite {
		//model
		public var userTest:UserTest;
		
		public var userListTest:UserListTest;
		
		public var conferenceParametersTest:ConferenceParametersTest;
		
		public var configTest:ConfigTest;
		
		//command tests
		public var authenticationCommandTest:AuthenticationCommandTest;
		
		public var changeRoleCommandTest:ChangeRoleCommandTest;
		
		public var clearUserStatusCommandTest:ClearUserStatusCommandTest;
		
		public var connectCommandTest:ConnectCommandTest;
		
		public var disconnectUserCommandTest:DisconnectUserCommandTest;
		
		public var navigateToCommandTest:NavigateToCommandTest;
		
		public var shareMicrophoneCommandTest:ShareMicrophoneCommandTest;
		
		public var joinMeetingCommandTest:JoinMeetingCommandTest;
		
		public var loadSlideCommandTest:LoadSlideCommandTest;
		
		public var moodCommandTest:MoodCommandTest;
		
		public var presenterCommandTest:PresenterCommandTest;
		
		public var shareCameraCommandTest:ShareCameraCommandTest;
		
		//pages disconnect
		public var disconnectPageViewMediatorTest:DisconnectPageViewMediatorTest;
	}
}
