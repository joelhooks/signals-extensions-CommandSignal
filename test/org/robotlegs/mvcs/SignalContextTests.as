package org.robotlegs.mvcs
{
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
    }
}