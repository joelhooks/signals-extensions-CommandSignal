package org.robotlegs.core {
import org.osflash.signals.ISignal;

public interface IGuardedSignalCommandMap extends ISignalCommandMap {
		
		/**
		 * Map a Command to an Event type, with Guards
		 * 
		 * <p>The <code>commandClass</code> must implement an execute() method</p>
		 * <p>The <code>guards</code> must be a Class which implements an approve() method</p>
		 * <p>or an <code>Array</code> of Classes which implements an approve() method</p>
		 *
		 * @param commandClass The Class to instantiate - must have an execute() method
		 * @param guards The Classes of the guard or guards to instantiate - must have an approve() method
		 * @param oneshot Unmap the Class after execution?
		 * 
		 * @throws org.robotlegs.base::ContextError
		*/
		function mapGuardedSignal(signal:ISignal, commandClass:Class, guards:*, oneshot:Boolean = false):void;
		
	}
}