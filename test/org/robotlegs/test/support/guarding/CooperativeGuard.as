package org.robotlegs.test.support.guarding 
{
	import org.robotlegs.core.IGuard;

	public class CooperativeGuard implements IGuard
	{
	     
		[Inject]
		public var allow:Boolean;
	
		//---------------------------------------
	 	// IGuard Implementation
		//---------------------------------------

		//import org.robotlegs.core.IGuard;
		public function approve():Boolean
		{
			return allow;
		}		 
    
	}

}