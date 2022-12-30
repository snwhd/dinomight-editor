package editor;

import editor.util.FlowBase;
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
		this.exactWidth = parent.innerWidth;
		this.exactHeight = Std.int((
			parent.innerHeight - parent.verticalSpacing
		) / 2);

		this.layout = Horizontal;
		this.verticalAlign = Top;
		this.horizontalAlign = Middle;
		this.verticalSpacing = Style.ToolbarPadding;
		this.horizontalSpacing = Style.ToolbarPadding;
		this.padding = Style.Padding;

		this.multiline = true;

		this.options = [
			new New(this),
			// new Save(this),
			// new Load(this),
			new Open(this),
			new Export(this),
		];
		for (option in this.options) {
			option.drawUI();
		}
	}

}
