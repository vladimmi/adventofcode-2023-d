import std.algorithm;
import std.conv;
import std.datetime.stopwatch;
import std.format;
import std.math;
import std.parallelism;
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

    long result = long.max;

    string seedsLine = lines[0];
    seedsLine.findSkip(": ");
    long[][] seedRanges = seedsLine.split(" ").map!(s => s.to!long).array().chunks(2).array();
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

    auto sw = StopWatch(AutoStart.no);

    long i, value;
    sw.start();
    foreach (seedRange; parallel(seedRanges)) {
        for (i = seedRange[0]; i < seedRange[0] + seedRange[1]; i++) {
            value = i;
            nextRuleList:
            foreach (ruleList; rules) {
                foreach (rule; ruleList) {
                    if (value >= rule.src && value < rule.src + rule.length) {
                        value = rule.dest + (value - rule.src);
                        continue nextRuleList;
                    }
                }
            }
            if (value < result) result = value;
        }
    }
    sw.stop();

    writeln("Result: ", result);
    writeln("Time: ", sw.peek);
}
