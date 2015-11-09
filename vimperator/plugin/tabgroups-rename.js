var INFO = xml`
<plugin name="tabgroups-rename"
        version="0.1"
        summary="Tab Groups rename command"
        xmlns="http://vimperator.org/namespaces/liberator">
  <author>a-roy</author>
  <project name="Vimperator" minVersion="3.10"/>
  <item>
    <tags>tabgroups-rename</tags>
    <description>
      <p>Rename the tab group</p>
    </description>
  </item>
</plugin>`;

(function() {
commands.get("tabgroups").subCommands.push(
	new Command(["rename"], "Rename the tab group",
		function (args) {
			tabGroup.tabView.GroupItems.getActiveGroupItem().setTitle(args.literalArg)
		}, { literal: 0 }));
})();
