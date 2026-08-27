# Port of the OBIEE analysis `Población por Sexo y Edad (Grandes grupos)` — new in the
# iteration-2 catalog export.
# Source: OBIEE/visualizacion_obiee/Análisis/Análisis - Población por Sexo y Edad (Grandes grupos).xml
#         (cp1252 bytes behind a utf-8 declaration — read through tools/catalog.py, R10.1)
#
# A dashboard rather than a Look, for the reason set out at the top of
# poblacion_por_municipio.dashboard.lookml: LookML has no Look primitive. It is also
# embedded as `<sawd:reportView name="Report 4">` of `Censo Aragón V2`.
#
# The analysis is the quinquenal one with a different age level: same three columns
# (Sexo, an Edad level, Personas), same stacked bar, same two series colours, same 8
# prompted filters. It groups by `Edad (grandes grupos)`, which is already in the IR
# and is the head of the R7.2 drill chain `drill_edad`.
#
# ── V_EDAD is deliberately NOT gated here (R9.6) ────────────────────────────────
# The analysis carries a ninth filter, `'Grupo grande' IN V_EDAD`, with
# `sawx:eval default="Grupo grande"`. Nothing on this standalone dashboard sets
# V_EDAD, so the analysis's own eval default governs and the condition is always true.
# The gate is applied on `Censo Aragón V2`, the one page carrying the `Variable_Edad`
# prompt, where it decides which of the two age groupings the user sees.
- dashboard: poblacion_por_sexo_edad_grandes_grupos
  title: "Población por Sexo y Edad (Grandes grupos)"
  layout: newspaper
  description: "Port of the OBIEE analysis `Población por Sexo y Edad (Grandes grupos)` (subject area TEST_LOOKER). Rendered as a single-element dashboard because LookML has no Look primitive."

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
  - name: poblacion_por_sexo_edad_grandes_grupos
    # `<saw:view xsi:type="saw:dvtchart">` with `<saw:display type="bar"
    # subtype="stacked">` → looker_column with `stacking: normal`.
    #
    # `looker_column`, not `looker_bar` — the same deliberate choice made for the
    # quinquenal chart: OBIEE's `type="bar"` puts the categories on `axis="X"`
    # (`<saw:categories>` → columnID c9c9b4a20291bad9c, Edad (grandes grupos)), i.e.
    # vertical bars, which Looker calls a column chart. `looker_bar` would lay the
    # same data out sideways.
    #
    #   c51dd82505b462219  "Edad y Sexo"."Sexo"                    → seriesGenerator
    #   c9c9b4a20291bad9c  "Edad y Sexo"."Edad (grandes grupos)"   → category (X)
    #   c87da0157ddc02bab  "Medidas"."Personas"                    → measure (Y)
    #
    # The tile title is the reportView caption; the analysis's own `titleView!1`
    # caption is `Población por sexo y gran grupo de edad`, kept in `description`
    # rather than silently replacing the catalog name.
    title: "Población por Sexo y Edad (Grandes grupos)"
    model: censo_anual
    explore: censo_anual
    type: looker_column
    fields: [dim_edad.edad_grandes_grupos, dim_sexo.sexo, fct_censo_anual.personas]
    pivots: [dim_sexo.sexo]
    # INFERRED. The XML declares no sort. Ascending by the age level keeps the groups
    # in age order, which is the order the bars carry in OBIEE; Looker's own default
    # would sort by the measure and shuffle the age axis.
    sorts: [dim_edad.edad_grandes_grupos]
    stacking: normal
    # `<saw:seriesFormatRule>` position 1 → #2986cc, position 2 → #c90076. Position is
    # series order, and the series generator is Sexo, whose members sort
    # Hombre, Mujer — so the colours are keyed by name rather than by index.
    series_colors:
      Hombre: "#2986cc"
      Mujer: "#c90076"
    show_legend: true
    listens_to_filters: [sexo, edad_grupos_quinquenales, anno_censo, nacionalidad_pais_nombre,
      residencia_provincia_nombre, residencia_comarca_nombre, residencia_municipio_nombre,
      residencia_municipio_codigo]
    # `<saw:canvasFormat height="200" width="1250">`. Newspaper rows are 50px → 4.
    row: 0
    col: 0
    width: 24
    height: 4
