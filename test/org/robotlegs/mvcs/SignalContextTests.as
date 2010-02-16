package org.robotlegs.mvcs
{
	import flash.display.Sprite;
	import flash.events.Event;
    import asunit.asserts.*;

    import org.robotlegs.core.ISignalCommandMap;
    import org.robotlegs.core.ISignalContext;

    public class SignalContextTests
    {
        private var signalContext:ISignalContext;

        [Before]
        public function setup():void
        {
            signalContext = new SignalContext();
        }

        [After]
        public function teardown():void
        {
            signalContext = null;
        }

        [Test]
        public function signal_context_has_SignalCommandMap():void
        {
            assertTrue( signalContext.signalCommandMap is ISignalCommandMap );
        }
		
        [Test]
        public function contextView_roundtrips_through_constructor():void
        {
			var contextView:Sprite = new Sprite();
			signalContext = new SignalContext(contextView);
			
            assertEquals(contextView, SignalContext(signalContext).contextView);
        }
		
        [Test]
        public function autoStartup_in_constructor_creates_listener_for_ADDED_TO_STAGE_on_contextView():void
        {
			var contextView:Sprite = new Sprite();
			var autoStartup:Boolean = false;
			signalContext = new SignalContext(contextView, autoStartup);
			
            assertTrue(contextView.hasEventListener(Event.ADDED_TO_STAGE));
        }
    }
}
