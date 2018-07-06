package org.bigbluebutton.command {
	
	import org.bigbluebutton.core.VideoProfile;
	import org.bigbluebutton.model.IUserSession;
	
	import robotlegs.bender.bundles.mvcs.Command;
	
	public class CameraQualityCommand extends Command {
		
		[Inject]
		public var userSession:IUserSession;
		
		[Inject]
		public var cameraQualitySelected:VideoProfile;
		
		public function CameraQualityCommand() {
			super();
		}
		
		/**
		 * Set Camera Quality base on user selection
		 **/
		public override function execute():void {
			userSession.videoConnection.selectCameraQuality(cameraQualitySelected);
		}
	}
}
