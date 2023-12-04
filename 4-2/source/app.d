import std.algorithm;
import std.conv;
import std.math;
import std.range;
import std.stdio;
import std.string;


enum string input = import("input.txt");

void main() {
    auto lines = input.split("\r\n");

    int[] cards;
    cards.length = lines.length;
    cards.fill(1);

    int j;
    for (int i = 0; i < cards.length; i++) {
        auto line = lines[i];        
        line.findSkip(": ");
        auto data = line.split(" | ");
        auto winningNumbers = data[0].split().map!(a => a.to!int);
        auto presentNumbers = data[1].split().map!(a => a.to!int);
        ulong matches = presentNumbers.count!(a => winningNumbers.canFind(a));
        for (j = i + 1; j < i + 1 + matches; j++) {
            cards[j] += cards[i];
        }
    }

    writeln("Result: ", cards.sum());
}
