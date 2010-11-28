package org.robotlegs.core
{
	import org.osflash.signals.Signal;

	public interface ICompositeSignalCommand extends IAsyncSignalCommand
	{
		function addCommand(commandClazz:Class):Class;
	}
}