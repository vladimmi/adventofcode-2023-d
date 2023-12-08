import std.algorithm;
import std.format;
import std.numeric;
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

    string[] currentNodes = nodes.keys.filter!(n => n[2] == 'A').array();
    long[] results;
    results.length = currentNodes.length;
    results.fill(0);

    int i;
    byte step;
    do {
        step = instructions.front == 'L' ? 0 : 1;
        for (i = 0; i < currentNodes.length; i++) {
            if (currentNodes[i][2] != 'Z') {
                currentNodes[i] = nodes[currentNodes[i]][step];
                results[i]++;
            }
        }
        instructions.popFront();
    } while (currentNodes.any!(n => n[2] != 'Z'));

    writeln("Result: ", results, " = ", results.fold!lcm);
}
