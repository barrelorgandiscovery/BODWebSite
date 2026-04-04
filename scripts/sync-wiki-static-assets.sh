#!/usr/bin/env bash
# Copy wiki-adjacent media from content/wiki into static/wiki so Zola output URLs resolve.
# (Zola does not emit co-located assets from content/ into public/; static/ is copied as-is.)
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
C="$ROOT/content/wiki"
S="$ROOT/static/wiki"
# Optional legacy bundle (e.g. presentation PNGs); create repo/dist/wiki/... if needed
DIST="$ROOT/dist/wiki"

rsync_excludes=(--exclude='*.md' --exclude='*.html' --exclude='*.htm')

sync_dir() {
  local src="$1" dst="$2"
  if [[ -d "$src" ]]; then
    mkdir -p "$dst"
    rsync -a "${rsync_excludes[@]}" "$src/" "$dst/"
  fi
}

mkdir -p "$S/articles/ExportDXF/dxfexport/images"
if [[ -d "$C/articles/ExportDXF/images" ]]; then
  cp -f "$C/articles/ExportDXF/images/"*.png "$S/articles/ExportDXF/dxfexport/images/" 2>/dev/null || true
fi
[[ -f "$C/articles/ExportDXF/dxf_scripts.zip" ]] && cp -f "$C/articles/ExportDXF/dxf_scripts.zip" "$S/articles/ExportDXF/dxfexport/"

sync_dir "$C/articles/Percage_GCode" "$S/articles/Percage_GCode/percage-gcode"
sync_dir "$C/articles/Montage_Cartons" "$S/articles/Montage_Cartons/montage-cartons"
sync_dir "$C/articles/Reconnaissance_Cartons" "$S/articles/Reconnaissance_Cartons/recognitionextension"
sync_dir "$C/articles/Disques" "$S/articles/Disques/creation-instrument-disques-carton"
sync_dir "$C/articles/Articles_Perforatrice/electronique" "$S/articles/Articles_Perforatrice/electronique/electronique"
sync_dir "$C/articles/Articles_Perforatrice/miseaupoint" "$S/articles/Articles_Perforatrice/miseaupoint/mesures"
sync_dir "$C/articles/Articles_Perforatrice/mecanique/jeanpierre/2emeproto" "$S/articles/Articles_Perforatrice/mecanique/jeanpierre/2emeproto"
# Perforatrice logiciel: assets are shared in logiciel/ (not in per-article subfolders)
LOGICIEL="$C/articles/Articles_Perforatrice/logiciel"
if [[ -d "$LOGICIEL" ]]; then
  sync_dir "$LOGICIEL" "$S/articles/Articles_Perforatrice/logiciel/parametrage-machine"
  sync_dir "$LOGICIEL" "$S/articles/Articles_Perforatrice/logiciel/utilisation-perforatrice"
fi
# index_documents.md sits in Articles_Perforatrice/ with co-located PNGs
mkdir -p "$S/articles/Articles_Perforatrice/index-documents"
[[ -f "$C/articles/Articles_Perforatrice/Flag_of_Germany.png" ]] && cp -f "$C/articles/Articles_Perforatrice/Flag_of_Germany.png" "$S/articles/Articles_Perforatrice/index-documents/"
[[ -f "$C/articles/Articles_Perforatrice/doc_traduction.png" ]] && cp -f "$C/articles/Articles_Perforatrice/doc_traduction.png" "$S/articles/Articles_Perforatrice/index-documents/"
sync_dir "$C/articles/Articles_Perforatrice_Lazer" "$S/articles/Articles_Perforatrice_Lazer/setup-perfo-lazer-grbl"
sync_dir "$C/articles/Traduction" "$S/articles/Traduction/traduire-autre-langue"
sync_dir "$C/articles/Nouvelles_Versions/2015" "$S/articles/Nouvelles_Versions/2015/whats-new-aprintstudio-2015"
sync_dir "$C/articles/Nouvelles_Versions/2016" "$S/articles/Nouvelles_Versions/2016/whats-new-aprintstudio-2016"
sync_dir "$C/articles/Nouvelles_Versions/2017" "$S/articles/Nouvelles_Versions/2017/whats-new-aprintstudio-2017"
sync_dir "$C/articles/Nouvelles_Versions/2018" "$S/articles/Nouvelles_Versions/2018/whats-new-aprintstudio-2018"

mkdir -p "$S/articles/creationinstrument"
[[ -f "$C/articles/microphone.jpg" ]] && cp -f "$C/articles/microphone.jpg" "$S/articles/creationinstrument/"

# Presentation 2014: PNGs live in legacy dist bundle (not under content/)
mkdir -p "$S/presentation-aprint-2014"
if [[ -d "$DIST/2014_Presentation_APrint_Studio" ]]; then
  cp -f "$DIST/2014_Presentation_APrint_Studio/"*.png "$S/presentation-aprint-2014/" 2>/dev/null || true
fi

echo "Wiki static assets synced into $S"
