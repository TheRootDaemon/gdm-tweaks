let
  fixture = {
    "adwaita-icon-theme" = {};
    "bibata-cursors" = {};
    "papirus-icon-theme" = {};
  };

  packageUtils = import ../config/pkgs.nix {pkgs = fixture;};
in {
  # isValidPackage
  testIsValidPackage_Exists = {
    expr = packageUtils.isValidPackage "adwaita-icon-theme";
    expected = true;
  };

  testIsValidPackage_DoesNotExist = {
    expr = packageUtils.isValidPackage "does-not-exist";
    expected = false;
  };

  testIsValidPackage_EmptyString = {
    expr = packageUtils.isValidPackage "";
    expected = false;
  };

  testIsValidPackage_NotAString = {
    expr = packageUtils.isValidPackage 42;
    expected = false;
  };

  testIsValidPackage_Null = {
    expr = packageUtils.isValidPackage null;
    expected = false;
  };
}
