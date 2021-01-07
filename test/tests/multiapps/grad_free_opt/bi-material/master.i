[StochasticTools]
[]

[FormFunction]
  type = ObjectiveMinimize
  parameter_names = 'h1 h2'
  num_values = ' 1 1'
  initial_condition = '100 100'
  data_computed_name = 'measured'
  data_target = '217 192 223 132'
[]

[Executioner]
  type = Optimize
  tao_solver = taonm
  verbose = true
[]

[MultiApps]
  [forward]
    type = OptimizeFullSolveMultiApp
    input_files = forward.i
    execute_on = "FORWARD"
  []
[]

[Transfers]
  [toforward]
    type = OptimizationParameterTransfer
    multi_app = forward
    to_control = parameterReceiver
    value_names = 'h1 h2'
    parameters = ' Postprocessors/p1/value Postprocessors/p2/value'
  []

  [fromforward]
    type = MultiAppReporterTransfer
    multi_app = forward
    direction = from_multiapp
    from_reporters = 'data_pt/temperature data_pt/temperature'
    to_reporters = 'measured/values FormFunction/measured'
  []
[]

[Reporters]
  [measured]
    type = ConstantReporter
    real_vector_names = values
    real_vector_values = '0 0 0 0'
  []
[]

[Outputs]
  console = true
  csv=true
[]
