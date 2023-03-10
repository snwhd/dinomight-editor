package editor;

import editor.util.FlowBase;
import editor.util.UIUtil;
import editor.options.Export;
import editor.options.Load;
import editor.options.New;
import editor.options.Open;
import editor.options.Option;
import editor.options.Save;


class Settings extends FlowBase {

    private var options : Array<Option>;
    public var client : Client;

    public function new(client: Client, ?parent) {
        super(parent);
        this.client = client;

        switch (Style.Layout) {
            case Horizontal:
                UIUtil.initHbox(this);
                this.horizontalAlign = Middle;
                this.verticalSpacing = Style.Spacing;
                this.exactWidth = parent.innerWidth;
                this.exactHeight = Std.int((
                    parent.innerHeight - parent.verticalSpacing
                ) / 2);
            case Vertical:
                UIUtil.initVbox(this);
                this.horizontalSpacing = Style.Spacing;
                this.exactHeight = parent.innerHeight;
                this.exactWidth = Std.int((
                    parent.innerWidth - parent.horizontalSpacing
                ) / 2);
        }

        this.multiline = true;

        this.options = [
            new New(this),
            // new Save(this),
            new Open(this),
            new Export(this),
            // new Load(this),
        ];

        var totalWidth = 0;
        for (option in this.options) {
            option.drawUI();
            totalWidth += option.outerWidth;
        }

        // TODO: this breaks if multiline
        var spacing = Std.int(
            (this.innerWidth - totalWidth) / this.options.length
        );
        this.horizontalSpacing = spacing;
    }

}
