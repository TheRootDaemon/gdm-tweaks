{
  pkgs,
  gnomeShell,
  background,
}:

''
# create a directory for the final output
mkdir -p "$out/share/gnome-shell"

# copy the stock gnome-shell data into the output,
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

    # make sure the parent sub-directories exist
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

for css in *.css; do
  # apply the gdm-specific styles to every extracted gnome-shell resource
  #
  # the login dialog is made transparent,
  # while the lock dialog uses the `background`
  # resource as its full-screen background
  cat >> "$css" << 'CSS_EOF'
.login-dialog {
  background: transparent;
}

#lockDialogGroup {
  background-image: url('resource:///org/gnome/shell/theme/background');
  background-position: center;
  background-size: cover;
}
CSS_EOF
done

# embed the background into the bundle
# as the resource named `background`
${
  if background != null
  then ''
    cp ${background} background
  ''
  else ""
}

{
  # generate gresource manifest for all extracted theme files
  #
  # the manifest maps files from the `tmp` directory to resources
  # under the `/org/gnome/shell/theme` prefix in the compiled bundle
  echo '<?xml version="1.0" encoding="UTF-8"?>'
  echo '<gresources>'
  echo '  <gresource prefix="/org/gnome/shell/theme">'

  # add every extracted file to the manifest,
  # removing the `./` prefix
  for f in $(find . -type f ! -name theme.gresource.xml | sort); do
    echo "    <file>''${f#./}</file>"
  done

  echo '  </gresource>'
  echo '</gresources>'
} > theme.gresource.xml

# compile the modified theme files into a gresource bundle
${pkgs.glib.dev}/bin/glib-compile-resources \
  --sourcedir . \
  --target "$out/share/gnome-shell/gnome-shell-theme.gresource" \
  theme.gresource.xml
''
