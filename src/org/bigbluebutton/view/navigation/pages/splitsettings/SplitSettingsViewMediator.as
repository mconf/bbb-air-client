package org.bigbluebutton.view.navigation.pages.splitsettings {
	
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;
	import mx.core.FlexGlobals;
	import mx.events.ItemClickEvent;
	import mx.resources.ResourceManager;
	import org.bigbluebutton.command.ClearUserStatusSignal;
	import org.bigbluebutton.command.MoodSignal;
	import org.bigbluebutton.core.IUsersService;
	import org.bigbluebutton.model.IConferenceParameters;
	import org.bigbluebutton.model.IUserSession;
	import org.bigbluebutton.model.IUserUISession;
	import org.bigbluebutton.model.User;
	import org.bigbluebutton.model.UserList;
	import org.bigbluebutton.view.navigation.pages.PagesENUM;
	import robotlegs.bender.bundles.mvcs.Mediator;
	import spark.events.IndexChangeEvent;
	
	public class SplitSettingsViewMediator extends Mediator {
		
		[Inject]
		public var view:ISplitSettingsView;
		
		override public function initialize():void {
			eventDispatcher.addEventListener(SplitViewEvent.CHANGE_VIEW, changeView);
		}
		
		private function changeView(event:SplitViewEvent) {
			view.settingsNavigator.pushView(event.view);
		}
		
		override public function destroy():void {
			super.destroy();
			eventDispatcher.removeEventListener(SplitViewEvent.CHANGE_VIEW, changeView);
			view.dispose();
			view = null;
		}
	}
}
