[StochasticTools]
[]

[FormFunction]
  type = QuadraticMinimize
  parameter_names = 'results'
  num_values = 3
  initial_condition = '5 8 1'

  objective = 1.0
  solution = '1 2 3'
[]

[Executioner]
  type = Optimize
  tao_solver = TAOCG
  solve_on = none
  verbose = true
[]

[Outputs]
  csv = true
[]
