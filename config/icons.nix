{pkgs}: let
  packageUtils = import ./pkgs.nix {inherit pkgs;};
in rec {
  /**
  Checks whether the given value is the name of an attribute
  available in the provided `pkgs` package set.

  This only checks whether the package exists.
  It does not verify that the package is actually a icon theme.

  # Inputs

  `theme`

  : The name of the icon theme package.

  # Type

  ```
  isValidIconTheme :: String -> Bool
  ```

  # Examples
  :::{.example}
  ## `isValidIconTheme` usage example

  ```nix
  isValidIconTheme "exists"
  => true
  isValidIconTheme "does-not-exist"
  => false
  ```
  :::
  */
  isValidIconTheme = theme: packageUtils.isValidPackage theme;

  /**
  Checks whether the given value is a valid string.

  A value is considered to be a valid theme name, if it is `null` or a string.

  # Inputs

  `name`

  : The name of the icon theme.

  # Type

  ```
  isValidIconThemeName :: Null | String -> Bool
  ```

  # Examples
  :::{.example}
  ## `isValidIconThemeName` usage example

  ```nix
  isValidIconThemeName "exists"
  => true
  isValidIconThemeName null
  => true
  isValidIconThemeName 6035
  => false
  ```
  :::
  */
  isValidIconThemeName = name: isNull name || builtins.isString name;

  /**
  Resolves the icon theme configuration from the given options.

  Invalid icon theme names are replaced with `null`.
  Invalid icon theme packages are replaced with `null`.
  Unset values are preserved as `null`.

  The icon theme package is validated against the provided `pkgs` package set.
  The package is not verified to actually provide an icon theme.

  # Inputs

  `name`

  : Optional icon theme name to use. If unset or invalid, `null` is used.

  `theme`

  : Optional icon theme to use. If unset or invalid, `null` is used.

  # Type

  ```
  resolveIcons :: {
    name :: Null | String;
    theme :: Null | String;
  } -> {
    name :: Null | String;
    theme :: Null | String;
  }
  ```

  # Examples
  :::{.example}
  ## `resolveIcons` usage example

  ```nix
  resolveIcons {
    name = "exists";
    theme = "exists";
  }
  => {
    name = "exists";
    theme = "exists";
  }
  resolveIcons {
    name = 6035;
    theme = "does-not-exist";
  }
  => {
    name = null;
    theme = null;
  }
  resolveIcons {
    name = "does-not-exist";
  }
  => {
    name = null;
    theme = null;
  }
  resolveIcons {
    theme = "does-not-exist";
  }
  => {
    name = null;
    theme = null;
  }
  resolveIcons {}
  => {
    name = null;
    theme = null;
  }
  ```
  :::
  */
  resolveIcons = {
    name ? null,
    theme ? null,
  }: let
    resolvedName =
      if isValidIconThemeName name
      then name
      else null;

    resolvedTheme =
      if theme == null
      then null
      else let
        isValid = isValidIconTheme theme;
      in
        if isValid
        then theme
        else null;
  in {
    name = resolvedName;
    theme = resolvedTheme;
  };
}
