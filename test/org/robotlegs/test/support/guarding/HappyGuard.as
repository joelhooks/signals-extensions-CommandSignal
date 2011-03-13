package org.robotlegs.test.support.guarding 
{
	import org.robotlegs.core.IGuard;

	public class HappyGuard implements IGuard
	{
	
		 //---------------------------------------
		 // IGuard Implementation
		 //---------------------------------------

		 //import org.robotlegs.core.IGuard;
		 public function approve():Boolean
		 {
		 	return true;
		 }		 
	
	}

}