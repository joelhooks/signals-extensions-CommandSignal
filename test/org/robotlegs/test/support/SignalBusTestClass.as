package org.robotlegs.test.support
{
	import org.osflash.signals.Signal;
	import org.robotlegs.core.ISignalCommand;

	public class SignalBusTestClass
	{
		public var commandCompleted:Signal = new Signal(ISignalCommand);
	}
}