package org.robotlegs.mvcs
{
	import org.osflash.signals.Signal;
	import org.robotlegs.core.IAsyncSignalCommand;
	import org.robotlegs.core.ISignalCommandMap;

	public class AsyncSignalCommand extends SignalCommand implements IAsyncSignalCommand
	{
		protected var _completed:Signal;

		protected var _failed:Signal;

		public function AsyncSignalCommand():void
		{
		}
		
		[Inject]
		override public function set signalCommandMap(value:ISignalCommandMap):void
		{
			// This is extremely uncommon, but just in case there's a use-case
			// for switching signalCommandMaps.
			if (_signalCommandMap)
			{
				_signalCommandMap.release(this);
			}
			
			super.signalCommandMap = value;

			// Detain upon setting signalCommandMap to avoid the use of [PostConstruct].
			// We don't detain upon execute() so you don't have to remember to call
			// super.execute() in every override.
			if (_signalCommandMap)
			{
				_signalCommandMap.detain(this);
			}
		}

		protected function release():void
		{
			// ensure the command is garbage collected
			signalCommandMap.release(this);
			completed.removeAll();
			failed.removeAll();
		}

		public function get completed():Signal
		{
			return _completed ||= new Signal();
		}

		public function get failed():Signal
		{
			// The signal's value class is Object so you're not forced to dispatch
			// a specific type of error. You can use just a String message or
			// an Error object with extra data.
			return _failed ||= new Signal(Object);
		}
		
		protected function dispatchComplete():void
		{
			completed.dispatch();
			release();
		}
		
		protected function dispatchFail(error:*):void
		{
			failed.dispatch(error);
			release();
		}
	}
}