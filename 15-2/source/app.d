import std.algorithm;
import std.ascii;
import std.conv;
import std.math;
import std.range;
import std.stdio;
import std.string;
import std.typecons;


enum string input = import("input.txt");
alias Lens = Tuple!(string, ubyte);

void main() {
    string[] steps = input.split(",");
    Lens[][] boxes;
    boxes.length = 256;
    
    int result = 0;
    string label;
    int hash, i;
    ubyte focal;
    long idx;
    bool save;

    foreach (step; steps) {
        hash = 0;
        for (i = 0; i < step.length; i++) {
            if (step[i].isAlpha()) {
                hash += step[i].to!ubyte;
                hash *= 17;
                hash = fmod(hash, 256).to!int;
            } else if (step[i] == '-') {
                label = step[0..i];
                save = false;
            } else if (step[i] == '=') {
                label = step[0..i];
                save = true;
            } else {
                focal = digits.countUntil(step[i]).to!ubyte;
            }
        }
        idx = boxes[hash].countUntil!(l => l[0] == label);
        if (save) {
            if (idx == -1) {
                boxes[hash] ~= tuple(label, focal);
            } else {
                boxes[hash][idx][1] = focal;
            }
        } else {
            if (idx != -1) {
                boxes[hash] = boxes[hash].remove(idx);
            }
        }
    }

    for (i = 0; i < boxes.length; i++) {
        foreach (slot, lens; boxes[i]) {
            result += (i + 1) * (slot + 1) * lens[1];
        }
    }

    writeln("Result: ", result);
}
