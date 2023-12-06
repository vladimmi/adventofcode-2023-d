import std.algorithm;
import std.conv;
import std.format;
import std.math;
import std.range;
import std.stdio;
import std.string;


enum string input = import("input.txt");

void main() {
    auto lines = input.split("\r\n");

    long time = lines[0].split(":")[1].replace(" ", "").to!long;
    long distance = lines[1].split(":")[1].replace(" ", "").to!long;

    long result = 0;
    long runDistance;
    for (int i = 0; i < time; i++) {
        runDistance = (time - i) * i;
        if (runDistance > distance) result++;
    }

    writeln("Result: ", result);
}
