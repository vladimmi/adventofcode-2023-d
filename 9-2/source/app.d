import std.algorithm;
import std.conv;
import std.format;
import std.numeric;
import std.range;
import std.stdio;
import std.string;


enum string input = import("input.txt");

int prevStep(int[] sequence) {
    int[] diff;
    for (int i = 0; i < sequence.length - 1; i++) {
        diff ~= sequence[i + 1] - sequence[i];
    }
    return sequence[0] - (diff.all!(a => a == 0) ? 0 : prevStep(diff));
}

void main() {
    auto lines = input.split("\r\n");

    int result = 0;

    foreach(line; lines) {
        int[] sequence = line.split().map!(to!int).array();
        result += sequence.prevStep();
    }

    writeln("Result: ", result);
}
