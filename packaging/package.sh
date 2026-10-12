#!/usr/bin/env bash
# Uso: packaging/package.sh <versão> <deb|msi|dmg|app-image>
set -euo pipefail

VERSION="${1:?informe a versão, ex.: 1.0.0}"
TYPE="${2:?informe o tipo: deb, msi, dmg ou app-image}"
APP_VERSION="${VERSION%%-*}"

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD="$ROOT/packaging/build"
DIST="$ROOT/packaging/dist"
APP_NAME="ATS Resume Optimizer"
PACKAGE_NAME="ats-resume-optimizer"
WIN_UPGRADE_UUID="5b0c6a7e-3f0e-4d55-9a7b-2a4c1e8d9f31"
# jdeps acha os módulos usados direto; os demais entram por reflexão ou SPI (locale pt-BR, charsets, cripto, zip).
MODULES="java.base,java.compiler,java.desktop,java.instrument,java.management,java.naming,java.net.http,java.prefs,java.rmi,java.scripting,java.security.jgss,java.sql.rowset,java.xml.crypto,jdk.charsets,jdk.crypto.ec,jdk.jfr,jdk.localedata,jdk.management,jdk.naming.dns,jdk.net,jdk.unsupported,jdk.zipfs"

rm -rf "$BUILD" "$DIST"
mkdir -p "$BUILD/input" "$DIST"

(cd "$ROOT/front" && npm ci && npm run build:desktop)
(cd "$ROOT/backend" && ./mvnw -B -ntp -Pdesktop -Drevision="$VERSION" -DskipTests package)
cp "$ROOT/backend/target/ats-resume-optimizer-backend-$VERSION.jar" "$BUILD/input/app.jar"

common=(
	--name "$APP_NAME"
	--app-version "$APP_VERSION"
	--vendor "Diego Haefliger"
	--description "Analisa e adapta currículos para passar nos filtros de ATS"
	--copyright "Copyright (c) 2026 Diego Haefliger"
	--input "$BUILD/input"
	--main-jar app.jar
	--add-modules "$MODULES"
	--jlink-options "--strip-debug --no-man-pages --no-header-files"
	--java-options "-Dspring.profiles.active=desktop"
	--dest "$BUILD/out"
)

case "$TYPE" in
	deb)
		jpackage "${common[@]}" --type deb \
			--icon "$ROOT/packaging/icons/app.png" \
			--linux-package-name "$PACKAGE_NAME" \
			--linux-shortcut \
			--linux-menu-group Office \
			--linux-app-category office \
			--license-file "$ROOT/LICENSE"
		;;
	msi)
		jpackage "${common[@]}" --type msi \
			--icon "$ROOT/packaging/icons/app.ico" \
			--win-per-user-install \
			--win-menu \
			--win-menu-group "$APP_NAME" \
			--win-shortcut \
			--win-upgrade-uuid "$WIN_UPGRADE_UUID" \
			--license-file "$ROOT/LICENSE"
		;;
	dmg)
		jpackage "${common[@]}" --type app-image \
			--icon "$ROOT/packaging/icons/app.icns" \
			--mac-package-identifier com.diegohaefliger.atsresumeoptimizer
		# Sem assinatura nenhuma o macOS diz "app danificado"; com ad-hoc o usuário consegue liberar em Ajustes.
		codesign --force --deep --sign - "$BUILD/out/$APP_NAME.app"
		jpackage --type dmg --name "$APP_NAME" --app-version "$APP_VERSION" \
			--app-image "$BUILD/out/$APP_NAME.app" \
			--license-file "$ROOT/LICENSE" \
			--dest "$BUILD/dmg"
		mv "$BUILD/dmg/"*.dmg "$BUILD/out/"
		;;
	app-image)
		jpackage "${common[@]}" --type app-image --icon "$ROOT/packaging/icons/app.png"
		;;
	*)
		echo "Tipo desconhecido: $TYPE" >&2
		exit 1
		;;
esac

if [ "$TYPE" != app-image ]; then
	arch="$(uname -m | sed 's/x86_64/x64/; s/amd64/x64/; s/aarch64/arm64/')"
	for file in "$BUILD/out/"*."$TYPE"; do
		mv "$file" "$DIST/$PACKAGE_NAME-$VERSION-$arch.$TYPE"
	done
	ls -l "$DIST"
fi
