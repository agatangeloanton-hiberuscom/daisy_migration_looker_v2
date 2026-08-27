# Port of the OBIEE analysis `Población por Municipio Formateada` — new in the
# iteration-2 catalog export.
# Source: OBIEE/visualizacion_obiee/Análisis/Análisis - Población por Municipio Formateada.xml
#         (cp1252 bytes behind a utf-8 declaration — read through tools/catalog.py, R10.1)
#
# `Población por Municipio` with two more columns and three conditional formats. It is
# also embedded as `<sawd:reportView name="Report 3">` of `Censo Aragón V2`.
#
# What is new relative to poblacion_por_municipio.dashboard.lookml:
#   * `Sexo_diferencia` — FILTER(Hombre) - FILTER(Mujer), ported as the measure
#     `fct_censo_anual.sexo_diferencia` (R9.7). In OBIEE it is the column the two
#     population conditional formats READ, and it is displayed alongside them.
#   * `% de población de 65 y más años`, formatted percent with 2 decimals.
#   * Three `<saw:conditionalDisplayFormat>` rules — see the block above `fields:`.
#
# ── The year filter: V_ANYO, not `op="prompted"` ────────────────────────────────
# This analysis and `Población por Municipio` are the two that do NOT declare
# `Año Censo` as prompted. They filter `"Año Censo" IN V_ANYO`, the presentation
# variable the `Filtro_Poblacion` prompt sets (R9.2, R9.6). The dashboard filter below
# is the port of both halves at once: setting the filter is setting the variable.
- dashboard: poblacion_por_municipio_formateada
  title: "Población por Municipio Formateada"
  layout: newspaper
  description: "Port of the OBIEE analysis `Población por Municipio Formateada` (subject area TEST_LOOKER). Rendered as a single-element dashboard because LookML has no Look primitive."

  filters:
  # ── R9.1 — the 8 prompts of `Petición de datos - Filtro_Poblacion.xml`, in the
  # order that file declares them (c1, c2, c3, c8, c4, c5, c6, c7), which is the
  # order OBIEE renders them in.
  #
  # BLK-002 IS CLOSED. Iteration 1's export of this file was a byte-identical
  # duplicate of an analysis, so its labels, controls and defaults were all marked
  # inferred. The iteration-2 export is the real prompt: everything below —
  # `title`, `ui_config`, `allow_multiple_values`, `required` and the one
  # `default_value` — is read out of it. See docs/RULEBOOK.md R9.1, R9.2, R9.5 and
  # tools/mapping.py FILTRO_POBLACION, which is where the facts live.
  - name: anno_censo
    title: "Año Censo"
    # OBIEE prompt c1 — Año Censo, dropDown maxChoices=1, required. No saw:label in
    # the export, so OBIEE shows the column caption and so does this.
    # promptDefaultValues=specificValue 2025. Sets the presentation variable V_ANYO.
    # The only prompt that sets a presentation variable, and the only one with a
    # default. Both analyses under `Población por Municipio` read V_ANYO instead of
    # declaring Año Censo as prompted (R9.2).
    type: field_filter
    default_value: '2025'
    allow_multiple_values: false
    required: true
    ui_config:
      type: dropdown_menu
      display: popover
    model: censo_anual
    explore: censo_anual
    field: fct_censo_anual.anno_censo
  - name: residencia_provincia_nombre
    title: "Provincia"
    # OBIEE prompt c2 — Residencia provincia nombre, browse maxChoices=-1,
    # includeAllChoices. promptDefaultValues=allChoices, which is OBIEE for
    # everything — a Looker filter with no default_value. Nothing here scopes the
    # dashboard to Aragón; the data does that.
    type: field_filter
    allow_multiple_values: true
    ui_config:
      type: tag_list
      display: popover
    model: censo_anual
    explore: censo_anual
    field: dim_territorio.residencia_provincia_nombre
  - name: residencia_comarca_nombre
    title: "Comarca"
    # OBIEE prompt c3 — Residencia comarca nombre, browse maxChoices=-1,
    # includeAllChoices. promptDefaultValues=allChoices, which is OBIEE for
    # everything — a Looker filter with no default_value. R5.1 — 'Sin definir' is a
    # real member on 91% of the dimension and will appear in the value list.
    type: field_filter
    allow_multiple_values: true
    ui_config:
      type: tag_list
      display: popover
    model: censo_anual
    explore: censo_anual
    field: dim_territorio.residencia_comarca_nombre
  - name: residencia_municipio_codigo
    title: "Cód. Municipio"
    # OBIEE prompt c8 — Residencia municipio código, browse maxChoices=-1,
    # sqlPromptSource. promptDefaultValues=allChoices, which is OBIEE for everything
    # — a Looker filter with no default_value. Value list restricted to provinces
    # 22/44/50 in the export; ported as suggest_explore on the dimension (R9.5).
    type: field_filter
    allow_multiple_values: true
    ui_config:
      type: tag_list
      display: popover
    model: censo_anual
    explore: censo_anual
    field: dim_territorio.residencia_municipio_codigo
  - name: residencia_municipio_nombre
    title: "Municipio"
    # OBIEE prompt c4 — Residencia municipio nombre, browse maxChoices=-1,
    # sqlPromptSource. promptDefaultValues=allChoices, which is OBIEE for everything
    # — a Looker filter with no default_value. Same province restriction as Cód.
    # Municipio (R9.5).
    type: field_filter
    allow_multiple_values: true
    ui_config:
      type: tag_list
      display: popover
    model: censo_anual
    explore: censo_anual
    field: dim_territorio.residencia_municipio_nombre
  - name: nacionalidad_pais_nombre
    title: "País de origen"
    # OBIEE prompt c5 — Nacionalidad país nombre, browse maxChoices=-1,
    # includeAllChoices. promptDefaultValues=allChoices, which is OBIEE for
    # everything — a Looker filter with no default_value.
    type: field_filter
    allow_multiple_values: true
    ui_config:
      type: tag_list
      display: popover
    model: censo_anual
    explore: censo_anual
    field: dim_pais.nacionalidad_pais_nombre
  - name: sexo
    title: "Sexo"
    # OBIEE prompt c6 — Sexo, browse maxChoices=-1, includeAllChoices. No saw:label
    # in the export, so OBIEE shows the column caption and so does this.
    # promptDefaultValues=allChoices, which is OBIEE for everything — a Looker
    # filter with no default_value.
    type: field_filter
    allow_multiple_values: true
    ui_config:
      type: tag_list
      display: popover
    model: censo_anual
    explore: censo_anual
    field: dim_sexo.sexo
  - name: edad_grupos_quinquenales
    title: "Edad"
    # OBIEE prompt c7 — Edad (grupos quinquenales), browse maxChoices=-1,
    # includeAllChoices. promptDefaultValues=allChoices, which is OBIEE for
    # everything — a Looker filter with no default_value.
    type: field_filter
    allow_multiple_values: true
    ui_config:
      type: tag_list
      display: popover
    model: censo_anual
    explore: censo_anual
    field: dim_edad.edad_grupos_quinquenales

  elements:
  - name: poblacion_por_municipio_formateada
    # `<saw:tableView>` → looker_grid. The eight columns in the XML's own order:
    #
    #   c3f86cd3cfd6495cb  "Lugar de Residencia"."Residencia municipio código"
    #   ca4d9d014d41be794  "Lugar de Residencia"."Residencia municipio nombre"
    #   c905daa8e4ea393a9  FILTER(Personas USING Sexo = 'Hombre')
    #   cebd1374b5acd1ac4  FILTER(Personas USING Sexo = 'Mujer')
    #   c87da0157ddc02bab  "Medidas"."Personas"
    #   cac82e19b9fe1a640  FILTER(… 'Hombre') - FILTER(… 'Mujer')     → R9.7
    #   c485267e440323d1a  "Indicadores"."Densidad de población (municipio)"
    #   cc066f39b5e762c2d  "Indicadores"."% de población de 65 y más años"
    #
    # R9.3 governs the two FILTER columns exactly as in poblacion_por_municipio: they
    # are the visible twins of the R2 helpers, not new FILTERs. R9.7 governs their
    # difference. `densidad_municipio` is the GUARDED variant (R4.3), and BLK-006's
    # Maleján (50156, area 0) surfaces here too — the cell comes back empty rather
    # than killing the tile, because of R4.6's row-level guard in the mart.
    title: "Población por Municipio Formateada"
    model: censo_anual
    explore: censo_anual
    type: looker_grid
    fields: [dim_territorio.residencia_municipio_codigo, dim_territorio.residencia_municipio_nombre,
      fct_censo_anual.poblacion_hombres, fct_censo_anual.poblacion_mujeres,
      fct_censo_anual.personas, fct_censo_anual.sexo_diferencia,
      fct_censo_anual.densidad_municipio, fct_censo_anual.pct_poblacion_65_mas_annos]
    # `<saw:columnHeading><saw:caption>` for each column, verbatim.
    series_labels:
      dim_territorio.residencia_municipio_codigo: "Cod. Municipio"
      dim_territorio.residencia_municipio_nombre: "Municipio"
      fct_censo_anual.poblacion_hombres: "Población (Hombres)"
      fct_censo_anual.poblacion_mujeres: "Población (Mujeres)"
      fct_censo_anual.personas: "Población"
      fct_censo_anual.sexo_diferencia: "Sexo_diferencia"
      fct_censo_anual.densidad_municipio: "Densidad de población"
      fct_censo_anual.pct_poblacion_65_mas_annos: "% 65 y más años"
    # ── The three conditional formats, and the two that had to change shape ───────
    # OBIEE declares (`<saw:conditionalDisplayFormat>`, one per column):
    #   Población (Hombres)  when cac82e19b9fe1a640 > 0  → #336699 bold + mas.png
    #   Población (Mujeres)  when cac82e19b9fe1a640 < 0  → #663366 bold + fem.png
    #   % 65 y más años      when itself >= 25           → #CC3333 bold
    #
    # The third ports exactly: the rule reads the column it paints, which is the only
    # shape `conditional_formatting` has. `pct_poblacion_65_mas_annos` is on a 0-100
    # scale (R3.4 multiplies by 100.0), so OBIEE's 25 is Looker's 25 — no rescaling.
    #
    # The first two read a DIFFERENT column (`Sexo_diferencia`) than the one they
    # paint. A LookML dashboard cannot express that: `conditional_formatting` tests a
    # field's own value, and cross-column painting needs Liquid `html:` on the measure
    # itself — which would colour that measure on every dashboard that uses it, while
    # OBIEE's formatting is per-analysis. So the same two rules are applied to
    # `Sexo_diferencia`, the column that actually carries the condition, in the same
    # two colours: blue where men outnumber women, purple where women outnumber men.
    # The information survives; its location moves one column. The two icons
    # (`cmap:/shared/custom/images/mas.png`, `fem.png`) are OBIEE server assets and
    # are not in the export at all — see the foot of this file.
    conditional_formatting:
    - type: greater than
      value: 0
      font_color: "#336699"
      bold: true
      fields: [fct_censo_anual.sexo_diferencia]
    - type: less than
      value: 0
      font_color: "#663366"
      bold: true
      fields: [fct_censo_anual.sexo_diferencia]
    - type: greater than or equal to
      value: 25
      font_color: "#CC3333"
      bold: true
      fields: [fct_censo_anual.pct_poblacion_65_mas_annos]
    # `<saw:displayGrandTotals grandTotalPosition="after">`.
    show_totals: true
    show_view_names: false
    # INFERRED, as in poblacion_por_municipio: the XML declares no sort, and ascending
    # municipio code is the row-edge order OBIEE returns for this table.
    sorts: [dim_territorio.residencia_municipio_codigo]
    # INFERRED and load-bearing, as in poblacion_por_municipio: the OBIEE table
    # scrolls unbounded, and Looker's default limit of 500 would truncate 731
    # territories and the grand total with them.
    limit: 5000
    listens_to_filters: [sexo, edad_grupos_quinquenales, anno_censo, nacionalidad_pais_nombre,
      residencia_provincia_nombre, residencia_comarca_nombre, residencia_municipio_nombre,
      residencia_municipio_codigo]
    row: 0
    col: 0
    width: 24
    height: 7

# ── What this file could NOT express ────────────────────────────────────────────
#  * The two conditional-format ICONS. `image="cmap:/shared/custom/images/mas.png"`
#    and `fem.png` are files on the OBIEE server, absent from the catalog export, and
#    a LookML grid cannot place an image beside a cell value regardless.
#  * Painting `Población (Hombres)` / `(Mujeres)` from `Sexo_diferencia`'s sign —
#    moved onto `Sexo_diferencia` itself, as the block above `fields:` explains.
#  * `suppress="repeat"`, which blanks a repeated value in an OBIEE column.
#    looker_grid has no per-column repeat suppression.
#  * The `<saw:tableHeading>` band (Lugar de Residencia | Medidas | Indicadores), for
#    the same reason as in poblacion_por_municipio.dashboard.lookml.
