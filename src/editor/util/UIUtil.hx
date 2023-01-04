package editor.util;

import editor.Style;


class UIUtil {

    public static function initHbox(hbox: h2d.Flow) {
        hbox.layout = Horizontal;
        hbox.horizontalSpacing = Style.Spacing;
        hbox.horizontalAlign = Left;
        hbox.verticalAlign = Top;

        hbox.padding = Style.Padding;
    }

    public static function hbox(?parent) {
        var hbox = new h2d.Flow(parent);
        UIUtil.initHbox(hbox);
        return hbox;
    }

    public static function initVbox(vbox: h2d.Flow) {
        vbox.layout = Vertical;
        vbox.verticalSpacing = Style.Spacing;
        vbox.horizontalAlign = Middle;
        vbox.verticalAlign = Top;

        vbox.padding = Style.Padding;
    }

    public static function vbox(?parent) : h2d.Flow {
        var vbox = new h2d.Flow(parent);
        UIUtil.initVbox(vbox);
        return vbox;
    }

    public static function uibox(?parent) : h2d.Flow {
        return switch (Style.Layout) {
            case Horizontal: UIUtil.hbox(parent);
            case Vertical:   UIUtil.vbox(parent);
        }
    }

}
