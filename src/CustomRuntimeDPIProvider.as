package {
	
	import flash.system.Capabilities;
	
	import mx.core.DPIClassification;
	import mx.core.RuntimeDPIProvider;
	
	public class CustomRuntimeDPIProvider extends RuntimeDPIProvider {
		public function CustomRuntimeDPIProvider() {
		}
		
		override public function get runtimeDPI():Number {
			if (Capabilities.screenDPI < 200) {
				return DPIClassification.DPI_160;
			}
			if (Capabilities.screenDPI <= 280) {
				return DPIClassification.DPI_240;
			}
			if (Capabilities.screenDPI <= 400) {
				return DPIClassification.DPI_320;
			}
			if (Capabilities.screenDPI <= 560) {
				return DPIClassification.DPI_480;
			}
			return DPIClassification.DPI_640;
		}
	}
}
