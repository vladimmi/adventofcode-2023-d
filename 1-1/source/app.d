import std.algorithm;
import std.ascii;
import std.range;
import std.stdio;
import std.string;

enum string input = import("input.txt");

void main() {
    int result = 0;
    string[] lines = input.split("\r\n");
    foreach (line; lines) {
        result += digits.countUntil(line[line.indexOfAny(digits)]) * 10;
        result += digits.countUntil(line[line.lastIndexOfAny(digits)]);
    }
    writeln("Result: ", result);
}
