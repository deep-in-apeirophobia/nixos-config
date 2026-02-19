
{ config, pkgs, inputs, lib, ... }:
let
	extension = shortId: guid: {
    name = guid;
    value = {
      install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
      installation_mode = "normal_installed";
    };
  };
	
  prefs = {
    # Check these out at about:config
  };

	zenExtensions = [
		(extension "bitwarden-password-manager" "{446900e4-71c2-419f-a6a7-df9c091e268b}")
		(extension "foxyproxy-standard" "foxyproxy@eric.h.jung")
		(extension "react-devtools" "@react-devtools")
		(extension "reduxdevtools" "extension@redux.devtools")
		(extension "vue-js-devtools" "{5caff8cc-3d2e-4110-a88a-003cc85b3858}")
		(extension "hoppscotch" "postwoman-firefox@postwoman.io")
		(extension "ublock-origin" "uBlock0@raymondhill.net")
	];

in
{
	home.packages = [
		inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default

		(pkgs.wrapFirefox
      inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.zen-browser-unwrapped

			{
				extraPrefs = lib.concatLines (
					lib.mapAttrsToList (
						name: value: ''lockPref(${lib.strings.toJSON name}, ${lib.strings.toJSON value});''
					) prefs
				);

				extraPolicies = {
					ExtensionSettings = builtins.listToAttrs zenExtensions;
					SearchEngines = {
						Default = "und";
						Add = [
							{
								Name = "nixpkgs packages";
								URLTemplate = "https://search.nixos.org/packages?query={searchTerms}";
								IconURL = "https://wiki.nixos.org/favicon.ico";
								Alias = "@np";
							}
							{
								Name = "NixOS options";
								URLTemplate = "https://search.nixos.org/options?query={searchTerms}";
								IconURL = "https://wiki.nixos.org/favicon.ico";
								Alias = "@no";
							}
							{
								Name = "NixOS Wiki";
								URLTemplate = "https://wiki.nixos.org/w/index.php?search={searchTerms}";
								IconURL = "https://wiki.nixos.org/favicon.ico";
								Alias = "@nw";
							}
							{
								Name = "Undcuk";
								URLTemplate = "https://unduck.link?q={searchTerms}";
								IconURL = "https://unduck.link/search.svg";
								Alias = "@und";
							}
						];
					};
				};
			}
		)

	];
}
