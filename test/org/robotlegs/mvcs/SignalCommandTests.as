package org.robotlegs.mvcs
{
    import org.flexunit.asserts.assertTrue;
    import org.robotlegs.adapters.SwiftSuspendersInjector;
    import org.robotlegs.base.SignalCommandMap;
    import org.robotlegs.core.IInjector;
    import org.robotlegs.core.ISignalCommandMap;

    public class SignalCommandTests
    {
        [Test]
        public function signal_command_has_SignalCommandMap():void
        {
            var signalCommand:SignalCommand = new SignalCommand();
            var injector:IInjector = new SwiftSuspendersInjector();
            var signalCommandMap:ISignalCommandMap = new SignalCommandMap(injector);

            signalCommand.signalCommandMap = signalCommandMap;

            assertTrue( signalCommand.signalCommandMap is ISignalCommandMap );
        }
    }
}