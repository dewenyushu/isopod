[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 10
  ny = 10
  xmax = 1
  ymax = 1
[]

[GlobalParams]
  displacements = 'disp_x disp_y'
[]

[Variables]
  [./disp_x]
  [../]
  [./disp_y]
  [../]
[]

[Modules/TensorMechanics/Master]
  [./block1]
    strain = SMALL
    add_variables = true
    generate_output = 'stress_xx stress_yy stress_xy strain_xx strain_yy strain_xy'
  [../]
[]

[Materials]
  [./E]
    type = GenericFunctionMaterial
    prop_names = 'youngs_modulus'
    prop_values = 'piecewise_E'
  [../]
  [./nu]
    type = GenericConstantMaterial
    prop_names = 'poissons_ratio'
    prop_values = '0.3'
  [../]
  [./elasticity_tensor]
    type = ComputeVariableIsotropicElasticityTensor
    youngs_modulus = youngs_modulus
    poissons_ratio = poissons_ratio
    args = 'disp_x disp_y'
  [../]
  [./stress]
    type = ComputeLinearElasticStress
  [../]
[]

[Functions]
  [piecewise_E]
    type = ParsedFunction
    value = 'if (x> 0.3 & x <0.7, E1, E2)'
    vars = 'E1 E2'
    vals = 'p1 p2'
  []
[]

[AuxVariables]
  [./youngs_modulus_aux]
      order = CONSTANT
      family = MONOMIAL
  [../]
  [./poissons_ratio_aux]
      order = CONSTANT
      family = MONOMIAL
  [../]
[../]


[AuxKernels]
  [./youngs_modulus]
    type = MaterialRealAux
    property = youngs_modulus
    variable = youngs_modulus_aux
  [../]
  [./poissons_ratio]
    type = MaterialRealAux
    property = poissons_ratio
    variable = poissons_ratio_aux
  [../]
[]

[BCs]
  [ux_left]
    type = NeumannBC
    variable = disp_x
    boundary = left
    value = 0
  []
  [uy_left]
    type = NeumannBC
    variable = disp_y
    boundary = left
    value = 0
  []
  [ux_right]
    type = NeumannBC
    variable = disp_x
    boundary = right
    value = 0
  []
  [uy_right]
    type = NeumannBC
    variable = disp_y
    boundary = right
    value = 0
  []
  [ux_bottom]
    type = DirichletBC
    variable = disp_x
    boundary = bottom
    value = 0
  []
  [uy_bottom]
    type = DirichletBC
    variable = disp_y
    boundary = bottom
    value = 0
  []
  [ux_top]
    type = NeumannBC
    variable = disp_x
    boundary = top
    value = -0.05
  []
  [uy_top]
    type = NeumannBC
    variable = disp_y
    boundary = top
    value = -0.5
  []
[]

[Preconditioning]
  [./SMP]
    type = SMP
    full = true
  [../]
[]

[Executioner]
  type = Steady
  solve_type = 'NEWTON'
  nl_abs_tol = 1e-6
  nl_rel_tol = 1e-8
  petsc_options_iname = '-ksp_type -pc_type -pc_factor_mat_solver_package'
  petsc_options_value = 'preonly lu       superlu_dist'
[]

[Postprocessors]
  [p1]
    type = ConstantValuePostprocessor
    value = 9.1
    execute_on = 'initial linear'
  []
  [p2]
    type = ConstantValuePostprocessor
    value = 5.1
    execute_on = 'initial linear'
  []
[]
#
# [VectorPostprocessors]
#   [data_pt]
#     type = PointValueSampler
#     points = '0.2 0.2 0
#               0.8 0.6 0
#               0.2 1.4 0
#               0.8 1.8 0'
#     variable = temperature
#     sort_by = x
#   []
# []

# [Controls]
#   [parameterReceiver]
#     type = ControlsReceiver
#   []
# []

[Outputs]
  console = false
  exodus = true
  csv=true
  file_base = 'forward'
[]
