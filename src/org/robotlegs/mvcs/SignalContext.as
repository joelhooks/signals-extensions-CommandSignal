package org.robotlegs.mvcs
{
	import flash.display.DisplayObjectContainer;
    import org.robotlegs.base.SignalCommandMap;
    import org.robotlegs.core.ISignalCommandMap;
    import org.robotlegs.core.ISignalContext;

    public class SignalContext extends Context implements ISignalContext
    {
        protected var _signalCommandMap:ISignalCommandMap;

		public function SignalContext(contextView:DisplayObjectContainer = null, autoStartup:Boolean = true)
		{
			super(contextView, autoStartup);
		}
		
        public function get signalCommandMap():ISignalCommandMap
        {
            return _signalCommandMap || (_signalCommandMap = new SignalCommandMap(injector.createChild()));
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
