package org.robotlegs.test.support.guarding 
{
	import org.robotlegs.core.IGuard;

	public class GrumpyGuard implements IGuard
	{
	
		 //---------------------------------------
		 // IGuard Implementation
		 //---------------------------------------

		 //import org.robotlegs.core.IGuard;
		 public function approve():Boolean
		 {
		 	return false;
		 }		 
	
	}

}