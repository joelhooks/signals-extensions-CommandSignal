package org.robotlegs.mvcs
{
    import org.robotlegs.base.SignalCommandMap;
    import org.robotlegs.core.ISignalCommandMap;
    import org.robotlegs.core.ISignalContext;

    public class SignalContext extends Context implements ISignalContext
    {
        protected var _signalCommandMap:ISignalCommandMap;

        public function get signalCommandMap():ISignalCommandMap
        {
            return _signalCommandMap || (_signalCommandMap = new SignalCommandMap(injector));
        }

        public function set signalCommandMap(value:ISignalCommandMap):void
        {
            _signalCommandMap = value;
        }

        override protected function mapInjections():void
        {
            super.mapInjections();
            injector.mapValue(ISignalCommandMap, signalCommandMap);
        }
    }
}