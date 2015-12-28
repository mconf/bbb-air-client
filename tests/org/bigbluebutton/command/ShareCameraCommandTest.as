package org.bigbluebutton.command {
	
	import flash.media.Camera;
	import org.bigbluebutton.core.IUsersService;
	import org.bigbluebutton.core.IVideoConnection;
	import org.bigbluebutton.core.VideoProfile;
	import org.bigbluebutton.model.IUserSession;
	import org.bigbluebutton.model.User;
	import org.bigbluebutton.model.UserList;
	import org.flexunit.rules.IMethodRule;
	import org.mockito.integrations.any;
	import org.mockito.integrations.callOriginal;
	import org.mockito.integrations.flexunit4.MockitoRule;
	import org.mockito.integrations.given;
	import org.mockito.integrations.verify;
	
	public class ShareCameraCommandTest {
		
		[Rule]
		public var mockitoRule:IMethodRule = new MockitoRule();
		
		private var shareCameraCommand:ShareCameraCommand;
		
		[Mock(type = "org.bigbluebutton.model.IUserSession")]
		public var userSession:IUserSession;
		
		[Mock(type = "org.bigbluebutton.core.IUsersService")]
		public var usersService:IUsersService;
		
		[Mock(type = "org.bigbluebutton.core.IVideoConnection")]
		public var videoConnection:IVideoConnection;
		
		[Mock(type = "org.bigbluebutton.model.UserList")]
		public var userList:UserList;
		
		[Before]
		public function setUp():void {
			shareCameraCommand = new ShareCameraCommand();
			shareCameraCommand.userSession = userSession;
			shareCameraCommand.usersService = usersService;
			given(userSession.videoConnection).willReturn(videoConnection);
			given(userSession.videoConnection.camera).willReturn(new Camera());
			given(userSession.videoConnection.selectedCameraQuality).willReturn(new VideoProfile(new XML(), null));
			given(userSession.userList).willReturn(userList);
			given(userList.me).willReturn(new User());
		}
		
		[Test]
		public function enableCamera():void {
			shareCameraCommand.enabled = true;
			shareCameraCommand.execute();
			verify().that(usersService.addStream(any(), any()));
			verify().that(videoConnection.startPublishing(any(), any()));
		}
		
		[Test]
		public function disableCamera():void {
			shareCameraCommand.enabled = false;
			shareCameraCommand.execute();
			verify().that(usersService.removeStream(any(), any()));
			verify().that(videoConnection.stopPublishing());
		}
	}
}
