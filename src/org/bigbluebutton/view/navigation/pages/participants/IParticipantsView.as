package org.bigbluebutton.view.navigation.pages.participants {
	
	import spark.components.Button;
	import spark.components.List;
	import spark.components.supportClasses.SkinnableComponent;
	
	import org.bigbluebutton.core.view.IView;
	
	public interface IParticipantsView extends IView {
		function get list():List;
		function get guestsList():List;
		function get allGuests():SkinnableComponent;
		function get allowAllButton():Button;
		function get denyAllButton():Button;
	}
}
