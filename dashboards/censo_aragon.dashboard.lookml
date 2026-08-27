# Port of the OBIEE dashboard `Panel de Control - Censo Aragón`.
# Sources (paths stat'd by tools/catalog.py, not assumed — R8.2c: the directory is
# lowercase `Panel de control/` while the filenames carry a capital `Control`, and
# since the iteration-2 export each dashboard sits in its own subdirectory):
#   OBIEE/visualizacion_obiee/Panel de control/Censo Aragón/Panel de Control - Censo Aragón.xml
#   OBIEE/visualizacion_obiee/Panel de control/Censo Aragón/Panel de Control - Layout.xml
#
# The iteration-2 export of this dashboard is semantically identical to iteration 1's
# (R10.3): the only differences are XML entity escaping and the two emoji the cp1252
# export destroyed. It is therefore not re-ported — only its filters changed, because
# the prompt they come from is finally readable.
#
# It hosts the same three analyses that ship as standalone dashboards beside this file
# (poblacion_por_sexo, poblacion_por_sexo_edad_quinquenal, poblacion_por_municipio) —
# `<sawd:reportView>` Report 2, Report 0 and Report 1 respectively — plus the visible
# `Filtro_Poblacion` prompt panel, which becomes the 8 dashboard filters below.
#
# ── BLK-002 IS CLOSED ───────────────────────────────────────────────────────────
# Iteration 1's export of `Petición de datos - Filtro_Poblacion.xml` was a
# byte-identical duplicate of `Análisis - Población por Sexo.xml`, so no label, no
# control and no default was recoverable and every filter here carried a
# `BLK-002 (inferred)` mark. The iteration-2 export is the real prompt definition —
# 8 `saw:columnFilterPrompt` blocks with their labels, UI controls, cardinalities,
# default values and value-list SQL. All of it is ported below and pinned in
# tools/mapping.py FILTRO_POBLACION; tools/check_dashboards.py now grades these
# filters against it by equality rather than merely forbidding invented defaults.
#
# ── BLK-003: V_SET_ANYO is still NOT implemented, on narrower evidence ───────────
# `Panel de Control - Layout.xml:4` declares
#   <sawd:dashboardHiddenPromptRef>/shared/SET/ASENTAMIENTOS/Análisis/V_SET_ANYO</…>
# A *hidden* dashboard prompt from a *different* subject area, still not ported.
# One leg of iteration 1's argument has been knocked out: "zero presentation
# variables anywhere in the estate" is false in this export — V_ANYO and V_EDAD are
# both real (R9.6). The rest stands: every analysis declares subjectArea=TEST_LOOKER
# only, ASENTAMIENTOS appears nowhere else, and V_SET_ANYO is set by nothing here.
# What has changed for the better is the year: `Año Censo` now defaults to 2025
# because the prompt says `<saw:promptDefaultValue>2025</saw:promptDefaultValue>`,
# not because we chose it (R9.2). BLK-003 stays open on V_SET_ANYO alone.
- dashboard: censo_aragon
  # `<sawd:htmlView name="HTML 1">` carries `<h1>📊 Censo anual de población de
  # Aragón</h1>`, and `Panel de Control - Layout.xml` names the page
  # `Censo anual de población`. The heading text is used as the dashboard title, which
  # is the closest LookML has — see the "not expressible" note at the foot of this file.
  title: "Censo anual de población de Aragón"
  layout: newspaper
  description: "Port of the OBIEE dashboard `Panel de Control - Censo Aragón`: the three TEST_LOOKER analyses plus the 8 prompts of Filtro_Poblacion (R9.1), ported from the iteration-2 export with their real labels, controls and defaults."

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
  # Layout follows `Panel de Control - Censo Aragón.xml`'s own column/section order in
  # `<sawd:dashboardColumn name="Column 0">`:
  #   Section 0  reportView "Report 2"  Población por Sexo y Edad (quinquenal)   full width
  #   Section 2  horizontalLayout="true"
  #              reportView "Report 0"  Población por Municipio                  left
  #              reportView "Report 1"  Población por Sexo                       right
  # Widths keep the sources' own proportion: the table's canvas is 1500px and the pie's
  # is 500px, i.e. 3:1, which is 18 and 6 of the 24-column newspaper grid.

  - name: poblacion_por_sexo_edad_quinquenal
    # `<sawd:reportView name="Report 2">`, caption verbatim.
    # Identical to the element in poblacion_por_sexo_edad_quinquenal.dashboard.lookml —
    # including the deliberate `looker_column` (not `looker_bar`) choice documented
    # there: OBIEE's `type="bar"` puts the categories on `axis="X"`, i.e. vertical.
    title: "Población por Sexo y Edad (quinquenal)"
    model: censo_anual
    explore: censo_anual
    type: looker_column
    fields: [dim_edad.edad_grupos_quinquenales, dim_sexo.sexo, fct_censo_anual.personas]
    pivots: [dim_sexo.sexo]
    sorts: [dim_edad.edad_grupos_quinquenales]
    stacking: normal
    series_colors:
      Hombre: "#2986cc"
      Mujer: "#c90076"
    show_legend: true
    listens_to_filters: [sexo, edad_grupos_quinquenales, anno_censo, nacionalidad_pais_nombre,
      residencia_provincia_nombre, residencia_comarca_nombre, residencia_municipio_nombre,
      residencia_municipio_codigo]
    row: 0
    col: 0
    width: 24
    height: 4

  - name: poblacion_por_municipio
    # `<sawd:reportView name="Report 0">`, caption verbatim. Left half of Section 2.
    # Identical to the element in poblacion_por_municipio.dashboard.lookml; the R9.3
    # helper-reuse argument, the BLK-006 Maleján note and the `limit: 5000` rationale
    # are documented there rather than repeated.
    title: "Población por Municipio"
    model: censo_anual
    explore: censo_anual
    type: looker_grid
    fields: [dim_territorio.residencia_municipio_codigo, dim_territorio.residencia_municipio_nombre,
      fct_censo_anual.poblacion_hombres, fct_censo_anual.poblacion_mujeres,
      fct_censo_anual.personas, fct_censo_anual.densidad_municipio]
    series_labels:
      dim_territorio.residencia_municipio_codigo: "Cod. Municipio"
      dim_territorio.residencia_municipio_nombre: "Municipio"
      fct_censo_anual.poblacion_hombres: "Población (Hombres)"
      fct_censo_anual.poblacion_mujeres: "Población (Mujeres)"
      fct_censo_anual.personas: "Población"
      fct_censo_anual.densidad_municipio: "Densidad de población"
    show_totals: true
    show_view_names: false
    sorts: [dim_territorio.residencia_municipio_codigo]
    limit: 5000
    listens_to_filters: [sexo, edad_grupos_quinquenales, anno_censo, nacionalidad_pais_nombre,
      residencia_provincia_nombre, residencia_comarca_nombre, residencia_municipio_nombre,
      residencia_municipio_codigo]
    row: 4
    col: 0
    width: 18
    height: 7

  - name: poblacion_por_sexo
    # `<sawd:reportView name="Report 1">`, caption verbatim. Right of Section 2.
    # NOTE the two titles that differ by one character, both ported as written: the
    # dashboard's reportView caption is `Población por Sexo` and the analysis's own
    # `titleView!1` caption is `Población por sexo`. On the panel, OBIEE shows the
    # reportView caption, so that is what this element carries.
    # Identical otherwise to the element in poblacion_por_sexo.dashboard.lookml.
    title: "Población por Sexo"
    model: censo_anual
    explore: censo_anual
    type: looker_pie
    fields: [dim_sexo.sexo, fct_censo_anual.personas]
    sorts: [dim_sexo.sexo]
    series_colors:
      Hombre: "#2986cc"
      Mujer: "#c90076"
    value_labels: labels
    listens_to_filters: [sexo, edad_grupos_quinquenales, anno_censo, nacionalidad_pais_nombre,
      residencia_provincia_nombre, residencia_comarca_nombre, residencia_municipio_nombre,
      residencia_municipio_codigo]
    row: 4
    col: 18
    width: 6
    height: 7

# ── What this file could NOT express, listed here so it is not mistaken for done ──
#  * The left filter COLUMN. OBIEE freezes a 410px `<sawd:dashboardColumn name="Column
#    1">` with a #EEEEEE background holding the prompt panel beside the content.
#    Looker renders dashboard filters in its own top filter bar; a LookML dashboard has
#    no per-column layout and no way to place filters beside tiles.
#  * The two `<sawd:htmlView>` tiles. `<h1>📊 Censo anual de población de Aragón</h1>`
#    is folded into `title:` above; `<h2>🔎 Filtros</h2>` is dropped, since Looker
#    labels its own filter bar. Both could be re-added as `type: text` elements if the
#    client wants the emoji headings back — they were left out rather than invented,
#    since neither carries data.
#  * `<sawd:dashboardSection name="Section 1">`, an empty 375px spacer under the prompt
#    panel. Nothing to port.
#  * Per-tile styling generally: OBIEE's `hAlign`/`vAlign`/`paddingLeft="50"`/border
#    settings, the grid's `greenBarFormat` alternating #EEEEEE row shading, and the
#    table's black (#000000) dimension headers vs grey (#666666) measure headers have
#    no LookML dashboard equivalent.
#  * The `<saw:tableHeading>` band above the grid's column headings
#    (Lugar de Residencia | Medidas | Indicadores). `show_view_names` is the nearest
#    thing and it shows the LookML view labels, not these captions, so it is off.
