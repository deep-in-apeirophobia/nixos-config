# T3 Code, built from the upstream nightly AppImage release artifacts.
#
# `releases` is the GitHub releases listing for pingdotgg/t3code, pulled in as a
# `file+https` flake input. Upstream publishes no rolling "latest nightly" tag or
# URL — every nightly is its own tag with the version baked into the asset name —
# so the newest one is picked at eval time out of that JSON. The API also hands
# back a sha256 digest per asset, which is what lets this stay pure without a
# vendored hash to bump by hand: `nix flake update` re-locks the JSON and the
# version, URL and hash all move together.
{ lib, appimageTools, fetchurl, releases }:

let
	pname = "t3code";

	isNightly = r:
		!r.draft && r.prerelease && lib.hasInfix "-nightly." r.tag_name;

	nightlies = builtins.filter isNightly
		(builtins.fromJSON (builtins.readFile releases));

	# The API returns releases newest-first.
	release =
		if nightlies == [ ]
		then throw "t3code-nightly: no nightly release in the locked releases JSON; run `nix flake update t3code-releases`"
		else builtins.head nightlies;

	assets = builtins.filter (a: lib.hasSuffix "-x86_64.AppImage" a.name) release.assets;

	asset =
		if assets == [ ]
		then throw "t3code-nightly: release ${release.tag_name} has no x86_64 AppImage asset"
		else builtins.head assets;

	digest = asset.digest or null;

	version = lib.removePrefix "v" release.tag_name;

	src = fetchurl {
		url = asset.browser_download_url;
		sha256 =
			if digest == null
			then throw "t3code-nightly: GitHub reported no digest for ${asset.name}"
			else lib.removePrefix "sha256:" digest;
	};

	contents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
	inherit pname version src;

	extraInstallCommands = ''
		install -Dm444 ${contents}/${pname}.desktop -t $out/share/applications
		substituteInPlace $out/share/applications/${pname}.desktop \
			--replace-fail 'Exec=AppRun' 'Exec=${pname}'
		cp -r ${contents}/usr/share/icons $out/share/icons
	'';

	meta = {
		description = "Minimal web GUI for coding agents (nightly build)";
		homepage = "https://t3.codes";
		downloadPage = release.html_url;
		license = lib.licenses.mit;
		mainProgram = pname;
		platforms = [ "x86_64-linux" ];
		sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
	};
}
