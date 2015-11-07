var INFO = xml`
<plugin name="multipleTabHandlerEX"
        version="0.1"
        summary="Vimperator functions for Multiple Tab Handler"
        xmlns="http://vimperator.org/namespaces/liberator">
  <author email="takayuki0510@gmail.com">tsukee</author>
  <author>a-roy</author>
  <project name="Vimperator" minVersion="3.8"/>
  <item>
    <tags>&lt;leader&gt;m</tags>
    <description>
      <p>Toggle selection of the current tab.</p>
    </description>
  </item>
  <item>
    <tags>&lt;leader&gt;c</tags>
    <description>
      <p>Clear the tab selection.</p>
    </description>
  </item>
  <item>
    <tags>r</tags>
    <description>
      <p>Reload selected tabs.</p>
    </description>
  </item>
  <item>
    <tags>d</tags>
    <description>
      <p>Select current tabs.</p>
    </description>
  </item>
  <item>
    <tags>A</tags>
    <description>
      <p>Bookmark selected tabs.</p>
    </description>
  </item>
  <item>
    <tags>:multipleduplicate :mdu[plicate]</tags>
    <description>
      <p>Duplicate selected tabs.</p>
    </description>
  </item>
  <item>
    <tags>:multipledetach :mde[tach]</tags>
    <description>
      <p>Detach selected tabs.</p>
    </description>
  </item>
  <item>
    <tags>:multiplecopy :mco[py]</tags>
    <description>
      <p>Copy URI's of selected tabs.</p>
    </description>
  </item>
  <item>
    <tags>zt</tags>
    <description>
      <p>Select current tree.</p>
    </description>
  </item>
  <item>
    <tags>zs</tags>
    <description>
      <p>Select all siblings of current tab.</p>
    </description>
  </item>
  <item>
    <tags>:mq[uit] :multipleq[uit] :mdel[ete] :multipledel[ete]</tags>
    <description>
      <p>Close the current or selected tabs.</p>
    </description>
  </item>
  <item>
    <tags>:multipleunload :munload</tags>
    <description>
      <p>Unload all selected tabs.</p>
    </description>
  </item>
  <item>
    <tags>:multipled[o] :mdo</tags>
    <description>
      <p>Execute a command in each selected tab.</p>
    </description>
  </item>
</plugin>`;

(function() {
if (!("MultipleTabService" in window)) {
    liberator.echoerr("multipleTabHandlerEx.js needs MultipleTabHandler extension");
    return;
}

// commands
commands.addUserCommand(["multipleq[uit]", "mq[uit]", "multipledel[ete]", "mdel[ete]"],
    "MultipleTabHandler - quit",
    function() {
        if (MultipleTabService.hasSelection()) {
            let tabs = MultipleTabService.getSelectedTabs();
            MultipleTabService.closeTabs(tabs);
        }
        else {
            BrowserCloseTabOrWindow();
        }
    }, {}, true);

commands.addUserCommand(["multipleunload", "munload"],
    "MultipleTabHandler - unload",
    function () {
        if (MultipleTabService.hasSelection()) {
            let tabs = MultipleTabService.getSelectedTabs();
            tabs.forEach(function(tab) {
                        if (gBrowser.selectedTab != tab)
							plugins.unloadTab.unloadTab(tab);
                    })
        }
    });

commands.addUserCommand(["multipled[o]", "mdo"],
        "Execute a command in selected tabs",
        function(args) {
            let mtabs = MultipleTabService.hasSelection()
                ? MultipleTabService.getSelectedTabs() : [gBrowser.selectedTab];
            mtabs.forEach(
                    function(tab) {
                        gBrowser.selectedTab = tab;
                        liberator.execute(args.string, null, true);
                    }
            );
        }, {
            argCount: "1",
            completer: function (context) completion.ex(context),
            literal: 0
        },
        true);
})();
