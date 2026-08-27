# Phase 5 content — port of the OBIEE analysis `Población por Municipio`.
# Source: OBIEE/visualizacion_obiee/Análisis/Análisis - Población por Municipio.xml
#
# WHY THIS IS A DASHBOARD AND NOT A "LOOK".
# The migration plan (§5 Phase 5) calls for "the 3 analyses as Looks". LookML has no
# Look primitive: a Look is a user-created object stored in the Looker instance's
# internal database, not a file a project can contain. The nearest thing a LookML
# project can hold — and the only one that is version-controlled, reviewable and
# deployable the way this migration requires — is a single-element LookML dashboard,
# which is independently viewable and linkable exactly as a Look is. So this file is
# ONE analysis, not a change of scope. It is also embedded, unchanged, as an element of
# censo_aragon.dashboard.lookml (reportView "Report 0").
#
# This is the awkward one: two inline FILTER columns, a grand
# total row, and a density column that surfaces Maleján. All three are handled below.
- dashboard: poblacion_por_municipio
  title: "Población por Municipio"
  layout: newspaper
  description: "Port of the OBIEE analysis `Población por Municipio` (subject area TEST_LOOKER). Rendered as a single-element dashboard because LookML has no Look primitive."

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
  - name: poblacion_por_municipio
    # `<saw:tableView name="tableView!1" scrollingEnabled="true" width="1500"
    # height="350">` → looker_grid.
    title: "Población por Municipio"
    model: censo_anual
    explore: censo_anual
    type: looker_grid
    # The six columns, in the XML's own order. `<saw:edgeLayers>` on the row edge
    # repeats the same six columnIDs in the same order, so the layout confirms it.
    #
    #   c3f86cd3cfd6495cb  "Lugar de Residencia"."Residencia municipio código"
    #   ca4d9d014d41be794  "Lugar de Residencia"."Residencia municipio nombre"
    #   c905daa8e4ea393a9  FILTER("Medidas"."Personas" USING "Edad y Sexo"."Sexo" = 'Hombre')
    #   cebd1374b5acd1ac4  FILTER("Medidas"."Personas" USING "Edad y Sexo"."Sexo" = 'Mujer')
    #   c87da0157ddc02bab  "Medidas"."Personas"
    #   c485267e440323d1a  "Indicadores"."Densidad de población (municipio)"
    #
    # R9.3 — the two FILTER columns are NOT new measures. They resolve to the existing
    # R2 helpers `personas_sexo_1` / `personas_sexo_6`, surfaced as the visible
    # `poblacion_hombres` / `poblacion_mujeres` (tools/lookml_measures.py,
    # ANALYSIS_SEX_COLUMNS) because a `hidden: yes` helper cannot be named by a
    # dashboard element. The analysis filters the label ('Hombre'/'Mujer') and the
    # helper filters the code ('1'/'6'); DIM_SEXO_DATA_TABLE.csv is exactly three rows
    # (1 Hombre, 6 Mujer, 0 Desconocido/a), so the two predicates select identical
    # rows. That verified mapping is the whole justification — an extract that
    # renumbered the codes would invalidate it silently.
    #
    # `densidad_municipio` is the GUARDED variant (DENSITY_UNKNOWN_AREA=null in .env,
    # R4.3). The bug-port twin `densidad_municipio_obiee` exists and can be swapped in
    # here if IAEST rules that Aragón's published area assumes OBIEE's -1 behaviour.
    # BLK-006: this element surfaces Maleján (50156) at municipio grain, whose area is
    # 0 — the query that hard-errors in OBIEE and in an unguarded BigQuery. R4.6's
    # row-level guard in mart.dim_territorio is what lets it render at all; the cell
    # comes back empty rather than killing the tile.
    fields: [dim_territorio.residencia_municipio_codigo, dim_territorio.residencia_municipio_nombre,
      fct_censo_anual.poblacion_hombres, fct_censo_anual.poblacion_mujeres,
      fct_censo_anual.personas, fct_censo_anual.densidad_municipio]
    # `<saw:columnHeading><saw:caption>` for each of the six, verbatim. These override
    # the RPD captions carried by the view `label:`s, which is what the analysis does.
    series_labels:
      dim_territorio.residencia_municipio_codigo: "Cod. Municipio"
      dim_territorio.residencia_municipio_nombre: "Municipio"
      fct_censo_anual.poblacion_hombres: "Población (Hombres)"
      fct_censo_anual.poblacion_mujeres: "Población (Mujeres)"
      fct_censo_anual.personas: "Población"
      fct_censo_anual.densidad_municipio: "Densidad de población"
    # `<saw:displayGrandTotals><saw:displayGrandTotal id="gt_row"
    # grandTotalPosition="after"/>` — a grand-total row after the data, which is the
    # only place looker_grid puts it.
    show_totals: true
    # With series_labels supplying the exact OBIEE headings, the view-name prefix would
    # double them up. The OBIEE `<saw:tableHeading>` band above the headings
    # (Lugar de Residencia | Medidas | Indicadores) has no looker_grid equivalent —
    # logged as unexpressible in the Phase 5 report.
    show_view_names: false
    # INFERRED. The XML declares no sort. Ascending municipio code is the row-edge
    # order OBIEE returns for a table whose leading edge layer is that column; Looker's
    # own default would instead sort by the first measure descending, which would
    # reorder the table visibly.
    sorts: [dim_territorio.residencia_municipio_codigo]
    # INFERRED, and load-bearing. `scrollingEnabled="true"` means the OBIEE table is
    # unlimited; Looker's default row limit is 500 and the fact reaches 731 territories
    # so the default would SILENTLY TRUNCATE the table and
    # the grand total with it. 5000 clears the whole dimension (8,376 rows) with room.
    limit: 5000
    listens_to_filters: [sexo, edad_grupos_quinquenales, anno_censo, nacionalidad_pais_nombre,
      residencia_provincia_nombre, residencia_comarca_nombre, residencia_municipio_nombre,
      residencia_municipio_codigo]
    # Number formats are NOT set here: they already match at the view level. The three
    # population columns are `<saw:dataFormat commas="true" minDigits="0"
    # maxDigits="0">` and carry `value_format_name: decimal_0` (`#,##0`); density is
    # `minDigits="2" maxDigits="2" commas="true"` and carries `decimal_2` (`#,##0.00`).
    # Overriding per element would duplicate a rule that is already correct one layer
    # down — and would then drift from it.
    #
    # `<saw:tableView width="1500" height="350">`. Newspaper rows are 50px → height 7.
    row: 0
    col: 0
    width: 24
    height: 7
