package org.bigbluebutton.model {
	
	import org.flexunit.asserts.assertEquals;
	
	public class ConfigTest {
		private var testXML:XML = <config>
				<localeversion suppressWarning="false">0.9.0</localeversion>
				<version>28</version>
				<help url="http://143.54.10.103/help.html"/>
				<javaTest url="http://143.54.10.103/testjava.html"/>
				<porttest host="143.54.10.103" application="video/portTest" timeout="10000"/>
				<bwMon server="143.54.10.103" application="video/bwTest"/>
				<application uri="rtmp://143.54.10.103/bigbluebutton" host="http://143.54.10.103/bigbluebutton/api/enter"/>
				<language userSelectionEnabled="true"/>
				<skinning enabled="true" url="http://143.54.10.103/client/branding/css/BBBDefault.css.swf?v=28"/>
				<branding logo="logo.png" copyright="© 2015" background=""/>
				<shortcutKeys showButton="true"/>
				<browserVersions chrome="41" firefox="36" flash="17" java="1.7.0_51"/>
				<layout showLogButton="false" defaultLayout="bbb.layout.name.defaultlayout" showToolbar="true" showFooter="true" showMeetingName="true" showHelpButton="true" showLogoutWindow="true" showLayoutTools="true" confirmLogout="true" showNetworkMonitor="true" showRecordingNotification="true"/>
				<meeting muteOnStart="false"/>
				<lock disableCamForLockedUsers="false" disableMicForLockedUsers="false" disablePrivateChatForLockedUsers="false" disablePublicChatForLockedUsers="false" lockLayoutForLockedUsers="false" lockOnJoin="true" lockOnJoinConfigurable="false"/>
				<modules>
					<module name="ChatModule" url="http://143.54.10.103/client/ChatModule.swf?v=28" uri="rtmp://143.54.10.103/bigbluebutton" dependsOn="UsersModule" privateEnabled="true" fontSize="12" position="top-right" baseTabIndex="701" colorPickerIsVisible="false"/>
					<module name="UsersModule" url="http://143.54.10.103/client/UsersModule.swf?v=28" uri="rtmp://143.54.10.103/bigbluebutton" allowKickUser="true" enableRaiseHand="true" enableSettingsButton="true" baseTabIndex="301"/>
					<module name="DeskShareModule" url="http://143.54.10.103/client/DeskShareModule.swf?v=28" uri="rtmp://143.54.10.103/deskShare" showButton="true" autoStart="false" autoFullScreen="false" baseTabIndex="201"/>
					<module name="PhoneModule" url="http://143.54.10.103/client/PhoneModule.swf?v=28" uri="rtmp://143.54.10.103/sip" autoJoin="true" listenOnlyMode="true" forceListenOnly="false" presenterShareOnly="false" skipCheck="false" showButton="true" enabledEchoCancel="true" useWebRTCIfAvailable="true" showPhoneOption="false" showMicrophoneHint="true" echoTestApp="9196" dependsOn="UsersModule"/>
					<module name="VideoconfModule" url="http://143.54.10.103/client/VideoconfModule.swf?v=28" uri="rtmp://143.54.10.103/video" dependson="UsersModule" presenterShareOnly="false" controlsForPresenter="false" autoStart="false" skipCamSettingsCheck="false" showButton="true" showCloseButton="true" publishWindowVisible="true" viewerWindowMaxed="false" viewerWindowLocation="top" smoothVideo="false" applyConvolutionFilter="false" convolutionFilter="-1, 0, -1, 0, 6, 0, -1, 0, -1" filterBias="0" filterDivisor="4" displayAvatar="false" focusTalking="false" glowColor="0x4A931D" glowBlurSize="30.0" priorityRatio="0.67"/>
					<module name="WhiteboardModule" url="http://143.54.10.103/client/WhiteboardModule.swf?v=28" uri="rtmp://143.54.10.103/bigbluebutton" dependsOn="PresentModule" baseTabIndex="601" whiteboardAccess="presenter" keepToolbarVisible="false"/>
					<module name="PresentModule" url="http://143.54.10.103/client/PresentModule.swf?v=28" uri="rtmp://143.54.10.103/bigbluebutton" host="http://143.54.10.103" showPresentWindow="true" showWindowControls="true" openExternalFileUploadDialog="false" dependsOn="UsersModule" baseTabIndex="501" maxFileSize="30"/>
					<module name="LayoutModule" url="http://143.54.10.103/client/LayoutModule.swf?v=28" uri="rtmp://143.54.10.103/bigbluebutton" layoutConfig="http://143.54.10.103/client/conf/layout.xml" enableEdit="true"/>
					<module name="SharedNotesModule" url="SharedNotesModule.swf?v=28" uri="rtmp://143.54.10.103/bigbluebutton" refreshDelay="500" enableMultipleNotes="true" dependsOn="UsersModule" position="bottom-left"/>
				</modules>
			</config>
		
		private var config:Config;
		
		[Before]
		public function setUp():void {
			config = new Config(testXML);
		}
		
		[Test]
		public function help():void {
			assertEquals(config.help.url, "http://143.54.10.103/help.html");
		}
		
		[Test]
		public function javaTest():void {
			assertEquals(config.javaTest.url, "http://143.54.10.103/testjava.html");
		}
		
		[Test]
		public function locale():void {
			assertEquals(config.locale.version, "0.9.0");
		}
		
		[Test]
		public function version():void {
			assertEquals(config.version, "28");
		}
		
		[Test]
		public function porttest():void {
			assertEquals(config.porttest.host, "143.54.10.103");
			assertEquals(config.porttest.application, "video/portTest");
		}
		
		[Test]
		public function application():void {
			assertEquals(config.application.uri, "rtmp://143.54.10.103/bigbluebutton");
			assertEquals(config.application.host, "http://143.54.10.103/bigbluebutton/api/enter");
		}
		
		[Test]
		public function language():void {
			assertEquals(config.language.userSelectionEnabled, true);
		}
		
		[Test]
		public function shortcutKeys():void {
			assertEquals(config.shortcutKeys.showButton, true);
		}
		
		[Test]
		public function skinning():void {
			assertEquals(config.skinning.enabled, true);
			assertEquals(config.skinning.url, "http://143.54.10.103/client/branding/css/BBBDefault.css.swf?v=28");
		}
		
		[Test]
		public function layout():void {
			assertEquals(config.layout, new XML(testXML.layout.toXMLString()));
		}
		
		[Test]
		public function isModulePresent():void {
			assertEquals(config.isModulePresent("ChatModule"), true);
			assertEquals(config.isModulePresent("PresentModule"), true);
			assertEquals(config.isModulePresent("AnotherModule"), false);
		}
		
		[Test]
		public function getConfigFor():void {
			assertEquals(config.getConfigFor("ChatModule"), new XML(<module name="ChatModule" url="http://143.54.10.103/client/ChatModule.swf?v=28" uri="rtmp://143.54.10.103/bigbluebutton" dependsOn="UsersModule" privateEnabled="true" fontSize="12" position="top-right" baseTabIndex="701" colorPickerIsVisible="false"/>));
		}
	}
}
