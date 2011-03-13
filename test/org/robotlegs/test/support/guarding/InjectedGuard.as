package org.robotlegs.test.support.guarding 
{
	import org.robotlegs.core.IGuard;

	public class InjectedGuard implements IGuard
	{

		[Inject]
		public var answer:IInjectedAnswer;
	
		//---------------------------------------
		// IGuard Implementation
		//---------------------------------------

		//import org.robotlegs.core.IGuard;
		public function approve():Boolean
		{
			return answer.allow();
		}
	
	}

}