package org.robotlegs.test.suites
{
    import org.robotlegs.base.SignalCommandMapTests;
    import org.robotlegs.mvcs.AsyncSignalCommandTests;
    import org.robotlegs.mvcs.CompositeSignalCommandTests;
    import org.robotlegs.mvcs.SignalCommandTests;
    import org.robotlegs.mvcs.SignalContextTests;

    [Suite]
    [RunWith("org.flexunit.runners.Suite")]
    public class SignalCommandMapTestSuite
    {
        public var _signalContextTests:SignalContextTests;
        public var _signalCommandMapTests:SignalCommandMapTests;
        public var _signalCommandTests:SignalCommandTests;
		public var _asyncSignalCommandTests:AsyncSignalCommandTests;
		public var _compositeSignalCommandTests:CompositeSignalCommandTests;
    }
}