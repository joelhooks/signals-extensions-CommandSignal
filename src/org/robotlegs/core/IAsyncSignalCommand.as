package org.robotlegs.core
{
	import org.osflash.signals.Signal;

	public interface IAsyncSignalCommand extends ISignalCommand
	{
		function get completed():Signal;
		function get failed():Signal;
	}
}