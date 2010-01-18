package org.robotlegs.test.support
{
	import org.osflash.signals.Signal;
	
	public class TestTwoPropertySignal extends Signal
	{
		
		public function TestTwoPropertySignal()
		{
			super(TestCommandProperty, TestCommandProperty2);
		}
		
	}
}
