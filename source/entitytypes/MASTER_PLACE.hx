package entitytypes;
import entitytypes.MASTER_AGENT.OCCTYPE_CREATURE;
import flixel.FlxSprite;

/**
 * ...
 * @author Victor Grunn
 */
class MASTER_PLACE extends MASTER_BASE
{
	public var occupants:Array<MASTER_AGENT>;
	public var ID_TYPE:MASTER_PLACE.OCCTYPE_LAND;

	public function new() 
	{
		super();
		
		occupants = new Array<MASTER_AGENT>();
	}	
	
	public function launch(_type:OCCTYPE_LAND):Void
	{
		
	}
	
	private function resolveOccupants(_creature:MASTER_AGENT):Void
	{
		
	}
	
	
	public function setOccupant(_creature:MASTER_AGENT):Void
	{
		occupants.push(_creature);
		_creature.x = this.x;
		_creature.y = this.y;
		_creature.xSlot = xSlot;
		_creature.ySlot = ySlot;
		if (_creature.currentLocation != null)
		{
			_creature.currentLocation.removeOccupant(_creature);
		}		
		_creature.currentLocation = this;
		
		resolveOccupants(_creature);
	}
	
	public function removeOccupant(_creature:MASTER_AGENT):Void
	{
		occupants.remove(_creature);
	}
	
}

enum OCCTYPE_LAND
{
	EMPTY;
	TREE_SAPLING;
	TREE_TREE;
	TREE_ELDER;
}