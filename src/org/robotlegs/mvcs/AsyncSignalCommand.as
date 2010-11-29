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
			if (_signalCommandMap)
			{
				_signalCommandMap.release(this);
			}
			
			super.signalCommandMap = value;

			if (_signalCommandMap)
			{
				_signalCommandMap.detain(this);
			}
		}

		protected function release():void
		{
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