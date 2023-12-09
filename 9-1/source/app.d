import std.algorithm;
import std.conv;
import std.format;
import std.numeric;
import std.range;
import std.stdio;
import std.string;


enum string input = import("input.txt");

int nextStep(int[] sequence) {
    int[] diff;
    for (int i = 0; i < sequence.length - 1; i++) {
        diff ~= sequence[i + 1] - sequence[i];
    }
    return sequence[$ - 1] + (diff.all!(a => a == 0) ? 0 : nextStep(diff));
}

void main() {
    auto lines = input.split("\r\n");

    int result = 0;

    foreach(line; lines) {
        int[] sequence = line.split().map!(to!int).array();
        result += sequence.nextStep();
    }

    writeln("Result: ", result);
}
