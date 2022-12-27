package editor.util;

class Random {

    public static function createSafeRand() {
        var seedseed = Std.int(Date.now().getTime() % 0x7fffffff);
        return new hxd.Rand(seedseed);
    }

    public static function randomString(n: Int, rand: Null<hxd.Rand> = null) {
        if (rand == null) {
            rand = Random.createSafeRand();
        }
        var charset = 'abcdefghijklmnopqrstuvwxyz1234567890';
        var letters : Array<String> = [];
        for (i in 0 ... n) {
            letters.push(charset.charAt(rand.random(charset.length)));
        }
        return letters.join('');
    }

}
