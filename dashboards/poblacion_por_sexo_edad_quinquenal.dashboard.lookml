# Phase 5 content — port of the OBIEE analysis `Población por Sexo y Edad (quinquenal)`.
# Source: OBIEE/visualizacion_obiee/Análisis/Análisis - Población por Sexo y Edad (quinquenal).xml
#         (R8.2c — parenthesised, lowercase `quinquenal`; the path was stat'd, not assumed)
#
# WHY THIS IS A DASHBOARD AND NOT A "LOOK".
# The migration plan (§5 Phase 5) calls for "the 3 analyses as Looks". LookML has no
# Look primitive: a Look is a user-created object stored in the Looker instance's
# internal database, not a file a project can contain. The nearest thing a LookML
# project can hold — and the only one that is version-controlled, reviewable and
# deployable the way this migration requires — is a single-element LookML dashboard,
# which is independently viewable and linkable exactly as a Look is. So this file is
# ONE analysis, not a change of scope. It is also embedded, unchanged, as an element of
# censo_aragon.dashboard.lookml (reportView "Report 2").
#
# The 8 filters are the prompts of `Petición de datos - Filtro_Poblacion.xml`, which
# this analysis declares `op="prompted"` (R9.1), ported with their real labels and
# controls now that BLK-002 is closed. Full discussion in censo_aragon.dashboard.lookml.
#
# ── V_EDAD is deliberately NOT gated here (R9.6) ────────────────────────────────
# This analysis carries a ninth filter OBIEE writes as
# `'Grupo quinquenal' IN V_EDAD` with `sawx:eval default="Grupo quinquenal"`. On a
# page that does not show the `Variable_Edad` prompt — this standalone dashboard, and
# `Censo Aragón` — nothing sets V_EDAD, so the analysis's own eval default governs and
# the condition is always true. Gating this tile on the parameter would therefore
# change behaviour rather than port it. The gate belongs where OBIEE puts the prompt:
# `Censo Aragón V2`, which shows this analysis and the grandes-grupos one side by side
# and lets the user switch between them.
- dashboard: poblacion_por_sexo_edad_quinquenal
  title: "Población por Sexo y Edad (quinquenal)"
  layout: newspaper
  description: "Port of the OBIEE analysis `Población por Sexo y Edad (quinquenal)` (subject area TEST_LOOKER). Rendered as a single-element dashboard because LookML has no Look primitive."

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
  - name: poblacion_por_sexo_edad_quinquenal
    # `<saw:dvtchart> <saw:display type="bar" subtype="stacked">`.
    #
    # DELIBERATE DEPARTURE FROM THE BRIEF: `looker_column`, not `looker_bar`.
    # In Looker `looker_bar` draws HORIZONTAL bars and `looker_column` draws vertical
    # ones. The source is vertical: `<saw:axesFormats>` puts the rotatable, 9pt,
    # skip-enabled category labels on `axis="X"` and leaves `axis="Y1"` bare, and the
    # canvas is 1250 wide × 200 tall — 21 quinquenal groups laid out left to right.
    # `looker_bar` would rotate the age axis 90° and change what the user sees.
    # Flagged in the Phase 5 report; revert to `looker_bar` if the client disagrees.
    title: "Población por Sexo y Edad (quinquenal)"
    model: censo_anual
    explore: censo_anual
    type: looker_column
    # `<saw:selections>` columnIDs resolved against `<saw:columns>`:
    #   category      c9c9b4a20291bad9c = "Edad y Sexo"."Edad (grupos quinquenales)"
    #                                                   → dim_edad.edad_grupos_quinquenales
    #   measure (y)   c87da0157ddc02bab = "Medidas"."Personas"  → fct_censo_anual.personas
    #   seriesGenerator c51dd82505b462219 = "Edad y Sexo"."Sexo" → dim_sexo.sexo
    # Note c51dd82505b462219 is the SAME columnID as the series generator in
    # `Población por Sexo`; the two analyses share column IDs, which is why the refs
    # were resolved back to `<saw:column>` rather than assumed from position.
    fields: [dim_edad.edad_grupos_quinquenales, dim_sexo.sexo, fct_censo_anual.personas]
    # A series generator is a Looker pivot: one column series per Sexo value.
    pivots: [dim_sexo.sexo]
    # INFERRED. The XML declares no sort. GRUPOS_QUINQUENALES is zero-padded in
    # DIM_EDAD_DATA_TABLE.csv ("00 a 04" … "95 y más"), so ascending string order is
    # the natural age order, with "Desconocido/a" (the edad = -1 sentinel, R5.3) last.
    sorts: [dim_edad.edad_grupos_quinquenales]
    # `subtype="stacked"` → stacking: normal (absolute values, not percentages;
    # `percentStacked` is a separate OBIEE subtype and is not what this XML says).
    stacking: normal
    # `<saw:visualFormat color="#2986cc"/>` at series position 1, `#c90076` at
    # position 2. Keyed by value: the pivot sorts Hombre before Mujer.
    series_colors:
      Hombre: "#2986cc"
      Mujer: "#c90076"
    # `<saw:legendFormat position="default">` — legend shown, unlike the pie.
    show_legend: true
    listens_to_filters: [sexo, edad_grupos_quinquenales, anno_censo, nacionalidad_pais_nombre,
      residencia_provincia_nombre, residencia_comarca_nombre, residencia_municipio_nombre,
      residencia_municipio_codigo]
    # `<saw:canvasFormat height="200" width="1250">`. Newspaper rows are 50px, so
    # height 4 = 200px; width 24 is the full grid, matching the near-full-width 1250px
    # this chart occupies alone on the OBIEE panel (Section 0).
    row: 0
    col: 0
    width: 24
    height: 4
