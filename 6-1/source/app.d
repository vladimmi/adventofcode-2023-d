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

    int[] times = lines[0].split(":")[1].split().map!(a => a.to!int).array();
    int[] distances = lines[1].split(":")[1].split().map!(a => a.to!int).array();

    int result = 1;
    int wins, time, distance;

    for (int i = 0; i < times.length; i++) {
        wins = 0;
        for (time = 0; time < times[i]; time++) {
            distance = (times[i] - time) * time;
            if (distance > distances[i]) wins++;
        }
        result *= wins;
    }

    writeln("Result: ", result);
}
