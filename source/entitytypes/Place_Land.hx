package entitytypes;
import entitytypes.MASTER_PLACE.OCCTYPE_LAND;
import flixel.FlxSprite;
import flixel.FlxG;
import maingame.GameGroup;
import utils.ArrayChecker;

/**
 * ...
 * @author Victor Grunn
 */
class Place_Land extends MASTER_PLACE
{
	public function new()
	{
		super();
	}			
	
	override public function launch(_type:OCCTYPE_LAND):Void 
	{
		super.launch(_type);
		
		ageMonth = 0;
		ageYear = 0;
		readyToUpdate = true;
		
		ID_TYPE = _type;
		
		switch (ID_TYPE)
		{
			case OCCTYPE_LAND.EMPTY:
				makeGraphic(GameGroup.pieceSize, GameGroup.pieceSize, 0xffccff00);
				
			case OCCTYPE_LAND.TREE_ELDER:		
				makeGraphic(GameGroup.pieceSize, GameGroup.pieceSize, 0xff336633);
				
			case OCCTYPE_LAND.TREE_SAPLING:
				makeGraphic(GameGroup.pieceSize, GameGroup.pieceSize, 0xff00ff33);
				
			case OCCTYPE_LAND.TREE_TREE:				
				makeGraphic(GameGroup.pieceSize, GameGroup.pieceSize, 0xff009966);
		}		
	}
	
	override public function ageOneMonth():Void
	{		
		super.ageOneMonth();
		
		if (ID_TYPE != OCCTYPE_LAND.EMPTY)
		{
			ageMonth += 1;
			
			if (ageMonth >= 12)
			{
				ageMonth = 0;							
				ageYear += 1;
				
				if (ID_TYPE == OCCTYPE_LAND.TREE_SAPLING)
				{
					launch(OCCTYPE_LAND.TREE_TREE);
				}
				else if (ID_TYPE == OCCTYPE_LAND.TREE_TREE)
				{
					launch(OCCTYPE_LAND.TREE_ELDER);
				}
			}						
			
			if (ID_TYPE == OCCTYPE_LAND.TREE_TREE || ID_TYPE == OCCTYPE_LAND.TREE_ELDER)
			{
				spawnSapling(ID_TYPE);
			}
		}						
	}
	
	private function spawnSapling(_type:OCCTYPE_LAND):Void
	{
		var threshold:Float = .8;
		
		if (_type == OCCTYPE_LAND.TREE_ELDER)
		{
			threshold = .8;
		}
		else
		{
			threshold = .9;
		}				
		
		if (Math.random() > threshold)
		{
			var myX:Int = 0;
			var myY:Int = 0;													
			
			myX = xSlot;
			myY = ySlot;						
			
			var testArray = new Array<ArrayChecker>();			
			var checkArray = new Array<ArrayChecker>();
			
			testArray[0] = new ArrayChecker(myX - 1, myY - 1);			
			testArray[1] = new ArrayChecker(myX, myY - 1);
			testArray[2] = new ArrayChecker(myX + 1, myY - 1);
			testArray[3] = new ArrayChecker(myX - 1, myY);
			testArray[4] = new ArrayChecker(myX + 1, myY);
			testArray[5] = new ArrayChecker(myX - 1, myY + 1);
			testArray[6] = new ArrayChecker(myX, myY + 1);
			testArray[7] = new ArrayChecker(myX + 1, myY + 1);					
			
			var foundMatch:Bool = false;			
			var spawnChecker:ArrayChecker = new ArrayChecker(0, 0);
			
			for (i in 0...testArray.length)
			{
				if (testArray[i].x < 0 || testArray[i].x > GameGroup.mapSize - 1 || testArray[i].y < 0 || testArray[i].y > GameGroup.mapSize - 1)
				{
					checkArray.push(testArray[i]);		
				}
			}
			
			for (i in 0...checkArray.length)
			{
				testArray.remove(checkArray[i]);
			}
			
			while (checkArray.length > 0)
			{
				checkArray.pop();
			}
			
			while (testArray.length > 0 && foundMatch == false)
			{				
				//var tester:ArrayChecker = testArray.pop();
				var tester:ArrayChecker = testArray[Math.floor(Math.random() * testArray.length)];
				foundMatch = checkSapling(tester.x, tester.y);
				
				if (foundMatch)
				{
					spawnChecker = tester;	
					for (i in 0...testArray.length)
					{
						testArray[i] = null;
					}
				}
				else
				{
					testArray.remove(tester);
				}
			}
			
			if (foundMatch)
			{
				if (spawnChecker != null)
				{
					GameGroup.mapAccessArray[spawnChecker.x][spawnChecker.y].launch(OCCTYPE_LAND.TREE_SAPLING);
				}				
			}						
		}				
	}
	
	private function checkSapling(_x:Int, _y:Int):Bool		
	{						
		if (GameGroup.mapAccessArray[_x][_y].ID_TYPE != null && GameGroup.mapAccessArray[_x][_y].ID_TYPE == OCCTYPE_LAND.EMPTY)
		{						
			return true;
		}
		
		return false;
	}		
	
	override private function resolveOccupants(_creature:MASTER_AGENT):Void
	{	
		switch(_creature.ID_TYPE)
		{
			case MASTER_AGENT.OCCTYPE_CREATURE.LUMBERJACK:
				for (i in 0...occupants.length)
				{
					if (occupants[i] != null && occupants[i].ID_TYPE == MASTER_AGENT.OCCTYPE_CREATURE.BEAR)
					{
						GameGroup.totalDeadLumberjacks += 1;
						GameGroup.occupantsArray.remove(_creature);
						_creature.exists = false;
						_creature.interrupt();
						removeOccupant(_creature);
						return;
					}																							
				}
				
				if (ID_TYPE == OCCTYPE_LAND.TREE_TREE)
				{
					launch(OCCTYPE_LAND.EMPTY);
					GameGroup.TotalWoodEver += 1;
					GameGroup.TotalWoodThisYear += 1;
					_creature.interrupt();
				}
				
				if (ID_TYPE == OCCTYPE_LAND.TREE_ELDER)
				{
					launch(OCCTYPE_LAND.EMPTY);
					GameGroup.TotalWoodEver += 2;
					GameGroup.TotalWoodThisYear += 2;
					_creature.interrupt();
				}
				
			case MASTER_AGENT.OCCTYPE_CREATURE.BEAR:
				for (i in 0...occupants.length)
				{
					if (occupants[i] != null && occupants[i].ID_TYPE == MASTER_AGENT.OCCTYPE_CREATURE.LUMBERJACK)
					{
						GameGroup.totalDeadLumberjacks += 1;
						GameGroup.totalDeadLumberjacksThisYear += 1;
						occupants[i].exists = false;
						GameGroup.occupantsArray.remove(occupants[i]);
						_creature.interrupt();
						removeOccupant(occupants[i]);
					}
				}
				
		}
	}	
}