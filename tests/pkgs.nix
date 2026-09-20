let
  packageUtils = import ../config/pkgs.nix;
in {
  # isValidPackage
  testIsValidPackage_Derivation = {
    expr = packageUtils.isValidPackage {
      name = "gdm-tweaks";
      type = "derivation";
    };
    expected = true;
  };

  testIsValidPackage_EmptyAttrs = {
    expr = packageUtils.isValidPackage {};
    expected = false;
  };

  testIsValidPackage_Null = {
    expr = packageUtils.isValidPackage null;
    expected = false;
  };

  testIsValidPackage_String = {
    expr = packageUtils.isValidPackage "apple-cursor";
    expected = false;
  };

  testIsValidPackage_Int = {
    expr = packageUtils.isValidPackage 42;
    expected = false;
  };
}
