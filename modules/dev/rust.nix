{ config, pkgs, ... }:
{
	home.packages = with pkgs; [
		rustup
		rust-analyzer
		cargo-edit
		cargo-watch
		cargo-expand
		cargo-audit
		cargo-tarpaulin
	];

	home.sessionVariables = {
    RUST_BACKTRACE = "1";
    CARGO_HOME = "$HOME/.cargo";
    PATH = "$CARGO_HOME/bin:$PATH";
    # PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
  };
}
