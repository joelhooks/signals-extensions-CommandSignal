package org.robotlegs.test.support
{
	import flash.display.DisplayObjectContainer;

	import org.robotlegs.core.IInjector;
	import org.robotlegs.mvcs.SignalContext;

	public class SignalContextWithAccessibleInjector extends SignalContext
	{
		public function SignalContextWithAccessibleInjector(contextView:DisplayObjectContainer = null, autoStartup:Boolean = true)
		{
			super(contextView, autoStartup);
		}

		public function getInjector():IInjector
		{
			return injector;
		}
	}
}