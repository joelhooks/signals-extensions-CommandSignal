package 
{
	import flash.display.Sprite;
	import org.flexunit.internals.TraceListener;
	import org.flexunit.listeners.CIListener;
	import org.flexunit.runner.FlexUnitCore;
	import org.robotlegs.test.suites.SignalCommandMapTestSuite;
	
	[SWF(width="200", height="200", backgroundColor="#000000")]
	public class SignalCommandMapTest extends Sprite
	{
        private var core:FlexUnitCore;

        public function SignalCommandMapTest()
        {
            core = new FlexUnitCore();
			core.visualDisplayRoot = this;
            core.addListener(new CIListener());
            core.addListener(new TraceListener());
            core.run(SignalCommandMapTestSuite);
        }		
	}
}