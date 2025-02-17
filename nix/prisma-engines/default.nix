# This is necessary to control the version of prisma-engines to which
# prisma's behavior is highly sensitive. And the version in nixpkgs
# isn't kept up-to-date.
{ pkgs }:

let
  lib = pkgs.lib;
  versions = {
    "5.20.0" = {
      cargoLockHash = "sha256-Wo5F7jwm0D06CEAvr5a4yS/wHIN+i4wbsza4Wczix8k=";
      outputHashes = {
        "barrel-0.6.6-alpha.0" = "sha256-USh0lQ1z+3Spgc69bRFySUzhuY79qprLlEExTmYWFN8=";
        "cuid-1.3.2" = "sha256-qBu1k/dJiA6rWBwk4nOOqouIneD9h2TTBT8tvs0TDfA=";
        "graphql-parser-0.3.0" = "sha256-0ZAsj2mW6fCLhwTETucjbu4rPNzfbNiHu2wVTBlTNe4=";
        "mysql_async-0.31.3" = "sha256-2wOupQ/LFV9pUifqBLwTvA0tySv+XWbxHiqs7iTzvvg=";
        "postgres-native-tls-0.5.0" = "sha256-4CftieImsG2mBqpoJFfyq0R2yd2EyQX4oddAwyXMDZc=";
        "mongodb-3.0.0" = "sha256-1WQgY0zSZhFjt1nrLYTUBrpqBxpCCgKRSeGJLtkE6pw=";
      };
    };
    "6.2.1" = {
      cargoLockHash = "sha256-QRnM+2LS/2YHodXo4XS2R04wAj+FK/u3rGyIbJPgTb0=";
      outputHashes = {
        "barrel-0.6.6-alpha.0" = "sha256-USh0lQ1z+3Spgc69bRFySUzhuY79qprLlEExTmYWFN8=";
        "cuid-1.3.3" = "sha256-RzbBkiWt6uY0EwPuy71HQ+rZTgvMDtmhxA+SHRL3YMQ=";
        "graphql-parser-0.3.0" = "sha256-0ZAsj2mW6fCLhwTETucjbu4rPNzfbNiHu2wVTBlTNe4=";
        "mysql_async-0.31.3" = "sha256-2wOupQ/LFV9pUifqBLwTvA0tySv+XWbxHiqs7iTzvvg=";
        "postgres-native-tls-0.5.0" = "sha256-pzMPNZzlvMaQqBu/V3ExPYVnoIaALeUaYJ4oo/hY9lA=";
        "mongodb-3.0.0" = "sha256-1WQgY0zSZhFjt1nrLYTUBrpqBxpCCgKRSeGJLtkE6pw=";
      };
    };
    "6.3.1" = {
      cargoLockHash = "sha256-jrZygCIymxdKuMcXs2VLtRhowmYKJvSX5lt5OKfILH8=";
      outputHashes = {
        "barrel-0.6.6-alpha.0" = "sha256-USh0lQ1z+3Spgc69bRFySUzhuY79qprLlEExTmYWFN8=";
        "cuid-1.3.3" = "sha256-RzbBkiWt6uY0EwPuy71HQ+rZTgvMDtmhxA+SHRL3YMQ=";
        "graphql-parser-0.3.0" = "sha256-0ZAsj2mW6fCLhwTETucjbu4rPNzfbNiHu2wVTBlTNe4=";
        "mysql_async-0.31.3" = "sha256-2wOupQ/LFV9pUifqBLwTvA0tySv+XWbxHiqs7iTzvvg=";
        "postgres-native-tls-0.5.0" = "sha256-Qylc/JXMyP5aBPG0Fn62TJZ0KCYQvWzQQ9hDKjd+EVU=";
        "mongodb-3.0.0" = "sha256-1WQgY0zSZhFjt1nrLYTUBrpqBxpCCgKRSeGJLtkE6pw=";
      };
    };
    "unknown" = {
      cargoLockHash = "sha256-BAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
      outputHashes = {
        "barrel-0.6.6-alpha.0" = "sha256-CAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
        "cuid-1.3.3" = "sha256-DAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
        "graphql-parser-0.3.0" = "sha256-EAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
        "mysql_async-0.31.3" = "sha256-FAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
        "postgres-native-tls-0.5.0" = "sha256-1AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
        "mongodb-3.0.0" = "sha256-2AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
      };
    };
  };

  # This greps the pnpm-lock file for a package version
  first = list: if list == null || list == [ ] then null else builtins.elemAt list 0;
  lines = file: lib.splitString "\n" (builtins.readFile file);
  matchVersion =
    package: line: first (builtins.match "  /${package}@([0-9]+\\.[0-9]+\\.[0-9]+).*" line);
  pnpmLockVersion =
    lockFile: package:
    first (builtins.filter (line: line != null) (builtins.map (matchVersion package) (lines lockFile)));
in
with pkgs;
with lib;
with pkgs.darwin;
rustPlatform.buildRustPackage rec {
  pname = "prisma-engines";
  version = pnpmLockVersion ../../pnpm-lock.yaml "@prisma/client";

  src = fetchFromGitHub {
    owner = "prisma";
    repo = "prisma-engines";
    rev = version;
    hash =
      if version == "5.16.1" then
        "sha256-uJJX5lI0YFXygWLeaOuYxjgyswJcjSujPcqHn1aKn8M="
      else if version == "5.20.0" then
        "sha256-XotJPkD7VD1qI8MXPV6g2XFt8Ol83Q0ht7bHlOgpS7E="
      else if version == "6.2.1" then
        "sha256-G+FFwi+USsg3+SiHcYLfy/s+4f1P20fS6Tdem8Zgw8U="
      else if version == "6.3.1" then
        "sha256-gQLDskabTaNk19BJi9Kv4TiEfVck2QZ7xdhopt5KH6M="
      else
        "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  # Use system openssl.
  OPENSSL_NO_VENDOR = 1;

  cargoLock = {
    lockFile = fetchurl {
      url = "https://raw.githubusercontent.com/prisma/prisma-engines/refs/tags/${version}/Cargo.lock";
      name = "prisma-engine-${version}-cargo.lock";
      sha256 = versions.${version}.cargoLockHash;
    };
    outputHashes = versions.${version}.outputHashes;
  };

  nativeBuildInputs = [
    pkg-config
    git
  ];

  buildInputs = [
    openssl
    protobuf
  ] ++ lib.optionals stdenv.isDarwin [ Security ];

  # FIXME: fix this upstream and remove this patch with the next version update.
  postPatch = ''
    file=libs/user-facing-errors/src/schema_engine.rs
    echo "#![allow(dead_code)]" | cat - $file > $file.new
    mv $file.new $file
  '';

  preBuild = ''
    export OPENSSL_DIR=${lib.getDev openssl}
    export OPENSSL_LIB_DIR=${lib.getLib openssl}/lib

    export PROTOC=${protobuf}/bin/protoc
    export PROTOC_INCLUDE="${protobuf}/include";

    export SQLITE_MAX_VARIABLE_NUMBER=250000
    export SQLITE_MAX_EXPR_DEPTH=10000

    export GIT_HASH=0000000000000000000000000000000000000000
  '';

  cargoBuildFlags = [
    "-p"
    "query-engine"
    "-p"
    "query-engine-node-api"
    "-p"
    "schema-engine-cli"
    "-p"
    "prisma-fmt"
  ];

  postInstall = ''
    mv $out/lib/libquery_engine${stdenv.hostPlatform.extensions.sharedLibrary} $out/lib/libquery_engine.node
  '';

  # Tests are long to compile
  doCheck = false;

  meta = with lib; {
    description = "Collection of engines that power the core stack for Prisma";
    homepage = "https://www.prisma.io/";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [
      pimeys
      tomhoule
      ivan
      aqrln
    ];
  };
}
