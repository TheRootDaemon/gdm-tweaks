{
  pkgs,
  gnomeShell ? pkgs.gnome-shell,
}:
pkgs.stdenv.mkDerivation {
  pname = "gdm-tweaks";
  version = "0.1.0";

  nativeBuildInputs = [
    pkgs.glib.dev
  ];

  buildCommand = ''
    # create a directory for the final output
    mkdir -p "$out/share/gnome-shell"

    # copy the stock gnome-shell data into out output,
    # we'll replace the ones we want later
    # for now we'll preserve gnome-shell resources
    cp -r "${gnomeShell}/share/gnome-shell/." "$out/share/gnome-shell/"

    tmp=$(mktemp -d)
    cd "$tmp"

    ${pkgs.glib.dev}/bin/gresource list \
      ${gnomeShell}/share/gnome-shell/gnome-shell-theme.gresource |
      while read -r resourcePath; do
        # resourcePath will be something like this:
        #
        #   /org/gnome/shell/theme/{{subDirectory}}/{{resource}}
        #
        # we'll only need the part relative to the theme directory
        # so we'll trim the prefix to get something like this:
        #
        #   {{subDirectory}}/{{resource}}
        name=''${resourcePath#/org/gnome/shell/theme/}

        # make sure the parent sub_directories exist
        mkdir -p "$(dirname "$name")"


        # extract the resource from the compiled gresource bundle
        # and write its contents to the corresponding file
        # in the temporary directory
        #
        #   resourcePath = /org/gnome/shell/theme/{{resource}}
        #   name = {{resource}}
        #
        # for example, if the resource is `gnome-shell-dark.css`
        # the contents will be extracted and redirected to `$name`
        #
        #   /org/gnome/shell/theme/gnome-shell-dark.css -> "$tmp"/gnome-shell-dark.css
        ${pkgs.glib.dev}/bin/gresource extract \
          "${gnomeShell}/share/gnome-shell/gnome-shell-theme.gresource" \
          "$resourcePath" > "$name"
      done
  '';
}
