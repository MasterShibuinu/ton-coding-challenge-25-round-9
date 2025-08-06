const MY_WORKCHAIN = BASECHAIN;
const OP_INCREASE = stringCrc32("increase"); // 4bc9d2ee
const OP_RESET = stringCrc32("reset");       // 83ad9f01

var score: int = 0;

fun increaseScore(value: int) {
    score += value;
}

fun resetScore() {
    score = 0;
}

fun routeInternal(`ctx::sender`: slice, `ctx::value`: int, `ctx::fwd_fee`: int, `ctx::body`: slice) {
    var (op: int, _) = `ctx::body`.loadOpAndQueryId();

    if (op == OP_INCREASE) {
        increaseScore(5);
        return;
    }

    if (op == OP_RESET) {
        resetScore();
        return;
    }

    throw 0xffff;
}

fun main(`ctx::value`: int, inMsgFull: cell, `ctx::body`: slice) {
    var s = inMsgFull.beginParse();
    var flags = s.loadMsgFlags();
    if (isBounced(flags)) { return; }

    var (`ctx::sender`: slice, `ctx::fwd_fee`: int) = s.retrieveCtx(MY_WORKCHAIN);
    routeInternal(`ctx::sender`, `ctx::value`, `ctx::fwd_fee`, `ctx::body`);
}
