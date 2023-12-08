import std.algorithm;
import std.conv;
import std.format;
import std.math;
import std.range;
import std.stdio;
import std.string;


enum string input = import("input.txt");
alias Node = string[2];

void main() {
    auto lines = input.split("\r\n");
    auto instructions = lines[0].cycle();
    Node[string] nodes;

    foreach(line; lines[2..$]) {
        string node, left, right;
        line.formattedRead("%s = (%s, %s)", node, left, right);
        nodes[node] = [left, right];
    }

    string currentNode = "AAA";
    int result = 0;

    while (currentNode != "ZZZ") {
        currentNode = nodes[currentNode][instructions.front == 'L' ? 0 : 1];
        result++;
        instructions.popFront();
    }

    writeln("Result: ", result);
}
