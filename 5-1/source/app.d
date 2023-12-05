import std.algorithm;
import std.conv;
import std.format;
import std.math;
import std.range;
import std.stdio;
import std.string;


enum string input = import("input.txt");

class Rule {
    long dest;
    long src;
    long length;
}

void main() {
    auto lines = input.split("\r\n");

    string seedsLine = lines[0];
    seedsLine.findSkip(": ");
    long[] seeds = seedsLine.split(" ").map!(s => s.to!long).array();
    Rule[][] rules;

    for (int i = 1; i < lines.length; i++) {
        if (lines[i].empty) {
            rules ~= (Rule[]).init;
            i++;
        } else {
            auto rule = new Rule();
            lines[i].formattedRead("%d %d %d", rule.dest, rule.src, rule.length);
            rules[$-1] ~= rule;
        }
    }

    long[] result = seeds;
    foreach (ref value; result) {
        nextRuleList:
        foreach (ruleList; rules) {
            foreach (rule; ruleList) {
                if (value >= rule.src && value < rule.src + rule.length) {
                    value = rule.dest + (value - rule.src);
                    continue nextRuleList;
                }
            }
        }
    }

    writeln("Result: ", result.minElement());
}
