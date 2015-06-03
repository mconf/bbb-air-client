package org.bigbluebutton.model {
	
	import mx.collections.ArrayCollection;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	import robotlegs.bender.extensions.signalCommandMap.api.ISignalCommandMap;
	import spark.collections.Sort;
	
	public class GuestList {
		private var _guests:ArrayCollection;
		
		[Bindable]
		public function get guests():ArrayCollection {
			return _guests;
		}
		
		private function set guests(value:ArrayCollection):void {
			_guests = value;
		}
		
		public function GuestList() {
			_guests = new ArrayCollection();
		}
		
		/**
		 * Dispatched when all guests are added
		 */
		private var _allGuestsAddedSignal:Signal = new Signal();
		
		public function get allGuestsAddedSignal():ISignal {
			return _allGuestsAddedSignal;
		}
		
		/**
		 * Dispatched when a guest is added
		 */
		private var _guestAddedSignal:Signal = new Signal();
		
		public function get guestAddedSignal():ISignal {
			return _guestAddedSignal;
		}
		
		/**
		 * Dispatched when a participant is removed
		 */
		private var _guestRemovedSignal:Signal = new Signal();
		
		public function get guestRemovedSignal():ISignal {
			return _guestRemovedSignal;
		}
		
		/**
		 * Dispatched when a guests' property have been changed
		 */
		private var _guestChangeSignal:Signal = new Signal();
		
		public function get guestChangeSignal():ISignal {
			return _guestChangeSignal;
		}
		
		/**
		 * Get a guest based on a GuestId
		 *
		 * @param GuestId
		 */
		public function getGuestByGuestId(guestId:String):Guest {
			if (guests != null) {
				for each (var guest:Guest in guests) {
					if (guest.userID == guestId) {
						return guest;
					}
				}
			}
			return null;
		}
		
		public function addGuest(newguest:Guest):void {
			trace("Adding new guest [" + newguest.userID + "]");
			if (!hasGuest(newguest.userID)) {
				_guests.addItem(newguest);
				_guests.refresh();
				guestAddedSignal.dispatch(newguest);
			}
		}
		
		public function hasGuest(guestID:String):Boolean {
			var p:Object = getGuestIndex(guestID);
			if (p != null) {
				return true;
			}
			return false;
		}
		
		public function getGuest(guestID:String):Guest {
			var p:Object = getGuestIndex(guestID);
			if (p != null) {
				return p.participant as Guest;
			}
			return null;
		}
		
		public function removeGuest(guestID:String):void {
			var p:Object = getGuestIndex(guestID);
			if (p != null) {
				var guest:Guest = p.participant as Guest;
				trace("removing guest[" + guest.name + "," + guest.userID + "]");
				_guests.removeItemAt(p.index);
				_guests.refresh();
				guestRemovedSignal.dispatch(guestID);
			}
		}
		
		/**
		 * Get the an object containing the index and Guest object for a specific guestid
		 * @param guestID
		 * @return null if guestID id not found
		 *
		 */
		private function getGuestIndex(guestID:String):Object {
			var aGuest:Guest;
			for (var i:int = 0; i < _guests.length; i++) {
				aGuest = _guests.getItemAt(i) as Guest;
				0
				if (aGuest.userID == guestID) {
					return {index: i, participant: aGuest};
				}
			}
			return null;
		}
	}
}
