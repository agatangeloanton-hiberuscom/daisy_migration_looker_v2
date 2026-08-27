# Port of the OBIEE dashboard `Panel de Control - Censo Aragón V2` — new in the
# iteration-2 catalog export.
# Sources:
#   OBIEE/visualizacion_obiee/Panel de control/Censo Aragón V2/Panel de Control - Censo Aragón V2.xml
#   OBIEE/visualizacion_obiee/Panel de control/Censo Aragón V2/Panel de Control - Layout V2.xml
#
# V2 is `Censo Aragón` plus three things: the two new analyses, the `Variable_Edad`
# prompt that switches between them, and a hand-written HTML/CSS/JS KPI card. Its
# `<sawd:dashboardColumn>` / `<sawd:dashboardSection>` order is:
#
#   Column 1 (frozen, 380px, #EEEEEE)
#     Section 11  HTML 0   "<h2>… Filtros</h2>"
#                 GFP 1    Filtro_Poblacion            → the 8 dashboard filters
#     Section 1   HTML 2   the KPI card                → the single_value tile below
#   Column 0
#     Section 3   HTML 1   "<h1>… Censo anual de población de Aragón</h1>"
#                 GFP 0    Variable_Edad               → the `edad_variable` filter
#     Section 0   Report 2 Población por Sexo y Edad (quinquenal)
#     Section 5   Report 4 Población por Sexo y Edad (Grandes grupos)
#     Section 2   Report 3 Población por Municipio Formateada   (horizontalLayout)
#                 Report 1 Población por Sexo                   (horizontalLayout)
#
# ── The title ───────────────────────────────────────────────────────────────────
# The `<h1>` is character-for-character the one on `Censo Aragón`, so the two
# dashboards would deploy under the same name and be told apart only by their URL.
# The catalog distinguishes them (`Censo Aragón` / `Censo Aragón V2`), so the suffix
# is carried into the title. That is a naming choice, and the only one in this file.
#
# ── R10.2: the leading emoji is NOT ported ──────────────────────────────────────
# Both headings open with a byte 0xbf where iteration 1's clean UTF-8 export has an
# emoji (`📊`, `🔎`). The cp1252 export destroyed them, and V2 has no iteration-1
# counterpart to recover them from — unlike `Censo Aragón`, which does. So the text
# is ported without it rather than with a `¿` that was never in the source.
- dashboard: censo_aragon_v2
  title: "Censo anual de población de Aragón (V2)"
  layout: newspaper
  description: "Port of the OBIEE dashboard `Panel de Control - Censo Aragón V2`: the KPI card, the Variable_Edad age-grouping switch (R9.6) and the four embedded analyses, with the 8 prompts of Filtro_Poblacion (R9.1)."

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
  # ── GFP 0 — `Petición de datos - Variable_Edad.xml` (R9.6) ─────────────────────
  # A `saw:variablePrompt`, not a column prompt: it sets the presentation variable
  # V_EDAD and filters nothing by itself. Ported as a filter on the LookML parameter
  # `dim_edad.edad_variable`, whose two allowed values are the prompt's two
  # `saw:promptChoice` captions and whose default is its `promptDefaultValues`.
  # `radio_buttons` is the port of `<saw:promptUIControl xsi:type="saw:radioButton"
  # maxChoices="1">`. This is the ONLY page that carries this prompt, which is why it
  # is the only page whose tiles are gated on it.
  - name: edad_variable
    title: "Mostrar edad"
    type: field_filter
    default_value: 'Grupo quinquenal'
    allow_multiple_values: false
    ui_config:
      type: radio_buttons
      display: inline
    model: censo_anual
    explore: censo_anual
    field: dim_edad.edad_variable

  elements:
  # ── Section 1 / HTML 2 — the KPI card ─────────────────────────────────────────
  # In OBIEE this is 250 lines of hand-written HTML, CSS and JavaScript: a styled card
  # whose script walks the rendered tables in the DOM, sums the population column and
  # writes the total into the card, with a light/dark theme and a mobile breakpoint.
  # None of that ports — a LookML dashboard cannot carry a script, and it should not:
  # the number the script computes is `SUM(Personas)` under the same filters, which is
  # a query. So the card ports as what it displays, a single-value tile, and the
  # styling is logged as unexpressible at the foot of this file.
  - name: poblacion_total
    title: "Población total"
    model: censo_anual
    explore: censo_anual
    type: single_value
    fields: [fct_censo_anual.personas]
    listens_to_filters: [sexo, edad_grupos_quinquenales, anno_censo, nacionalidad_pais_nombre,
      residencia_provincia_nombre, residencia_comarca_nombre, residencia_municipio_nombre,
      residencia_municipio_codigo]
    row: 0
    col: 0
    width: 6
    height: 3

  # ── Section 0 / Report 2 — the quinquenal analysis, gated on V_EDAD ───────────
  # Identical to the element in poblacion_por_sexo_edad_quinquenal.dashboard.lookml,
  # with one addition: `dim_edad.mostrar_grupo_quinquenal: "Yes"`. That is the port of
  # the analysis's own ninth filter, `'Grupo quinquenal' IN V_EDAD` — on this page the
  # prompt sets V_EDAD, so the tile returns rows only while the user has the switch on
  # `Grupo quinquenal`, exactly as OBIEE behaves. It listens to `edad_variable` so the
  # parameter reaches the gate; without that the gate would read its default forever.
  - name: poblacion_por_sexo_edad_quinquenal
    title: "Población por Sexo y Edad (quinquenal)"
    model: censo_anual
    explore: censo_anual
    type: looker_column
    fields: [dim_edad.edad_grupos_quinquenales, dim_sexo.sexo, fct_censo_anual.personas]
    pivots: [dim_sexo.sexo]
    filters:
      dim_edad.mostrar_grupo_quinquenal: "Yes"
    sorts: [dim_edad.edad_grupos_quinquenales]
    stacking: normal
    series_colors:
      Hombre: "#2986cc"
      Mujer: "#c90076"
    show_legend: true
    listens_to_filters: [sexo, edad_grupos_quinquenales, anno_censo, nacionalidad_pais_nombre,
      residencia_provincia_nombre, residencia_comarca_nombre, residencia_municipio_nombre,
      residencia_municipio_codigo, edad_variable]
    row: 3
    col: 0
    width: 24
    height: 4

  # ── Section 5 / Report 4 — the grandes-grupos analysis, gated the other way ───
  # The mirror of the tile above: `'Grupo grande' IN V_EDAD`. Exactly one of the two
  # renders at a time, which is what the switch is for.
  - name: poblacion_por_sexo_edad_grandes_grupos
    title: "Población por Sexo y Edad (Grandes grupos)"
    model: censo_anual
    explore: censo_anual
    type: looker_column
    fields: [dim_edad.edad_grandes_grupos, dim_sexo.sexo, fct_censo_anual.personas]
    pivots: [dim_sexo.sexo]
    filters:
      dim_edad.mostrar_grupo_grande: "Yes"
    sorts: [dim_edad.edad_grandes_grupos]
    stacking: normal
    series_colors:
      Hombre: "#2986cc"
      Mujer: "#c90076"
    show_legend: true
    listens_to_filters: [sexo, edad_grupos_quinquenales, anno_censo, nacionalidad_pais_nombre,
      residencia_provincia_nombre, residencia_comarca_nombre, residencia_municipio_nombre,
      residencia_municipio_codigo, edad_variable]
    row: 7
    col: 0
    width: 24
    height: 4

  # ── Section 2 / Report 3 + Report 1 — horizontalLayout="true" ─────────────────
  # The same 3:1 proportion `Censo Aragón` uses for its own Section 2: the grid's
  # canvas is 1500px and the pie's 500px, i.e. 18 and 6 of the 24-column grid.
  # Both elements are identical to their standalone dashboards; the conditional
  # formatting rationale for the grid is documented in
  # poblacion_por_municipio_formateada.dashboard.lookml rather than repeated here.
  - name: poblacion_por_municipio_formateada
    title: "Población por Municipio Formateada"
    model: censo_anual
    explore: censo_anual
    type: looker_grid
    fields: [dim_territorio.residencia_municipio_codigo, dim_territorio.residencia_municipio_nombre,
      fct_censo_anual.poblacion_hombres, fct_censo_anual.poblacion_mujeres,
      fct_censo_anual.personas, fct_censo_anual.sexo_diferencia,
      fct_censo_anual.densidad_municipio, fct_censo_anual.pct_poblacion_65_mas_annos]
    series_labels:
      dim_territorio.residencia_municipio_codigo: "Cod. Municipio"
      dim_territorio.residencia_municipio_nombre: "Municipio"
      fct_censo_anual.poblacion_hombres: "Población (Hombres)"
      fct_censo_anual.poblacion_mujeres: "Población (Mujeres)"
      fct_censo_anual.personas: "Población"
      fct_censo_anual.sexo_diferencia: "Sexo_diferencia"
      fct_censo_anual.densidad_municipio: "Densidad de población"
      fct_censo_anual.pct_poblacion_65_mas_annos: "% 65 y más años"
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
    show_totals: true
    show_view_names: false
    sorts: [dim_territorio.residencia_municipio_codigo]
    limit: 5000
    listens_to_filters: [sexo, edad_grupos_quinquenales, anno_censo, nacionalidad_pais_nombre,
      residencia_provincia_nombre, residencia_comarca_nombre, residencia_municipio_nombre,
      residencia_municipio_codigo]
    row: 11
    col: 0
    width: 18
    height: 7

  - name: poblacion_por_sexo
    # `<sawd:reportView name="Report 1">`, caption verbatim — and, as on `Censo
    # Aragón`, note that the analysis's own titleView caption is `Población por sexo`
    # with a lowercase s. OBIEE shows the reportView caption on the panel.
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
    row: 11
    col: 18
    width: 6
    height: 7

# ── What this file could NOT express, listed so it is not mistaken for done ──────
#  * The KPI card's presentation. `<sawd:htmlView name="HTML 2">` carries a styled
#    card (border, shadow, uppercase label, status dot), a `html.oas-dark-mode` theme
#    and a `@media (max-width: 600px)` breakpoint, plus the JavaScript that scrapes
#    the rendered tables to compute the number. A LookML dashboard has no HTML tile
#    and runs no script; `single_value` shows the same number from a query instead.
#  * The frozen 380px filter COLUMN, as on `Censo Aragón`: Looker renders dashboard
#    filters in its own bar and has no per-column layout.
#  * The two `<sawd:htmlView>` headings. The `<h1>` becomes `title:`; the `<h2>`
#    Filtros heading is dropped, since Looker labels its own filter bar.
#  * Section widths and paddings generally (`width="380"`, `paddingTop="50"`,
#    `backgroundColor="#EEEEEE"`), which have no LookML dashboard equivalent.
