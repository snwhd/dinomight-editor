package editor.tools;

import editor.util.FlowBase;

class Tool extends FlowBase {

	public var type (default, null) : ToolType;

	public function new(type: ToolType, ?parent) {
		super(parent);
		this.type = type;
		this.enableInteractive = true;
		this.interactive.onClick = function (e) {
			this.onClick();
		}
	}

	public dynamic function onClick () {
	}

}
