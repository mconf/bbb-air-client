package org.bigbluebutton.command {
	
	import org.bigbluebutton.model.IUserUISession;
	import org.bigbluebutton.view.navigation.pages.PagesENUM;
	import org.bigbluebutton.view.navigation.pages.TransitionAnimationENUM;
	import org.flexunit.rules.IMethodRule;
	import org.mockito.integrations.flexunit4.MockitoRule;
	import org.mockito.integrations.verify;
	
	public class NavigateToCommandTest {
		
		[Rule]
		public var mockitoRule:IMethodRule = new MockitoRule();
		
		private var navigateToCommand:NavigateToCommand;
		
		[Mock(type = "org.bigbluebutton.model.IUserUISession")]
		public var userUISession:IUserUISession;
		
		[Before]
		public function setUp():void {
			navigateToCommand = new NavigateToCommand();
			navigateToCommand.userUISession = userUISession;
		}
		
		[Test]
		public function navigateToLastPage():void {
			navigateToCommand.to = PagesENUM.LAST;
			navigateToCommand.transitionAnimation = TransitionAnimationENUM.APPEAR;
			navigateToCommand.execute();
			verify().that(userUISession.popPage(TransitionAnimationENUM.APPEAR));
		}
		
		[Test]
		public function navigateTo():void {
			navigateToCommand.to = "some page";
			var details:Object = new Object();
			details.aProperty = "property 1";
			navigateToCommand.details = details;
			navigateToCommand.transitionAnimation = TransitionAnimationENUM.SLIDE_LEFT;
			navigateToCommand.execute();
			verify().that(userUISession.pushPage("some page", details, TransitionAnimationENUM.SLIDE_LEFT));
		}
	}
}
