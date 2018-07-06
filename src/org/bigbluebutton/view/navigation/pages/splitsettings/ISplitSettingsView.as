package org.bigbluebutton.view.navigation.pages.splitsettings {
	
	import spark.components.ViewNavigator;
	
	import org.bigbluebutton.core.view.IView;
	
	public interface ISplitSettingsView extends IView {
		function get settingsNavigator():ViewNavigator;
		function get leftMenu():ViewNavigator;
	}
}
