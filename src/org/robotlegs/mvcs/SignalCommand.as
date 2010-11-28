package org.robotlegs.mvcs
{
	import org.robotlegs.core.ISignalCommand;
	import org.robotlegs.core.ISignalCommandMap;

	public class SignalCommand implements ISignalCommand
	{
		protected var _signalCommandMap:ISignalCommandMap;
		
		public function SignalCommand()
		{

		}
		
		public function get signalCommandMap():ISignalCommandMap
		{
			return _signalCommandMap;
		}
		
		[Inject]
		public function set signalCommandMap(value:ISignalCommandMap):void
		{
			_signalCommandMap = value;
		}

		public function execute():void
		{

		}
	}
}