import std.algorithm;
import std.conv;
import std.math;
import std.range;
import std.stdio;
import std.string;
import std.typecons;


enum string input = import("input.txt");

void main() {
    string[] steps = input.split(",");
    
    int result = 0;
    int hash = 0;

    foreach (step; steps) {
        hash = 0;
        foreach (c; step) {
            hash += c.to!ubyte;
            hash *= 17;
            hash = fmod(hash, 256).to!int;
        }
        result += hash;
    }

    writeln("Result: ", result);
}
