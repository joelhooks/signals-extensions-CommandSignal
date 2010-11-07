package org.robotlegs.test.support
{
    import org.osflash.signals.Signal;

    public class TestIntPropertySignal extends Signal
	{
		public function TestIntPropertySignal()
		{
			super(int,TestCommandProperty);
		}
	}
}