package org.bigbluebutton.model {
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.rules.IMethodRule;
	import org.mockito.integrations.flexunit4.MockitoRule;
	import org.mockito.integrations.given;
	import org.mockito.integrations.mock;
	import org.mockito.integrations.verify;
	import org.osflash.signals.Signal;
	import robotlegs.bender.framework.api.IInjector;
	
	public class ConferenceParametersTest {
		
		[Rule]
		public var mockitoRule:IMethodRule = new MockitoRule();
		
		private var conferenceParameters:ConferenceParameters;
		
		[Mock(type = "org.osflash.signals.Signal")]
		private var changedSignal:Signal;
		
		[Before]
		public function setUp():void {
			conferenceParameters = new ConferenceParameters(changedSignal);
		}
		
		[Test]
		public function load():void {
			var obj:Object = new Object();
			obj.confname = "best meeting ever";
			obj.externMeetingID = "01189998819991197253";
			obj.fullname = "moss"
			obj.muteOnStart = "True";
			conferenceParameters.load(obj);
			verify().that(conferenceParameters.changedSignal.dispatch());
			assertEquals(conferenceParameters.meetingName, obj.confname);
			assertEquals(conferenceParameters.externMeetingID, obj.externMeetingID);
			assertEquals(conferenceParameters.username, obj.fullname);
			assertTrue(conferenceParameters.muteOnStart);
		}
	}
}
