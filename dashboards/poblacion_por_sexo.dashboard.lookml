# Phase 5 content — port of the OBIEE analysis `Población por Sexo`.
# Source: OBIEE/visualizacion_obiee/Análisis/Análisis - Población por Sexo.xml
#
# WHY THIS IS A DASHBOARD AND NOT A "LOOK".
# The migration plan (§5 Phase 5) calls for "the 3 analyses as Looks". LookML has no
# Look primitive: a Look is a user-created object stored in the Looker instance's
# internal database, not a file a project can contain. The nearest thing a LookML
# project can hold — and the only one that is version-controlled, reviewable and
# deployable the way this migration requires — is a single-element LookML dashboard,
# which is independently viewable and linkable exactly as a Look is. So this file is
# ONE analysis, not a change of scope. It is also embedded, unchanged, as an element of
# censo_aragon.dashboard.lookml, which is what `Panel de Control - Censo Aragón` does
# with it (reportView "Report 1").
#
# The 8 filters are the prompts of `Petición de datos - Filtro_Poblacion.xml`, which
# this analysis declares `op="prompted"` (R9.1). They are repeated on every dashboard
# because each analysis declares its own 8 — and because without the `Año Censo`
# filter the element would sum all five census years, 2021–2025, which the OBIEE
# dashboard never shows. Their labels, controls and the 2025 default are ported from
# the iteration-2 export, not inferred: BLK-002 is closed. See
# censo_aragon.dashboard.lookml.
- dashboard: poblacion_por_sexo
  title: "Población por Sexo"
  layout: newspaper
  description: "Port of the OBIEE analysis `Población por Sexo` (subject area TEST_LOOKER). Rendered as a single-element dashboard because LookML has no Look primitive."

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
  - name: poblacion_por_sexo
    # `<saw:dvtchart> <saw:display type="pie" subtype="default">` → looker_pie.
    # Title is the analysis's own `titleView!1` caption, verbatim (lowercase `sexo`).
    title: "Población por sexo"
    model: censo_anual
    explore: censo_anual
    type: looker_pie
    # `<saw:measures><saw:column measureType="pie">` → columnID c87da0157ddc02bab =
    #   "Medidas"."Personas"                              → fct_censo_anual.personas
    # `<saw:seriesGenerators>`                → columnID c51dd82505b462219 =
    #   "Edad y Sexo"."Sexo"                              → dim_sexo.sexo
    # `<saw:categories>` holds only `<saw:measureLabels/>`, i.e. no category column —
    # which is what makes this a one-dimension pie rather than a series of pies.
    fields: [dim_sexo.sexo, fct_censo_anual.personas]
    # INFERRED. The XML declares no sort. Ascending `Sexo` gives Hombre, Mujer — the
    # order the chart's own `<saw:seriesCondition position="1">` / `position="2"` colour
    # rules assume, so this reproduces the OBIEE rendering rather than inventing one.
    sorts: [dim_sexo.sexo]
    # `<saw:visualFormat color="#2986cc"/>` at series position 1, `#c90076` at
    # position 2. Ported by value rather than by position — DIM_SEXO_DATA_TABLE.csv is
    # exactly 3 rows (1 Hombre, 6 Mujer, 0 Desconocido/a) and the sort above puts
    # Hombre first, so position 1 = Hombre. Desconocido/a carries no OBIEE colour.
    series_colors:
      Hombre: "#2986cc"
      Mujer: "#c90076"
    # `<saw:legendFormat position="none">` + `<saw:dataLabels display="always"
    # position="outsidewithleader">` → labels on the slices, no legend.
    # `label_type` is deliberately NOT set: OBIEE's `valueAs="default"` does not
    # unambiguously mean value or percentage, so Looker's default stands rather than a
    # guess. Flagged in the migration report.
    value_labels: labels
    listens_to_filters: [sexo, edad_grupos_quinquenales, anno_censo, nacionalidad_pais_nombre,
      residencia_provincia_nombre, residencia_comarca_nombre, residencia_municipio_nombre,
      residencia_municipio_codigo]
    # `<saw:canvasFormat height="350" width="500">`. Newspaper rows are 50px, so
    # height 7 = 350px. Width is the full 24-column grid: the OBIEE 500px is the width
    # it had sharing a row with the municipio table on the panel, not standalone.
    row: 0
    col: 0
    width: 24
    height: 7
