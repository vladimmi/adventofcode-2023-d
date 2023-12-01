import std.algorithm;
import std.ascii;
import std.meta;
import std.range;
import std.stdio;
import std.string;


enum string input = import("input.txt");
enum numbers = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"];

void main() {
    int result = 0;
    string[] lines = input.split("\r\n");
    foreach (line; lines) {
        auto first = line.find(aliasSeqOf!(digits[1..$]), aliasSeqOf!numbers);
        result += (first[1] < 10 ? first[1] : first[1] - 9) * 10;
        auto last = line.retro.find(aliasSeqOf!(digits[1..$]), aliasSeqOf!(numbers.map!retro.array));
        result += (last[1] < 10 ? last[1] : last[1] - 9);
    }
    writeln("Result: ", result);
}
