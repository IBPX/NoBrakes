package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.system.FlxSound;
import haxe.Timer;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState {
	/**
	 * Function that is called up when to state is created to set it up. 
	 */

	var background:FlxSprite;
	var logo:FlxSprite;
	var truckSpeed:Float;
	var truckTurnSpeed:Float;
	var truckBumped:Bool;
	var truck:FlxSprite;
	var gamePlaying:Bool;
	var sound_gamestart:FlxSound;
	var sound_crash:FlxSound;
	var fps = 30;
	
	
	override public function create():Void {
		FlxG.mouse.useSystemCursor = true;
		var background = new FlxSprite();
		background.loadGraphic("assets/images/background.png");
		add(background);

		gamePlaying = false;

		sound_gamestart = new FlxSound();
		sound_gamestart.loadStream("assets/sounds/gamestart.mp3");

		sound_crash = new FlxSound();
		sound_crash.loadStream("assets/sounds/crash.mp3");

		logo = new FlxSprite();
		logo.loadGraphic("assets/images/logo.png");
		logo.x = 42;
		logo.y = 33;

		truck = new FlxSprite();
		truck.loadGraphic("assets/images/truck_forward.png");
		truck.x = 60;
		truck.y = -100;
		truckTurnSpeed = 100;
		truckSpeed = 100;
		truckBumped = false;

		add(truck);
		add(logo);
		super.create();
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void {
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void {
		if (FlxG.keys.pressed.D) { turnTruckRight(); }
		if (FlxG.keys.pressed.A) { turnTruckLeft(); }
		if (FlxG.keys.pressed.RIGHT) { turnTruckRight(); }
		if (FlxG.keys.pressed.LEFT) { turnTruckLeft(); }
		super.update();
		
	}

	public function gameStart() {
		gamePlaying = true;
		sound_gamestart.play();
		tween(logo, 42, 33, 42, -100, 2.00, true, {ease: FlxEase.quadInOut});
		tween(truck, 60, -50, 60, 10, 2, true, {ease: FlxEase.quadInOut});
	}

	public function gameEnd() {
		gamePlaying = false;
		tween(logo, 42, -100, 42, 33, 2.00, true, {ease: FlxEase.quadInOut});
	}

	public function initTruck() {
		truck = new FlxSprite();
		truck.loadGraphic("assets/images/truck_forward.png");
		truck.x = 60;
		truck.y = 10;
		truckTurnSpeed = 100;
		truckSpeed = 100;
		truckBumped = false;
	}

	public function tween(sprite:FlxSprite, startx:Float, starty:Float, endx:Float, endy:Float, time:Float, respectTime:Bool, options):Void {
		FlxTween.linearMotion(sprite, startx, starty, endx, endy, time, respectTime, options);
	}
	
	public function turnTruckRight():Void {
		if (gamePlaying) { truck.x = truck.x + truckSpeed / fps; }
		else { gameStart(); }
	}

	public function turnTruckLeft():Void {
		if (gamePlaying) { truck.x = truck.x - truckSpeed / fps; }
		else { gameStart(); }
	}

	public function bumpTruck():Void {
		if (truckBumped == false) {
			truck.y = truck.y + 1;
			truckBumped = true;
			haxe.Timer.delay(unbumpTruck, 1000);
		}
	}

	public function unbumpTruck():Void {
		if (truckBumped == true) {
			truck.y = truck.y - 1;
			truckBumped = false;
		}
	}
}
