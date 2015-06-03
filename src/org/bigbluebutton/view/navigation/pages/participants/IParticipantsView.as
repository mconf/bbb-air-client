package org.bigbluebutton.view.navigation.pages.participants {
	
	import mx.collections.IList;
	import org.bigbluebutton.core.view.IView;
	import org.osflash.signals.ISignal;
	import spark.components.Button;
	import spark.components.List;
	import spark.components.supportClasses.SkinnableComponent;
	
	public interface IParticipantsView extends IView {
		function get list():List;
		function get guestsList():List;
		function get allGuests():SkinnableComponent;
		function get allowAllButton():Button;
		function get denyAllButton():Button;
	}
}
