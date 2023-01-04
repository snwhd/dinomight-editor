package editor.util;

import editor.Style;


class FlowBase extends h2d.Flow {

    public var flowParent  (get, never)   : h2d.Flow;
    public var exactHeight (default, set) : Null<Int>;
    public var exactWidth  (default, set) : Null<Int>;
    public var backgroundColor (default, set) : Null<Int>;

    public function new(?parent: h2d.Flow) {
        super(parent);
        this.backgroundColor = Style.ForegroundColor;
        this.overflow = Hidden;
    }

    public function get_flowParent() {
        return cast(this.parent);
    }

    public function set_exactWidth(w: Null<Int>) : Null<Int> {
        this.exactWidth = w;
        this.minWidth = w;
        this.maxWidth = w;
        return w;
    }

    public function set_exactHeight(w: Null<Int>) : Null<Int> {
        this.exactHeight = w;
        this.minHeight = w;
        this.maxHeight = w;
        return w;
    }

    public function set_backgroundColor(color: Null<Int>) {
        if (color != this.backgroundColor) {
            this.backgroundColor = color;
            if (color == null) {
                this.backgroundTile = null;
            } else {
                this.backgroundTile = h2d.Tile.fromColor(color);
            }
        }
        return color;
    }

}
