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

class Car extends FlxSprite {
	private var _fps:Int = 30; // Use for step();
	
	public function new(x:Int, y:Int):Void {
		super(x, y);
		loadGraphic("assets/images/car.png");
	}

	public function step(speed):Void {
		this.y = this.y + (speed / _fps);
	}
}