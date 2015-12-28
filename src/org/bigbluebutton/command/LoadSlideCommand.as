package org.bigbluebutton.command {
	
	import org.bigbluebutton.core.IWhiteboardService;
	import org.bigbluebutton.core.LoadSlideService;
	import org.bigbluebutton.model.presentation.Slide;
	import robotlegs.bender.bundles.mvcs.Command;
	
	public class LoadSlideCommand extends Command {
		
		[Inject]
		public var slide:Slide;
		
		[Inject]
		public var presentationID:String;
		
		[Inject]
		public var whiteboardService:IWhiteboardService;
		
		private var _loadSlideService:LoadSlideService;
		
		public function LoadSlideCommand() {
			super();
		}
		
		override public function execute():void {
			if (slide != null) {
				_loadSlideService = new LoadSlideService(slide);
				whiteboardService.getAnnotationHistory(presentationID, slide.slideNumber);
			} else {
				trace("LoadSlideCommand: requested slide is null and cannot be loaded");
			}
		}
	}
}
