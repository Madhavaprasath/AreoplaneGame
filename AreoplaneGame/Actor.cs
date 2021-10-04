using Godot;
using System;

public class Actor : KinematicBody2D
{
    [Export]
    public int movement_speed=200;
    [Export]
    public int damage=20;
    

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        GD.Print("Helloworld");
    }

}
