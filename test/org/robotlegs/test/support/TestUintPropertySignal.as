package org.robotlegs.test.support
{
    import org.osflash.signals.Signal;

    public class TestUintPropertySignal extends Signal
	{
		public function TestUintPropertySignal()
		{
			super(uint,TestCommandProperty);
		}
	}
}