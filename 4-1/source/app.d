import std.algorithm;
import std.conv;
import std.math;
import std.range;
import std.stdio;
import std.string;


enum string input = import("input.txt");

void main() {
    auto lines = input.split("\r\n");

    int result = 0;

    foreach(line; lines) {
        line.findSkip(": ");
        auto data = line.split(" | ");
        auto winningNumbers = data[0].split().map!(a => a.to!int);
        auto presentNumbers = data[1].split().map!(a => a.to!int);
        ulong matches = presentNumbers.count!(a => winningNumbers.canFind(a));
        if (matches) result += pow(2, matches - 1);
    }

    writeln("Result: ", result);
}
