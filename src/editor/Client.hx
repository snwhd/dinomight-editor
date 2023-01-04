package editor;

import editor.tools.Toolbar;
import editor.util.FlowBase;
import editor.util.UIUtil;


class Client extends hxd.App {

    private static inline var AUTOSAVE_LIMIT = 5;
    private static inline var CLEAR_MESSAGE = 'Start a new map?\nThe current map will be lost.';

    private var flow : h2d.Flow;
    private var toolbar : Toolbar;
    private var canvas : Canvas;
    private var toolOptions : ToolOptions;

    private var settings : FlowBase;

    private var canvasWidth = Canvas.DEFAULT_WIDTH;
    private var canvasHeight = Canvas.DEFAULT_HEIGHT;


    static function main() {
        new Client();
    }

    override function init() {
        hxd.Res.initEmbed();
        hxd.Window.getInstance().addEventTarget(onEvent);

        this.makeUI();

        #if js
        js.Browser.window.onbeforeunload = function (e) {
            this.autosave();
            // TODO: remove after implementing auto load
            return 'Be sure to save before you exit!';
        };
        #end
    }

    public function makeUI() {
        Style.resize(this.s2d.width, this.s2d.height);
        this.s2d.removeChildren();

        // root ui element
        this.flow = UIUtil.uibox(this.s2d);
        this.flow.fillHeight = true;
        this.flow.fillWidth = true;
        this.flow.backgroundTile = h2d.Tile.fromColor(Style.BackgroundColor);

        this.toolbar = new Toolbar(this.flow);

        var sidebar = new FlowBase(this.flow);
        sidebar.backgroundColor = Style.BackgroundColor;
        switch (Style.Layout) {
            case Horizontal:
                UIUtil.initVbox(sidebar);
                sidebar.exactHeight = this.flow.innerHeight;
                sidebar.exactWidth = Style.SidebarSize;
            case Vertical:
                UIUtil.initHbox(sidebar);
                sidebar.exactWidth = this.flow.innerWidth;
                sidebar.exactHeight = Style.SidebarSize;
        }

        this.toolOptions = new ToolOptions(this.toolbar.currentTool, sidebar);
        this.toolbar.onToolChanged = function (tool) {
            this.toolOptions.toolChanged(tool);
            this.canvas.removeShadow();
        };

        this.settings = new Settings(this, sidebar);

        var canvasContainer = new FlowBase();
        this.flow.addChildAt(canvasContainer, 1);
        canvasContainer.backgroundColor = Style.BackgroundColor;

        switch (Style.Layout) {
            case Horizontal:
                UIUtil.initVbox(canvasContainer);
                canvasContainer.verticalAlign = Middle;
                canvasContainer.exactHeight = this.flow.innerHeight;
                canvasContainer.exactWidth = this.flow.innerWidth - (
                    Style.Spacing * 2  +
                    sidebar.outerWidth +
                    toolbar.outerWidth
                );
            case Vertical:
                UIUtil.initHbox(canvasContainer);
                canvasContainer.verticalAlign = Middle;
                canvasContainer.horizontalAlign = Middle;
                var maxHeight = this.flow.innerHeight - (
                    Style.Spacing * 2  +
                    Style.ToolbarSize +
                    Style.SidebarSize
                );
                canvasContainer.exactWidth = this.flow.innerWidth;
                canvasContainer.exactHeight = this.flow.innerWidth;
                if (this.flow.innerWidth > maxHeight) {
                    canvasContainer.exactHeight = maxHeight;
                }
        }

        this.canvas = new Canvas(
            this.toolbar,
            canvasContainer,
            this.canvasWidth,
            this.canvasHeight
        );

    }

    override function update(dt: Float) {
    }

    public function newMap(width: Int, height: Int) {
        var isBlank = true;
        for (i => tile in this.canvas.tiles.keyValueIterator()) {
            // ignore outer trees
            if (
                Std.int(i / this.canvas.canvasWidth) == 0 ||
                Std.int(i / this.canvas.canvasWidth) == this.canvas.canvasHeight - 1 ||
                i % this.canvas.canvasWidth == 0 ||
                i % this.canvas.canvasWidth == this.canvas.canvasWidth - 1
            ) {
                continue;
            }
            if (tile != null) {
                isBlank = false;
                break;
            }
        }

        if (!isBlank) {
            #if js
                var confirmed = js.Browser.window.confirm(CLEAR_MESSAGE);
                if (!confirmed) {
                    return;
                }
            #end
            this.autosave();
        }
        this.canvasWidth = width;
        this.canvasHeight = height;
        this.makeUI();
    }

    public function save() {
        var baseText = hxd.Res.loader.load('baseJson.json').toText();
        var layerText = hxd.Res.loader.load('layerJson.json').toText();
        var base = haxe.Json.parse(baseText);
        var layer = haxe.Json.parse(layerText);
        // remove the border of trees here
        // TODO: move this to Canvas.export
        base.width = this.canvas.canvasWidth - 2;
        base.height = this.canvas.canvasHeight - 2;
        layer.width = this.canvas.canvasWidth - 2;
        layer.height = this.canvas.canvasHeight - 2;
        var data : Array<Int> = [];

        for (i => tile in this.canvas.tiles.keyValueIterator()) {
            // skip outer edges
            if (
                Std.int(i / this.canvas.canvasWidth) == 0 ||
                Std.int(i / this.canvas.canvasWidth) == this.canvas.canvasHeight - 1 ||
                i % this.canvas.canvasWidth == 0 ||
                i % this.canvas.canvasWidth == this.canvas.canvasWidth - 1
            ) {
                continue;
            }

            if (tile == null) {
                data.push(0);
            } else {
                data.push(switch(tile.type) {
                    case Block:  3;
                    case Bomb:   7;
                    case Egg:    5;
                    case Meteor: 6;
                    case Range:  8;
                    case Spawn:  1;
                    case Speed:  9;
                    case Tree:   4;
                    case null:   0;
                });
            }
        }
        layer.data = data;
        base.layers = [layer];
        var content = haxe.Json.stringify(base);
        return content;
    }

    public function displayAutosaves() {
    }

    public function autosave() {
    #if js
        var storage = js.Browser.window.localStorage;
        for (i in 1 ... AUTOSAVE_LIMIT) {
            // from (limit - 1) to 1
            var n = AUTOSAVE_LIMIT - i;

            // add one so visuals is 1...limit inclusive
            var name = 'autosave-${n}';
            var existing = this.loadFromBrowser(name);
            if (existing != null) {
                // bump to higher save
                var newname = 'autosave-${n + 1}';
                var savedate = this.loadSaveDate(name);
                storage.setItem(newname, existing);
                saveSaveDate(newname, savedate);
            }
        }

        saveToBrowser('autosave-1');
    #end
    }

    public function loadFromBrowser(name: String): Null<String> {
    #if js
        var storage = js.Browser.window.localStorage;
        return storage.getItem(name);
    #end
    }

    public function loadSaveDate(name: String) : Null<String> {
    #if js
        return loadFromBrowser('${name}.__date__');
    #end
    }

    public function saveToBrowser(name: String) {
    #if js
        // TODO: include date?
        var storage = js.Browser.window.localStorage;
        storage.setItem(name, this.save());
        saveSaveDate(name);
    #end
    }


    public function saveSaveDate(name: String, ?date: String) {
    #if js
        var storage = js.Browser.window.localStorage;
        if (date == null) {
            date =  Date.now().toString();
        }
        storage.setItem('${name}.__date__', date);
    #end
    }

    private function alert(s: String) {
    #if js
        js.Browser.alert(s);
    #end
    }

    public function load(data: Dynamic) {
        var layers : Array<Dynamic> = data.layers;
        var height : Int = data.height;
        var width : Int = data.width;

        if (
            Type.typeof(height) != Type.ValueType.TInt ||
            Type.typeof(width) != Type.ValueType.TInt ||
            height == null ||
            width == null ||
            height < Canvas.MIN_HEIGHT ||
            width < Canvas.MIN_WIDTH ||
            height * width > Canvas.MAX_TILES
        ) {
            this.alert('invalid width/height');
            trace(data);
            trace('width: $width , height: $height');
            return;
        }

        if (Type.getClass(layers) != Array || layers.length != 1) {
            this.alert('invalid layer data');
            trace(data);
            return;
        }

        var layer : Dynamic = layers[0];
        var size = width * height;
        if (
            layer.width != width ||
            layer.height != height ||
            Type.getClass(layer.data) != Array ||
            layer.data.length != size
        ) {
            this.alert('invalid layer data / data size');
            trace(data);
            return;
        }

        var ldata : Array<Int> = layer.data;

        this.newMap(width, height);
        for (x in 0 ... width) for (y in 0 ... height) {
            var i = (y * width) + x;
            var value = ldata[i];
            this.canvas.put(x + 1, y + 1, switch(value) {
                case 0: null;
                case 1: Spawn;
                case 3: Block;
                case 4: Tree;
                case 5: Egg;
                case 6: Meteor;
                case 7: Bomb;
                case 8: Range;
                case 9: Speed;
                case _: null;
            });
        }

    }

    private function onEvent(e: hxd.Event) {
        switch (e.kind) {
            case EKeyDown:
                this.keyDown(e.keyCode);
            case EKeyUp:
                this.keyUp(e.keyCode);
            case _:
        }
    }

    private function keyUp(k: Int) {
    }

    private function keyDown(k: Int) {
        var shift = hxd.Key.isDown(hxd.Key.SHIFT);
        var ctrl  = hxd.Key.isDown(hxd.Key.CTRL);

        switch (k) {
            case hxd.Key.TAB:
                if (shift) {
                    this.toolbar.prev();
                } else {
                    this.toolbar.next();
                }
            case hxd.Key.Q:
                this.toolOptions.number(1);
            case hxd.Key.W:
                this.toolOptions.number(2);
            case hxd.Key.E:
                this.toolOptions.number(3);
            case hxd.Key.R:
                this.toolOptions.number(4);
            case hxd.Key.T:
                this.toolOptions.number(5);
            case hxd.Key.Y:
                if (ctrl) {
                    this.canvas.redo();
                } else {
                    this.toolOptions.number(6);
                }
            case hxd.Key.U:
                this.toolOptions.number(7);
            case hxd.Key.I:
                this.toolOptions.number(8);
            case hxd.Key.Z:
                if (ctrl) {
                    if (shift) {
                        this.canvas.redo();
                    } else {
                        this.canvas.undo();
                    }
                }
            case _:
        }
    }

}
