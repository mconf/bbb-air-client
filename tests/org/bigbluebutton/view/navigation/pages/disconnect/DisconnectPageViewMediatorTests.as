package org.bigbluebutton.view.navigation.pages.disconnect {
	
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import mx.core.FlexGlobals;
	import org.bigbluebutton.model.UserSession;
	import org.bigbluebutton.model.UserUISession;
	import org.bigbluebutton.view.navigation.pages.PagesENUM;
	import org.bigbluebutton.view.navigation.pages.common.MenuButtonsView;
	import org.bigbluebutton.view.navigation.pages.disconnect.DisconnectPageView;
	import org.bigbluebutton.view.navigation.pages.disconnect.enum.DisconnectEnum;
	import org.bigbluebutton.view.navigation.pages.disconnect.enum.DisconnectType;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.async.Async;
	import org.flexunit.internals.namespaces.classInternal;
	import org.flexunit.rules.IMethodRule;
	import org.hamcrest.core.anyOf;
	import org.mockito.api.Matcher;
	import org.mockito.impl.matchers.MatcherFunctions;
	import org.mockito.impl.matchers.Matchers;
	import org.mockito.integrations.any;
	import org.mockito.integrations.argThat;
	import org.mockito.integrations.callOriginal;
	import org.mockito.integrations.flexunit4.MockitoRule;
	import org.mockito.integrations.flexunit4.PrepareMocks;
	import org.mockito.integrations.given;
	import org.mockito.integrations.mock;
	import org.mockito.integrations.notNull;
	import org.mockito.integrations.verify;
	import spark.components.Button;
	import spark.components.Label;
	import spark.components.SkinnableContainer;
	
	public class DisconnectPageViewMediatorTests {
		
		[Rule]
		public var mockitoRule:IMethodRule = new MockitoRule();
		
		private var disconnectPageViewMediator:DisconnectPageViewMediator;
		
		[Mock(type = "org.bigbluebutton.view.navigation.pages.disconnect.DisconnectPageView")]
		public var view:DisconnectPageView;
		
		[Mock(type = "spark.components.Button")]
		public var exitButton:Button;
		
		[Mock(type = "org.bigbluebutton.model.UserSession")]
		public var userSession:UserSession;
		
		[Mock(type = "org.bigbluebutton.model.UserUISession")]
		public var userUISession:UserUISession;
		
		[Mock(type = "Object")]
		public var topLevelApplication:Object;
		
		[Before]
		public function setUp():void {
			disconnectPageViewMediator = new DisconnectPageViewMediator();
			given(exitButton.addEventListener(any(), any())).will(callOriginal());
			given(view.exitButton).willReturn(exitButton);
			given(view.reconnectButton).willReturn(new Button());
			disconnectPageViewMediator.view = view;
			disconnectPageViewMediator.eventDispatcher = new EventDispatcher();
			disconnectPageViewMediator.userSession = userSession;
			disconnectPageViewMediator.userUISession = userUISession;
			//given(topLevelApplication.pageName).willReturn(new Label());
			//given(topLevelApplication.topActionBar).willReturn(new SkinnableContainer());
			//given(topLevelApplication.bottomMenu).willReturn(new MenuButtonsView());
			//given(topLevelApplication.applicationDPI).willReturn(new Number());
			//FlexGlobals.topLevelApplication = topLevelApplication;
			disconnectPageViewMediator.initialize();
			trace("asddsa " + disconnectPageViewMediator.view.exitButton);
		}
		
		[Test]
		public function changeStatus():void {
			disconnectPageViewMediator.changeConnectionStatus(DisconnectEnum.CONNECTION_STATUS_USER_KICKED_OUT);
			verify().that(disconnectPageViewMediator.view.currentState = DisconnectType.CONNECTION_STATUS_USER_KICKED_OUT_STRING);
			disconnectPageViewMediator.changeConnectionStatus(DisconnectEnum.CONNECTION_STATUS_CONNECTION_DROPPED);
			verify().that(disconnectPageViewMediator.view.currentState = DisconnectType.CONNECTION_STATUS_CONNECTION_DROPPED_STRING);
			disconnectPageViewMediator.changeConnectionStatus(DisconnectEnum.CONNECTION_STATUS_MEETING_ENDED);
			verify().that(disconnectPageViewMediator.view.currentState = DisconnectType.CONNECTION_STATUS_MEETING_ENDED_STRING);
		}
		
		[Test(async)]
		public function reconnect():void {
			verify().that(exitButton.addEventListener);
			given(exitButton.dispatchEvent(new MouseEvent(MouseEvent.CLICK))).will(callOriginal());
			exitButton.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			//runAfterTimeOut(this, 2800, function():void {
			//	verify().that(disconnectPageViewMediator.userUISession.pushPage(PagesENUM.LOGIN));
			//});
		}
		
		public function runAfterTimeOut(testClass:Object, time:Number, toRun:Function) {
			var runWrapper:Function = function(... args):void {toRun();};
			var t:Timer = new Timer(time);
			Async.handleEvent(testClass, t, TimerEvent.TIMER, runWrapper, time + 200);
			t.start();
		}
	}
}
