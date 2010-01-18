package org.robotlegs.mvcs
{
    import org.robotlegs.core.ISignalCommandMap;

    public class SignalCommand extends Command
    {
        [Inject]
        public var signalCommandMap:ISignalCommandMap;
    }
}