[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 20
  ny = 20
  xmax = 2
  ymax = 2
[]

[Variables]
  [temperature]
  []
[]

[Kernels]
  [heat_conduction]
    type = ADHeatConduction
    variable = temperature
  []
  [./heat_source]
    type = ADMatHeatSource
    material_property = volumetric_heat
    variable = temperature
  [../]
[]

[AuxVariables]
  [./thermal_conductivity_aux]
      order = CONSTANT
      family = MONOMIAL
  [../]
[../]


[AuxKernels]
  [./thermal_conductivity]
    type = ADMaterialRealAux
    property = thermal_conductivity
    variable = thermal_conductivity_aux
  [../]
[]

[BCs]
  [left]
    type = NeumannBC
    variable = temperature
    boundary = left
    value = 0
  []
  [right]
    type = NeumannBC
    variable = temperature
    boundary = right
    value = 0
  []
  [bottom]
    type = DirichletBC
    variable = temperature
    boundary = bottom
    value = 200
  []
  [top]
    type = DirichletBC
    variable = temperature
    boundary = top
    value = 100
  []
[]

[Functions]
  [thermo_conduct]
    type = ParsedFunction
    value = 'if (x> 0.5 & x <1.5, h1, h2)'
    vars = 'h1 h2'
    vals = 'p1 p2'
  []
[]

[Materials]
  [steel]
    type = ADGenericFunctionMaterial
    prop_names = 'thermal_conductivity'
    prop_values = 'thermo_conduct'
  []
  [volumetric_heat]
    type = ADGenericFunctionMaterial
    prop_names = 'volumetric_heat'
    prop_values = '1000'
  []
[]

[Executioner]
  type = Steady
  solve_type = PJFNK
  nl_abs_tol = 1e-6
  nl_rel_tol = 1e-8
  petsc_options_iname = '-pc_type -pc_hypre_type'
  petsc_options_value = 'hypre boomeramg'
[]

[Postprocessors]
  [p1]
    type = ConstantValuePostprocessor
    value = 100 # true sol = 10
    execute_on = 'initial linear'
  []
  [p2]
    type = ConstantValuePostprocessor
    value = 100 # true sol = 5
    execute_on = 'initial linear'
  []
[]

[VectorPostprocessors]
  [data_pt]
    type = PointValueSampler
    points = '0.2 0.2 0
              0.8 0.6 0
              0.2 1.4 0
              0.8 1.8 0'
    variable = temperature
    sort_by = x
  []
[]

[Controls]
  [parameterReceiver]
    type = ControlsReceiver
  []
[]

[Outputs]
  console = false
  exodus = true
  csv=true
  file_base = 'forward'
[]
