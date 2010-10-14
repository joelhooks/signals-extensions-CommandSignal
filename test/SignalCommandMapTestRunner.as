package 
{
	import asunit.core.TextCore;
	import org.robotlegs.test.suites.SignalCommandMapTestSuite;

	import flash.display.Sprite;

	[SWF(width='1000', height='800', backgroundColor='#333333', frameRate='31')]
	public class SignalCommandMapTestRunner extends Sprite
	{
        private var core:TextCore;

		public function SignalCommandMapTestRunner()
		{
            core = new TextCore();
			core.start(SignalCommandMapTestSuite, null, this);
		}
	}
}